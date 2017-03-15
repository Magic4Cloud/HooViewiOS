//
//  EVMagicEmojiView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMagicEmojiView.h"
#import <PureLayout/PureLayout.h>
#import "EVMagicEmojiCell.h"
#import "EVMagicEmojiModel.h"
#import "EVMagicEmojiLayout.h"
#import "EVStartGoodModel.h"
#import "EVStartResourceTool.h"
#import "EVAlertManager.h"
#import "EVLoginInfo.h"

const CGFloat headerBtnWidth = 45;
NSString * const magicCellID = @"magiccellID";
#define BtnSelectedColor [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3]

static CGFloat const selfHeight = 346.f;
static CGFloat const pageHeight = 8.f;
static CGFloat const footerViewHeight = 49.f;
static CGFloat const collectionViewHeight = 292.f;

@interface EVMagicEmojiView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

/** 切换种类的View */
@property (nonatomic, weak) UIView *headerView;

/** 展示内容的CollectionView */
@property (nonatomic, weak) UICollectionView *contentCollectionView;

/** 狂刷按钮 */
@property (nonatomic, weak) UIButton *repeatBtn;

/** 发送按钮 */
@property (nonatomic, weak) UIButton *sendBtn;

/** 发送的个数 */
@property (nonatomic, assign) NSInteger sendNum;

/** 选中的表情 */
@property (nonatomic, strong) EVStartGoodModel *selectedMagicEmoji;

/** 分页 */
@property (nonatomic, weak) UIPageControl *pageControl;

/** 显示火眼豆数量的按钮 */
@property (nonatomic, weak) UIButton *yibiBtn;

/** 表情菜单的底部容器view */
@property (nonatomic,weak) UIView *emojiContainView;

/** 选择的礼物需要消耗的薏米 */
@property (nonatomic, assign) NSInteger tempMinusBarley;

/** 选择的礼物需要消耗的火眼豆 */
@property (nonatomic, assign) NSInteger tempMinusEcoin;

/** 充值按钮 */
@property (nonatomic, weak) UIButton *rechargeBtn;

/** 无响应时间 */
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) BOOL hasHidden;

// 表情数据源
@property (nonatomic,strong) NSArray *expressionGifts;
@property (nonatomic,weak) UIButton *emojiButton;
@property ( nonatomic, weak ) UIImageView *emojiLine;

// 礼物数据源
@property (nonatomic,strong) NSArray *presentsGifts;
@property (nonatomic,weak) UIButton *giftButton;
@property ( nonatomic, weak ) UIImageView *giftLine;

/** 当前选中的表情tab */
@property (nonatomic,weak) UIButton *selectTabButton;

/** 所有的表情 */
@property (nonatomic, strong) NSArray<EVStartGoodModel *> *magicEmojis;

@end

@implementation EVMagicEmojiView

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialData];
        [self setUpSubViews];
        [EVNotificationCenter addObserver:self selector:@selector(calTimer) name:EVUpdateTime object:nil];
    }
    return self;
}

// 初始化数据
- (void)initialData
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    self.barley = loginInfo.barley;
    self.ecoin = loginInfo.ecoin;
}

// 设置发送礼物数量
- (void)setSendNum:(NSInteger)sendNum
{
    _sendNum = sendNum;
    
    // 要发送的礼物数量改变后，通知外面
    if ( sendNum && self.delegate && [self.delegate respondsToSelector:@selector(changeSendAmountOfPresentsWithNumber:present:)] )
    {
        [self.delegate changeSendAmountOfPresentsWithNumber:sendNum present:self.selectedMagicEmoji];
    }
}

// 计算时间
- (void)calTimer
{
    // 如果没有发送个数就不计时
    if ( !self.sendNum )
    {
        return;
    }
    self.time++;

    // 2s内没有点击连发按钮，默认发送，并且把所有状态置为初始
    if ( self.time >= 2 )
    {
        EVLog(@"send present +++++++++++++");
        [self sendPresent];
        [self origin];
        self.sendBtn.selected = YES;
    }
}

