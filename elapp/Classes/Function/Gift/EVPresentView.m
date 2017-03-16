//
//  EVPresentView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPresentView.h"
#import "EVHeaderView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVLoginInfo.h"
#import "EVPresentHeaderView.h"
#import "EVSDKLiveEngineParams.h"

@interface EVPresentView ()<EVPresentHeaderViewDelegate>

/** 容器 */
@property (nonatomic, weak) UIView *containerView;

/** 头像 */
@property (nonatomic, weak) EVHeaderImageView *logoImageView;

/** 昵称 */
@property (nonatomic, weak) UILabel *nickNameLabel;

/** 通告内容 */
@property (nonatomic, weak) UILabel *contentLabel;

/** 礼物图片 */
@property (nonatomic, weak) UIImageView *presentImageView;

/** 礼物个数label */
@property (nonatomic, weak) UILabel *numLabel;

/** 礼物队列 */
@property (nonatomic, strong) NSMutableArray *presentQueue;

/** 是否正在执行连发动画，表示自己在发礼物 */
@property (nonatomic, assign) BOOL isPerformRepeat;

/** 开始执行连发动画，停止正在进行的动画 */
@property (nonatomic, assign) BOOL beginPerformRepeat;

/** 正在执行礼物的动画，别人发的 */
@property (nonatomic, strong) EVStartGoodModel *isAnimatingPresent;

/** 所有礼物 */
@property (nonatomic, strong) NSArray *presentArr;

/** 自己的账号 */
@property (nonatomic,copy) NSString *currUserName;

/** 自己的名字 */
@property (nonatomic,copy) NSString *currUserNickName;

/** 自己的头像 */
@property (nonatomic,copy) NSString *currUserLogourl;

/** 数字描边 */
@property ( nonatomic, strong ) NSMutableAttributedString *numLabelAttributeStr;

/** 上面的礼物条 */
@property (nonatomic, weak)EVPresentHeaderView *presentHeaderView;

/** 下面的礼物条 */
@property (nonatomic, weak)EVPresentHeaderView *presentHeaderViewTwo;

/** 当前展示的礼物 */
@property ( nonatomic, strong ) EVStartGoodModel *currPresent;

@end

@implementation EVPresentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _presentQueue = [NSMutableArray array];
        _isPerformRepeat = NO;
        [self setUpHeaderView];
        EVLoginInfo *info = [EVLoginInfo localObject];
        _currUserName = info.name;
        _currUserNickName = info.nickname;
        _currUserLogourl = info.logourl;
    }
    return self;
}


