//
//  EVFloatingView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFloatingView.h"
#import "PureLayout.h"
#import "EVHeaderView.h"
#import "EVUserModel.h"


#define kFansSpace   24

@interface EVFloatingView()<CAAnimationDelegate>

@property ( weak, nonatomic ) CCHeaderImageView *headIconView;  // 头像
@property ( weak, nonatomic ) UILabel *signalLabel;             // 签名
@property ( nonatomic, weak ) UILabel *nickName;                // 昵称
@property ( weak, nonatomic ) UIImageView *sexImageView;        // 性别图标
@property ( weak, nonatomic ) UILabel *idLabel;                 // 用户id
@property ( weak, nonatomic ) UILabel *audioCountLabel;         // 音频数
@property ( weak, nonatomic ) UILabel *fansCountLabel;          // 粉丝数
@property ( weak, nonatomic ) UILabel *moneyCountLabel;         //送出的云币数
@property ( weak, nonatomic ) UILabel *focusCountLabel;         // 关注数
@property ( weak, nonatomic ) UIButton *focusButton;            // 关注按钮
@property ( weak, nonatomic ) UIButton *focusButtonTop;         // 加到上面的关注按钮
@property (nonatomic, weak) UIButton *shutupButton;             // 禁言按钮
@property ( weak, nonatomic ) UIView *separatorLine;            // 底部水平分割线
@property ( weak, nonatomic ) UIView *bottmBgView;

@property (nonatomic,weak) UIButton *cancelButton;              // 取消按钮

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint secondPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic,strong) UIImage *headerImage;

/** 被禁言用户 */
@property (nonatomic, strong) NSMutableArray *shutupUsers;

/*举报按钮   改成管理*/
@property (nonatomic,strong)UIButton *reportButton;


@property (nonatomic, weak) NSLayoutConstraint  *nickNameToIconImageConstraint;

@end

@implementation EVFloatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (UIImage *)headerImage
{
    if ( _headerImage == nil )
    {
        _headerImage = [UIImage imageNamed:@"avatar"];
    }
    return _headerImage;
}