+ (instancetype)magicEmojiViewToTargetView:(UIView *)targetView
{
    UIView *emojiContainView = [[UIView alloc] init];
    emojiContainView.backgroundColor = [UIColor evTextColorH1];
    emojiContainView.alpha = 0.8;
    [targetView addSubview:emojiContainView];
    [emojiContainView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    [emojiContainView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - selfHeight)];
//    [emojiContainView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [emojiContainView]
    
    EVMagicEmojiView *emoji = [[EVMagicEmojiView alloc] init];
    [targetView addSubview:emoji];
    emoji.backgroundColor = [UIColor whiteColor];
    emoji.alpha = 1.0;
    emoji.emojiContainView = emojiContainView;
    
    //之前是280 现在不要上面的条就改为240
    [emoji autoSetDimension:ALDimensionHeight toSize:selfHeight];
    [emoji autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [emoji autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [emoji autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [emoji setUpEmojiContainViewTap];
    [emoji hide];
    
    // 连刷按钮
    UIButton *repeatSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repeatSendBtn setImage:[UIImage imageNamed:@"living_fusilladed"] forState:UIControlStateNormal];
    [repeatSendBtn setImage:[UIImage imageNamed:@"living_fusilladed_click"] forState:UIControlStateHighlighted];
    repeatSendBtn.adjustsImageWhenHighlighted = YES;
    repeatSendBtn.hidden = YES;
    [repeatSendBtn addTarget:emoji action:@selector(repeatSend) forControlEvents:UIControlEventTouchDown];
    [emojiContainView addSubview:repeatSendBtn];
    [repeatSendBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [repeatSendBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    emoji.repeatBtn = repeatSendBtn;
    
    return emoji;
}

- (void)setUpEmojiContainViewTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [_emojiContainView addGestureRecognizer:tap];
    
    // 拖拽手势,用来拦截scrollview的拖拽事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
    [_emojiContainView addGestureRecognizer:pan];
}

- (void)pan
{
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:_emojiContainView];
    if ( CGRectContainsPoint(self.frame, touchPoint) )
    {
        return NO;
    }
    return YES;
}

// 展示
- (void)show
{
    [self.layer removeAllAnimations];
    [self.repeatBtn.layer removeAllAnimations];
    
    self.hasHidden = NO;
    self.emojiContainView.hidden = NO;
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    self.emojiContainView.userInteractionEnabled = YES;
}

// 收起
- (void)hide
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(magicEmojiViewHidden)] )
    {
        [self.delegate magicEmojiViewHidden];
    }
    
    self.hasHidden = YES;
    [self origin];
    self.emojiContainView.hidden = YES;
    self.hidden = YES;
}

// 所有内容恢复原始状态
- (void)origin
{
    // 发送按钮
    self.sendBtn.hidden = NO;
    // 重复按钮
    self.repeatBtn.hidden = YES;
    
    [self.contentCollectionView reloadData];
}

// 发送礼物
- (void)sendPresent
{
    if (self.sendNum && self.delegate && [self.delegate respondsToSelector:@selector(sendMagicEmojiWithEmoji:num:)])
    {
        [self.delegate sendMagicEmojiWithEmoji:self.selectedMagicEmoji
                                           num:self.sendNum];
    }
    [self hide];
    self.sendNum = 0;
    self.time = 0;
}

- (NSArray<EVStartGoodModel *> *)magicEmojis
{
    NSArray *emojis = nil;
    if ( _giftButton.selected )
    {
        emojis = _presentsGifts;
    }
    else
    {
        emojis = _expressionGifts;
    }
    NSInteger num = ceil(emojis.count / 8.0);
    self.pageControl.numberOfPages = num;
    return emojis;
}

- (void)setNoRedPacket:(BOOL)noRedPacket
{
    _noRedPacket = noRedPacket;
    [self removePresentWithRedPacketType];
    [self.contentCollectionView reloadData];
}