- (void)setUpHeaderView
{
    self.backgroundColor = [UIColor clearColor];
    EVPresentHeaderView *presentHeaderView = [[EVPresentHeaderView alloc]init];
    presentHeaderView.delegate = self;
    [self addSubview:presentHeaderView];
    self.presentHeaderView = presentHeaderView;
    [presentHeaderView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
    [presentHeaderView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [presentHeaderView autoSetDimensionsToSize:CGSizeMake(210, 42)];
    [presentHeaderView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    presentHeaderView.hidden = YES;
    
    
    EVPresentHeaderView *presentHeaderViewTwo = [[EVPresentHeaderView alloc]init];
    presentHeaderViewTwo.delegate = self;
    [self addSubview:presentHeaderViewTwo];
    self.presentHeaderViewTwo = presentHeaderViewTwo;
    [presentHeaderViewTwo autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:-15];
    [presentHeaderViewTwo autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [presentHeaderViewTwo autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:presentHeaderView];
    [presentHeaderViewTwo autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:presentHeaderView];
    [presentHeaderViewTwo autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    presentHeaderViewTwo.hidden = YES;
}


- (void)pushPresents:(NSArray *)presents
{
    // 当前没有在执行任何动画的时候，才可以执行最新的动画
    BOOL canAni = !self.presentHeaderView.isAnimating || !self.presentHeaderViewTwo.isAnimating;
    // 去除自己的礼物
    NSMutableArray *mPresents = [NSMutableArray arrayWithArray:presents];
    for ( NSDictionary *present in presents ) {
        if (!present || [present[EVMessageKeyNm] isEqualToString:_currUserName]) {
            [mPresents removeObject:present];
        }
    }
    if ( mPresents.count == 0 ) {
        return;
    }
    // 礼物和表情都要有一个从左侧出来的动画
    [self.presentQueue addObjectsFromArray:mPresents];
    
    // 初始化并执行礼物动画
    if ( canAni ) {
        [self nextAnimationPresent];
    }
}

- (void)nextAnimationPresent
{
    // 当前正在执行连发动画，不能进行动画
    if ( self.isPerformRepeat ) {
        return;
    }
    
    // 根据礼物id找到礼物的其他属性
    NSDictionary *present = self.presentQueue.firstObject;
    if ( (self.presentHeaderView.isAnimating || self.presentHeaderViewTwo.isAnimating) && self.presentQueue.count > 1) {
        present = self.presentQueue[1];
    }
    
    for (EVStartGoodModel *localPresent in self.presentArr) {
        
        NSLog(@"---------------------- %@",present[@"gid"]);
        if (localPresent.ID == [present[@"gid"] integerValue]) {
            self.isAnimatingPresent = localPresent;
            if (localPresent.anitype == EVPresentAniTypeRedPacket || localPresent.anitype == EVPresentAniTypeZip) {
                if (localPresent.anitype == EVPresentAniTypeZip) {
                    [self performCenterAnimationWithPresent:localPresent time:[present[@"gct"] integerValue] mine:NO nickName:present[@"nm"]];
                }
                [self.presentQueue removeObject:present];
                if ( self.presentQueue.count >= 1 ) {
                    [self nextAnimationPresent];
                    
                }
                break;
            }
            
            EVPresentHeaderView * headerView = self.presentHeaderView.isAnimating ? self.presentHeaderViewTwo : self.presentHeaderView;
            headerView.numberAniTime = [present[@"gct"] integerValue];
            NSLog(@"------------- %@",present[@"nm"]);
            [self animateContentWithNickname:present[@"nk"] presentImage:present[@"glg"] number:headerView.numberAniTime presentName:localPresent.name logoUrl:present[@"lg"] headerView:headerView];
            [self startAnimationWithHeaderView:headerView];
            [self performCenterAnimationWithPresent:localPresent time:headerView.numberAniTime mine:NO nickName:present[@"nm"]];
            break;
        }
    }
}

// 通知代理动画已经开始执行
- (void)performCenterAnimationWithPresent:(EVStartGoodModel *)present time:(NSInteger)time mine:(BOOL)mine nickName:(NSString *)nickName
{
    if (present.type == EVPresentTypePresent && self.delegate && [self.delegate respondsToSelector:@selector(animationWithPresent:time:mine:nickName:)]) {
        [self.delegate animationWithPresent:present time:time mine:mine nickName:nickName];
    }
}

// 根据动画内容对控件进行赋值
- (void)animateContentWithNickname:(NSString *)nickname
                      presentImage:(NSString *)imageStr
                            number:(NSInteger)number
                       presentName:(NSString *)presentName
                           logoUrl:(NSString *)logourl
                        headerView:(EVPresentHeaderView *)headerView
{
    headerView.presentImageView.image = [UIImage imageWithContentsOfFile:PRESENTFILEPATH([imageStr md5String])];
    NSLog(@"path----------------  %@",PRESENTFILEPATH([imageStr md5String]));
    //UIImage *imageV = [UIImage imageWithContentsOfFile:PRESENTFILEPATH([imageStr md5String])];
    headerView.numLabel.text = [NSString stringWithFormat:@"×1"];
    headerView.contentLabel.text = [NSString stringWithFormat:@"送出了%@",presentName];
    headerView.nickNameLabel.text = nickname;
    [headerView.logoImageView cc_setImageWithURLString:logourl placeholderImage:[UIImage imageWithALogoWithSize:headerView.logoImageView.frame.size isLiving:NO]];
}

// 连发动画
- (void)performRepeatAnimateWithNumber:(NSInteger)number
                               present:(EVStartGoodModel *)present
{
    self.currPresent = present;
    self.isPerformRepeat = YES;
    // 初始化连发需要的条件
    if ( 1 == number ) {
       
        self.presentHeaderView.didTime = 1;
        self.beginPerformRepeat = YES;
        
        [self animateContentWithNickname:_currUserNickName
                            presentImage:present.pic
                                  number:number
                             presentName:present.name
                                 logoUrl:_currUserLogourl headerView:self.presentHeaderView];
        [self startAnimationWithHeaderView:self.presentHeaderView];
        
        if ( present.type == EVPresentTypePresent ) {
            [self performCenterAnimationWithPresent:present time:1 mine:YES nickName:_currUserNickName];
        }
        // 连发
    } else {
        
        self.presentHeaderView.didTime++;
        [self numberAnimationWithHeaderView:self.presentHeaderView];
    }
}

- (void)dealloc
{
    EVLog(@"CCPresentView dealloc");
    [_presentQueue removeAllObjects];
    _presentQueue = nil;
    [_presentHeaderView.layer removeAllAnimations];
    [_presentHeaderViewTwo.layer removeAllAnimations];
    _containerView = nil;
    [_presentHeaderView.numLabel.layer removeAllAnimations];
    _numLabel = nil;
}

// 初始化动画数据
- (void)startAnimationWithHeaderView:(EVPresentHeaderView *)headerView
{
    [headerView bringSubviewToFront:headerView];
    headerView.isAnimating = YES;
    headerView.hidden = NO;
    headerView.didTime = 1;
    // 如果正在执行别人的礼物动画，就把当前在执行的礼物从礼物数组中移除
    if ( self.isAnimatingPresent && self.isPerformRepeat )
    {
        [self.presentQueue removeObject:self.presentQueue.lastObject];
    }
    [headerView.layer removeAllAnimations];
    [headerView.numLabel.layer removeAllAnimations];

    // 先从外边移入
    [headerView.layer addAnimation:headerView.moveInAnimation forKey:@"moveIn"];
}

// 移除动画
- (void)outAnimationWithHeaderView:(EVPresentHeaderView *)headerView
{
    [headerView.layer addAnimation:headerView.moveOutAnimation forKey:@"moveOut"];
}

// 数字动画
- (void)numberAnimationWithHeaderView:(EVPresentHeaderView *)headerView
{
    // 文字描边描边
    NSString *timeStr = [NSString stringWithFormat:@"%@×%d", kE_GlobalZH(@"send_gift_num"), (int)headerView.didTime];
    NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSStrokeColorAttributeName: [UIColor evMainColor], NSForegroundColorAttributeName: [UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0}];
    headerView.numLabel.attributedText = mAttStr;
    
    [headerView.numLabel.layer addAnimation:headerView.scaleAnimation forKey:@"scaleAnimation"];
}

- (void)stopRepeatAnimation
{
    [self outAnimationWithHeaderView:self.presentHeaderView];
}

- (void)animationDidStop:(CAAnimation *)anim headerView:(EVPresentHeaderView *)headerView
{
    // 进入动画结束
    if ( [[anim valueForKey:@"id"] isEqualToString:MoveInAnimationId]) {
        
        [self numberAnimationWithHeaderView:headerView];
    } else if ( [[anim valueForKey:@"id"] isEqualToString:MoveOutAnimationId]) {
       
        [self moveOutAnimationHeaderView:headerView];
    } else if ( [[anim valueForKey:@"id"] isEqualToString:ScaleAnimationId]) {
        // 别人的礼物动画
        if ( !self.isPerformRepeat ) {
            // 自己开始发礼物，结束礼物动画
            if ( self.beginPerformRepeat ) {
                
                [self outAnimationWithHeaderView:headerView];
                
            } else {
                if ( headerView.didTime < headerView.numberAniTime ) {
                    
                    headerView.didTime++;
                    [self numberAnimationWithHeaderView:headerView];
                    
                } else {
                    
                    [self outAnimationWithHeaderView:headerView];
                    
                }
            }
        } else {
            
            if ( headerView == self.presentHeaderView ) {
                
                self.beginPerformRepeat = NO;
                
                if ( self.currPresent.anitype == EVPresentAniTypeRedPacket ) {
                    [self outAnimationWithHeaderView:headerView];
                }
            } else {
                
                if ( headerView.didTime < headerView.numberAniTime ) {
                    headerView.didTime++;
                    [self numberAnimationWithHeaderView:headerView];
                } else {
                    [self outAnimationWithHeaderView:headerView];
                }
                
            }
        }
    }
}

- (void)moveOutAnimationHeaderView:(EVPresentHeaderView *)headerView
{
    headerView.isAnimating = NO;
    // 一次动画结束，进入下一次动画
    if ( !self.isPerformRepeat ) // 别人发，移除刚执行的动画元素
    {
        if ( self.presentQueue.count > 0 )
        {
            [self.presentQueue removeObject:self.presentQueue.firstObject];
        }
    }
    headerView.didTime = 0;
    self.isPerformRepeat = NO;
    if ( self.presentQueue.count > 1 || (!self.presentHeaderView.isAnimating && !self.presentHeaderViewTwo.isAnimating && self.presentQueue.count > 0) ) // 如果礼物数组不为空，继续执行下一个动画
    {
        // 执行下一次动画，把已经执行的数字置为初始状态
        [self nextAnimationPresent];
    }
}


- (NSArray *)presentArr
{
    if (!_presentArr)
    {
        NSArray *presents = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypePresent];
        NSArray *emojis = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypeEmoji];
        NSMutableArray *presentArr = [NSMutableArray arrayWithArray:presents];
        [presentArr addObjectsFromArray:emojis];
        _presentArr = presentArr;
    }
    return _presentArr;
}

@end