- (void)createSubviews
{
    self.layer.cornerRadius = 6;
    // 头部图片
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    headImageView.backgroundColor = [UIColor whiteColor];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
    [headImageView autoSetDimensionsToSize:CGSizeMake(286, 305)];
    [headImageView setContentMode:UIViewContentModeScaleAspectFill];
    headImageView.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    
    // 举报按钮
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setTitle:kE_GlobalZH(@"e_report") forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:13];
    reportButton.layer.cornerRadius = 3;
    reportButton.layer.borderColor = [UIColor evTextColorH2].CGColor;
    reportButton.layer.borderWidth = .5;
    [headImageView addSubview:reportButton];
    reportButton.tag = CCFloatingViewReport;
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [reportButton autoSetDimensionsToSize:CGSizeMake(45, 21)];
    [reportButton addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    self.reportButton = reportButton;
    

    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelButton];
    cancelButton.tag = CCFloatingViewCancel;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setImage:[UIImage imageNamed:@"living_Floating_screen_close"] forState:UIControlStateNormal];
    [cancelButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [cancelButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:reportButton];
    [cancelButton addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:45.];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0.];
    [lineView autoSetDimension:ALDimensionHeight toSize:.5];
    _separatorLine = lineView;
    
    
    NSArray *titles = @[kE_GlobalZH(@"home_user"),kE_GlobalZH(@"@_user"),kE_GlobalZH(@"private_letter"),kE_GlobalZH(@"add_follow")];
    NSArray *tags = @[
                      @(CCFloatingViewHomePage),
                      @(CCFloatingViewAtTa),
                      @(CCFloatingViewMessage),
                      @(CCFloatingViewFocucs)];
    
    
    [self setBottomButtonsWithTitles:titles tags:tags superView:self];
    
    // 添加背景视图
    UIView *bottmBgView = [[UIView alloc] init];
    [self addSubview:bottmBgView];
    bottmBgView.backgroundColor = [UIColor whiteColor];
    [bottmBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView];
    [bottmBgView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
    [bottmBgView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0.];
    [bottmBgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.];
    _bottmBgView = bottmBgView;
    
  
    NSArray *anchorTitles = @[
                              kE_GlobalZH(@"@_user"),kE_GlobalZH(@"add_follow")];
    
    NSArray *anchorTags = @[
                            @(CCFloatingViewAtTa),
                            @(CCFloatingViewFocucs)];
   
    [self setBottomButtonsWithTitles:anchorTitles tags:anchorTags superView:bottmBgView];
    
   

    // 头像
    CCHeaderImageView *headIconView = [[CCHeaderImageView alloc] init];
    [self addSubview:headIconView];
    [headIconView autoSetDimensionsToSize:CGSizeMake(70.0, 70.0)];
    [headIconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:39];
    [headIconView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _headIconView = headIconView;
    [headIconView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    // 昵称
    UILabel *nickName = [UILabel new];
    [self addSubview:nickName];
    [nickName autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nickName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headIconView withOffset:15];
    self.nickName = nickName;
    
    // ID
    UILabel *idLabel = [[UILabel alloc] init];
    [self addSubview:idLabel];
    idLabel.textColor = [UIColor evTextColorH2];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.font = [UIFont systemFontOfSize:12];
    [idLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [idLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nickName withOffset:8];
    [idLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [idLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    _idLabel = idLabel;
    
    // 个性签名
    UILabel *signalLabel = [[UILabel alloc] init];
    [self addSubview:signalLabel];
    signalLabel.textColor = idLabel.textColor;
    signalLabel.font = [UIFont systemFontOfSize:12];
    signalLabel.textAlignment = NSTextAlignmentCenter;
    signalLabel.backgroundColor = [UIColor clearColor];
    [signalLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [signalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:idLabel withOffset:8];
    [signalLabel autoSetDimension:ALDimensionWidth toSize:266.0];
    signalLabel.text = kE_GlobalZH(@"nil_signature");
    _signalLabel = signalLabel;
    
    
    // 底部送出的云币、粉丝、关注
    UIFont *labelFont = [UIFont systemFontOfSize:16.0];
    UIColor *labelColor = [UIColor colorWithHexString:@"#403B37"];
    
    UIFont *countFont = [UIFont systemFontOfSize:11.0];
    UIColor *countColor = [UIColor colorWithHexString:@"#666666"];
    
    float labelWid = 286.0 / 3;
    
    UILabel *moneyCountLabel = [[UILabel alloc]init];
    moneyCountLabel.font = labelFont;
    moneyCountLabel.textColor = labelColor;
    moneyCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyCountLabel];
    self.moneyCountLabel = moneyCountLabel;
    [moneyCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:signalLabel withOffset:kFansSpace];
    [moneyCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [moneyCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.font = countFont;
    moneyLabel.textColor = countColor;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyLabel];
    moneyLabel.text = kE_GlobalZH(@"send_coin");
    [moneyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [moneyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:moneyCountLabel withOffset:5.0];
    [moneyLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    

    
    // 粉丝数
    UILabel *fansCountLabel = [[UILabel alloc] init];
    fansCountLabel.font = labelFont;
    fansCountLabel.textColor = labelColor;
    fansCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fansCountLabel];
    _fansCountLabel = fansCountLabel;
    [fansCountLabel autoConstrainAttribute:(ALAttribute)ALAxisHorizontal toAttribute:(ALAttribute)ALAxisHorizontal ofView:moneyCountLabel];
    [fansCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:moneyCountLabel withOffset:0];
    [fansCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    // 粉丝
    UILabel *fansLabel = [[UILabel alloc] init];
    fansLabel.font = countFont;
    fansLabel.textColor = countColor;
    fansLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fansLabel];
    fansLabel.text = kE_GlobalZH(@"e_fans");
    [fansLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:moneyLabel];
    [fansLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:fansCountLabel withOffset:5.0];
    [fansLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    
    
    // 关注数
    UILabel *focusCountLabel = [[UILabel alloc] init];
    [self addSubview:focusCountLabel];
    focusCountLabel.font = labelFont;
    focusCountLabel.textAlignment = NSTextAlignmentCenter;
    focusCountLabel.textColor = labelColor;
    [focusCountLabel autoConstrainAttribute:(ALAttribute)ALAxisHorizontal toAttribute:(ALAttribute)ALAxisHorizontal ofView:moneyCountLabel];
    [focusCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fansCountLabel withOffset:0];
    [focusCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    _focusCountLabel = focusCountLabel;
    
    // 关注
    UILabel *focusLabel = [[UILabel alloc] init];
    focusLabel.font = countFont;
    focusLabel.textColor = countColor;
    focusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:focusLabel];
    focusLabel.text = kNavigatioBarFollow;
    [focusLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fansLabel];
    [focusLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:focusCountLabel withOffset:5.0];
    [focusLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
   
}
/**
 *  设置底部按钮
 *
 *  @param titles 所有按钮的title
 *  @param tags   所有按钮与title相对应的tag
 */
- ( void )setBottomButtonsWithTitles:(NSArray *)titles tags:(NSArray *)tags superView:(UIView *)superView
{
    // 按钮颜色
//    UIColor *buttonColor = [UIColor colorWithHexString:kGlobalGreenColor];
    UIColor *buttonColor = CCColor(98, 45, 128);

    // 分割线颜色
    UIColor *lineColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 按钮字体
    UIFont *buttonFont = [UIFont boldSystemFontOfSize:13];
    
    // 按钮数量
    NSInteger count = tags.count;
    
    // 标记当前要添加的按钮左侧的按钮
    UIButton *leftButton;
    
    for (int i = 0; i < count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [superView addSubview:button];
        if ( i == 0 )
        {
            // 设置第一个按钮的约束
            [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:1.0 / count];
            [button autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
            [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.];
            [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_separatorLine];
        }
        else
        {
            // 设置后面按钮的约束
            [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:leftButton];
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftButton];
            [button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftButton];
        }
        
        if ( i < count - 1 )
        {
            // 添加分割线
            UIView *line1 = [[UIView alloc] init];
            [superView addSubview:line1];
            line1.backgroundColor = lineColor;
            [line1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:button];
            [line1 autoSetDimensionsToSize:CGSizeMake(.5, 22)];
            [line1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:button];
        }
        
        // 设置按钮的外观属性
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:buttonColor forState:UIControlStateNormal];
        button.titleLabel.font = buttonFont;
        button.tag = [tags[i] integerValue];
        
        // 添加按钮点击事件
        [button addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
        
        // 将当前按钮标记为左侧按钮
        leftButton = button;
        
        // 标记关注按钮
        if ( button.tag == CCFloatingViewFocucs )
        {
            if ( [superView isKindOfClass:[self class]] )
            {
                self.focusButton = button;
            }
            else
            {
                self.focusButtonTop = button;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *superView = self.superview;
    
    self.startPoint = CGPointMake(superView.center.x, superView.bounds.size.height + self.frame.size.height / 2);
    
    self.secondPoint = CGPointMake(superView.center.x, ScreenHeight/2 - 30);
    self.endPoint = CGPointMake(ScreenWidth/2, ScreenHeight/2);
}

- (void)show
{
    self.hidden = NO;
    // 清空数据
    [self resetUserInfo];
    [self showAnimationOnView:self firstPoint:self.startPoint secondPoint:self.secondPoint endPoint:self.endPoint];
}

- (void)dismiss
{
    self.floatingViewY.constant = ScreenHeight;
    [self setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL complete){
        self.floatingViewY.constant = 0;
        self.hidden = YES;
    }];
}

- (void)resetUserInfo
{
    self.headIconView.image = self.headerImage;
    self.nickName.text = kE_GlobalZH(@"loading");
    self.signalLabel.text = kE_GlobalZH(@"loading");
    self.idLabel.text = kE_GlobalZH(@"loading");
    self.moneyCountLabel.text = @"0";
    self.fansCountLabel.text = @"0";
    self.focusCountLabel.text = @"0";
    NSString *focusTitle = kE_GlobalZH(@"add_follow");
    [self.focusButton setTitle:focusTitle forState:UIControlStateNormal];
    [self.focusButtonTop setTitle:focusTitle forState:UIControlStateNormal];

    self.bottmBgView.userInteractionEnabled = NO;
    
    for ( UIView *subView in self.subviews )
    {
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            subView.userInteractionEnabled = NO;
        }
    }
    
    self.cancelButton.userInteractionEnabled = YES;
}

- (void)recoverUserEnable
{
    self.bottmBgView.userInteractionEnabled = YES;
    for ( UIView *subView in self.subviews )
    {
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            if (((UIButton *)subView).tag == CCFloatingViewShutup && ((UIButton *)subView).selected == YES)
            {
                subView.userInteractionEnabled = NO;
            }
            else
            {
                subView.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)setIsAnchor:(BOOL)isAnchor
{
    _isAnchor = isAnchor;
    self.bottmBgView.hidden = !isAnchor;
}

- (void)setIsMng:(BOOL)isMng
{
    _isMng = isMng;
    self.shutupButton.hidden = !isMng;
    NSString *reportStr = isMng ? kE_GlobalZH(@"e_manager") : kE_GlobalZH(@"e_report");
    [self.reportButton setTitle:reportStr forState:(UIControlStateNormal)];
}

// 设置要展示的数据模型
- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    [self.headIconView cc_setImageWithURLString:userModel.logourl isVip:userModel.vip vipSizeType:CCVipMax];
    self.signalLabel.text = userModel.signature;
    
    self.nickName.text = [NSString stringWithFormat:@"%@",userModel.nickname];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@" ,userModel.name];
    self.moneyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)userModel.sendecoin];
    NSUInteger allFansCount = (long)userModel.fans_count < 0 ? 0 : (long)userModel.fans_count;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%ld",allFansCount];
    self.focusCountLabel.text = [NSString stringWithFormat:@"%ld",(long)userModel.follow_count];
    NSString *focusTitle = userModel.followed ? kE_GlobalZH(@"e_cancel_follow"):kE_GlobalZH(@"add_follow");
    [self.focusButton setTitle:focusTitle forState:UIControlStateNormal];
    [self.focusButtonTop setTitle:focusTitle forState:UIControlStateNormal];
    
    [self recoverUserEnable];
}

// 点击按钮响应的方法 点击这个view
- (void)clickView:(UIButton *)button
{
    if ( button.tag == CCFloatingViewCancel)
    {
        [self dismiss];
        return;
    }
    if (button.tag == CCFloatingViewShutup && button.selected == YES)
    {
        return;
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(floatingView:clickButton:)] )
    {
        [self.delegate floatingView:self clickButton:button];
        if (button.tag == CCFloatingViewShutup)
        {
            button.selected = YES;
            if ( self.userModel.name )
            {
                [self.shutupUsers addObject:self.userModel.name];
            }
        }
    }
}

// 显示浮动窗口动画
- (void)showAnimationOnView:(UIView *)item
                 firstPoint:(CGPoint)point0
                secondPoint:(CGPoint)point1
                   endPoint:(CGPoint)point2
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]];
    animation.keyTimes = @[@(0), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.10 :0.87 :0.68 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.66 :0.37 :0.70 :0.95]];
    animation.duration = .6f;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    [item.layer addAnimation:animation forKey:@"kStringMenuItemAppearKey"];
    item.layer.position = point2;
}

- (void)dismissAnimationOnView:(UIView *)item
                    firstPoint:(CGPoint)point0
                      endPoint:(CGPoint)point1
{
    CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"position"];
    disappear.duration = 0.3;
    disappear.fromValue = [NSValue valueWithCGPoint:point0];
    disappear.toValue = [NSValue valueWithCGPoint:point1];
    disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappear.removedOnCompletion = YES;
    [item.layer addAnimation:disappear forKey:@"kStringMenuItemAppearKey"];
    item.layer.position = point1;
}

- (NSMutableArray *)shutupUsers
{
    if (!_shutupUsers)
    {
        _shutupUsers = [NSMutableArray array];
    }
    return _shutupUsers;
}

@end