- (void)removePresentWithRedPacketType
{
    if ( self.noRedPacket )
    {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.presentsGifts];
        
        for ( EVStartGoodModel *good in self.presentsGifts )
        {
            if ( good.anitype == EVPresentAniTypeRedPacket )
            {
                [mArr removeObject:good];
            }
        }
        self.presentsGifts = mArr;
        self.magicEmojis = mArr;
    }
}

// 切换类型
- (void)switchBtnClick:(UIButton *)button
{
    if ( _selectTabButton == button )
    {
        return;
    }
    
    _selectTabButton.selected = NO;
    button.selected = YES;
    _selectTabButton = button;
    [_contentCollectionView reloadData];
    
    if ( _selectTabButton == _giftButton )
    {
        self.giftLine.image = [UIImage imageNamed:@"emojiLine_nor"];
        self.emojiLine.image = [UIImage imageNamed:@"emojiLine"];
    }
    else
    {
        self.emojiLine.image = [UIImage imageNamed:@"emojiLine_nor"];
        self.giftLine.image = [UIImage imageNamed:@"emojiLine"];
    }
    _yibiBtn.hidden = !(_selectTabButton == _giftButton);
    _rechargeBtn.hidden = !(_selectTabButton == _giftButton);
}

// 是否可以发送礼物
- (BOOL)canSendPresent
{
    // 要发送薏米礼物的时候，薏米不足
    if ( self.selectedMagicEmoji.costtype == 0 )
    {
        if ( self.barley == 0 || self.barley < self.selectedMagicEmoji.cost )
        {
            [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"not_more_yimi") cancelButtonTitle:nil comfirmTitle:kOK WithComfirm:^{
                
            } cancel:nil];
            [self origin];
//            self.sendBtn.userInteractionEnabled = NO;
            return NO;
        }
    }
    // 要发送火眼豆礼物的时候，火眼豆不足
    if ( self.selectedMagicEmoji.costtype == 1 )
    {
        if ( self.ecoin == 0 || self.selectedMagicEmoji.cost > self.ecoin )
        {
            [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"nil_coin") cancelButtonTitle:@"取消" comfirmTitle:kOK WithComfirm:^{
     
            } cancel:^{
                if ( self.delegate && [self.delegate respondsToSelector:@selector(yibiNotEnough)] )
                {
                    [self.delegate yibiNotEnough];
                    
                }
            }];
            [self origin];
//            self.sendBtn.userInteractionEnabled = NO;
            return NO;
        }
    }
    return YES;
}

// 点击发送按钮
- (void)sendBtnClick:(UIButton *)button
{
    if ( [self canSendPresent] )
    {
        self.sendNum = 1;
        [self changeAsset];
        self.time = 0;
        button.hidden = YES;
        // 红包礼物不支持连刷
//        if ( self.selectedMagicEmoji.anitype == EVPresentAniTypeRedPacket )
//        {
            [self sendPresent];
//        }
//        else
//        {
//            if ( self.delegate && [self.delegate respondsToSelector:@selector(magicEmojiSend)] )
//            {
//                [self.delegate magicEmojiSend];
//            };
//            self.repeatBtn.hidden = NO;
//            [self hideSelfAndShowRepeatAnimation];
//        }
    }
}

// 隐藏礼物列表，显示连发按钮动画
- (void)hideSelfAndShowRepeatAnimation
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CABasicAnimation *positonAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positonAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(bounds.size.width - 40, bounds.size.height - 40)];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.3;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[positonAnimation, scaleAnimation];
    [self.layer addAnimation:group forKey:@""];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    scaleAnimation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation2.duration = 0.3;
    scaleAnimation2.removedOnCompletion = NO;
    scaleAnimation2.fillMode = kCAFillModeForwards;
    [self.repeatBtn.layer addAnimation:scaleAnimation2 forKey:@""];
}

// 点击连刷按钮
- (void)repeatSend
{
    if ( ![self canSendPresent] )
    {
        [self sendPresent];
        self.sendNum --;
        return;
    }
    
    // 要发送的个数 + 1
    self.sendNum ++;
    
    // 恢复时间计数
    self.time = 0;
    
    [self changeAsset];
}

- (void)changeAsset
{

    // 改变薏米数和火眼豆数
    if ( self.selectedMagicEmoji.costtype == 0 && self.barley >= self.selectedMagicEmoji.cost )
    {
        self.barley -= self.selectedMagicEmoji.cost;
    }
    else if ( self.selectedMagicEmoji.costtype == 1 && self.ecoin >= self.selectedMagicEmoji.cost )
    {
        self.ecoin -= self.selectedMagicEmoji.cost;
    }
}

// 薏米数
- (void)setBarley:(NSInteger)barley
{
    _barley = barley;
}

// 火眼豆数
- (void)setEcoin:(NSInteger)ecoin
{
    _ecoin = ecoin;
    [self.yibiBtn setTitle:[NSString stringWithFormat:@"火眼豆: "] forState:UIControlStateNormal];
    NSString *rechargeTitle = [NSString stringWithFormat:@" %ld > ",self.ecoin];
    [self.rechargeBtn setTitle:rechargeTitle forState:UIControlStateNormal];}

// 点击火眼豆数量btn
- (void)rechargeBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargeYibi)])
    {
        [self.delegate rechargeYibi];
    }
}

- (UIButton *)headerButtonWithType:(EVPresentType)type
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.4] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0] forState:UIControlStateSelected];
    button.titleLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    
    if ( type == EVPresentTypeEmoji )
    {
        [button setTitle:kE_GlobalZH(@"e_emoj") forState:UIControlStateNormal];
    }
    else if ( type == EVPresentTypePresent )
    {
        [button setTitle:kE_GlobalZH(@"e_gift") forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 添加子视图
- (void)setUpSubViews
{
    // 半透明的背景
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor whiteColor];
    [self addSubview:alphaView];
    [alphaView autoPinEdgesToSuperviewEdges];
    
    // 添加头部视图
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubview:headerView];
    self.headerView.hidden = YES;
//    [headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
//    [headerView autoSetDimension:ALDimensionHeight toSize:40];
    _headerView = headerView;
    
    // 表情礼物
    _expressionGifts = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypeEmoji];
    
    // 普通礼物
    _presentsGifts = [[EVStartResourceTool shareInstance] presentsWithType:EVPresentTypePresent];
    
    if ( _expressionGifts.count != 0  && _presentsGifts.count != 0 )
    {
        UIButton *emojiButton = [self headerButtonWithType:EVPresentTypeEmoji];
        UIButton *giftButton = [self headerButtonWithType:EVPresentTypePresent];
        [headerView addSubview:emojiButton];
        [headerView addSubview:giftButton];
        
        [emojiButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [giftButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        
        [emojiButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:giftButton];
        [@[emojiButton, giftButton] autoMatchViewsDimension:ALDimensionWidth];
        [@[emojiButton, giftButton] autoMatchViewsDimension:ALDimensionHeight];
        
        self.giftLine = [self addBottomLineWithBtn:giftButton];
        self.emojiLine = [self addBottomLineWithBtn:emojiButton];
        self.giftLine.image = [UIImage imageNamed:@"emojiLine_nor"];
        
        _giftButton = giftButton;
        _emojiButton = emojiButton;
        
        // 默认选中礼物
        giftButton.selected = YES;
        _selectTabButton = giftButton;
    }
    else
    {
        UIButton *button = nil;
        if ( _expressionGifts.count )
        {
            button = [self headerButtonWithType:EVPresentTypeEmoji];
            _emojiButton = button;
        }
        else if ( _presentsGifts.count != 0 )
        {
            button = [self headerButtonWithType:EVPresentTypePresent];
            _giftButton = button;
        }
        
        if ( button )
        {
            [headerView addSubview:button];
            [button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        button.selected = YES;
        _selectTabButton = button;
    }
    
    // 表情列表
    EVMagicEmojiLayout *layout = [[EVMagicEmojiLayout alloc] init];
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    contentCollectionView.pagingEnabled = YES;
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    [contentCollectionView registerClass:[EVMagicEmojiCell class] forCellWithReuseIdentifier:magicCellID];
    [self addSubview:contentCollectionView];
    [contentCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [contentCollectionView autoSetDimension:ALDimensionHeight toSize:collectionViewHeight];
    _contentCollectionView = contentCollectionView;
    
    // 分页控制器
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.8];
    pageControl.hidesForSinglePage = YES;
    [pageControl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentCollectionView withOffset:5];
    [pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [pageControl autoSetDimension:ALDimensionHeight toSize:pageHeight];
    _pageControl = pageControl;
    
    // 尾部视图
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor evBackgroundColor];
    [self addSubview:footerView];
    [footerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [footerView autoSetDimension:ALDimensionHeight toSize:footerViewHeight];

    UIView *footContentView = [[UIView alloc] init];
    footContentView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:footContentView];
    [footContentView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [footContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [footContentView autoSetDimension:ALDimensionHeight toSize:44];
    [footContentView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
//    // 发送按钮
    CGFloat sendBtnHeight = 30.f;
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor evMainColor]];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendBtn.layer.cornerRadius = 15;
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchDown];
    [footContentView addSubview:sendBtn];
    [sendBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    [sendBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [sendBtn autoSetDimensionsToSize:CGSizeMake(70, sendBtnHeight)];
    _sendBtn = sendBtn;
    sendBtn.userInteractionEnabled = NO;
    



    // 火眼豆数量
    UIButton *yibiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yibiBtn.titleLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:12];
    [footContentView addSubview:yibiBtn];
    [yibiBtn setTitle:[NSString stringWithFormat:@"火眼豆: "] forState:UIControlStateNormal];
    _yibiBtn = yibiBtn;
    [yibiBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:16.];
    [yibiBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [yibiBtn autoSetDimension:ALDimensionWidth toSize:64 relation:NSLayoutRelationLessThanOrEqual];
    [yibiBtn setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];

    // 充值
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *rechargeTitle = [NSString stringWithFormat:@" %ld > ",self.ecoin];
        [rechargeBtn setTitle:rechargeTitle forState:UIControlStateNormal];
//#f87a2b 248 122 43
        [rechargeBtn setTitleColor:[UIColor colorWithHexString:@"#f87a3b"] forState:UIControlStateNormal];
//        UIImage *rechargeImage = [[UIImage imageNamed:@"living_icon_yimoney_more"] imageWithTintColor:[UIColor evMainColor]];
        rechargeBtn.contentMode = UIViewContentModeLeft;
//        [rechargeBtn setImage:rechargeImage forState:UIControlStateNormal];
//        rechargeBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 30, 5, -30);
//        rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, -17, 5, 17);
        rechargeBtn.titleLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:16.];
        [rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footContentView addSubview:rechargeBtn];
        [rechargeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:yibiBtn withOffset:0];
        [rechargeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [rechargeBtn autoSetDimensionsToSize:CGSizeMake(100, 33)];
    self.rechargeBtn = rechargeBtn;
}

- (UIImageView *)addBottomLineWithBtn:(UIButton *)btn
{
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiLine"]];
    
    [btn addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    return line;
}

#pragma mark - delegate and datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVMagicEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:magicCellID forIndexPath:indexPath];
    EVStartGoodModel *model = self.magicEmojis[indexPath.row];
    cell.model = model;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.magicEmojis.count;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVStartGoodModel *model = self.magicEmojis[indexPath.row];
    // 如果当前选中的这个不是已经选中的就表示更改了选中的，需要把选择的数字置为零
    if (!model.selected)
    {
        if ( self.sendNum )
        {
            [self sendPresent];
        }
        [self origin];
        self.selectedMagicEmoji.selected = NO;
    }
    self.sendBtn.userInteractionEnabled = YES;
    self.sendBtn.selected = YES;
    
    model.selected = YES;
    self.selectedMagicEmoji = model;
    
    [self.contentCollectionView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currPage = (int)scrollView.contentOffset.x / (int)scrollView.frame.size.width;
    self.pageControl.currentPage = currPage;
}

// 必须重写这个方法，这样做点击尾部视图就不会响应控制器的touchbegan了
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    EVLog(@"magic emoji view touch begin -------------------");
}

@end
