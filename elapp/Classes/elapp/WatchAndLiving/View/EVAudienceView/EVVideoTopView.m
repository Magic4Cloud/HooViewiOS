//
//  EVVideoTopView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVVideoTopView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVVideoFunctions.h"

#define kAnimationTime 0.3
#define kDefaultShowAnchorInfoTime 3
#define kExtendViewHeight 205
#define kExtendLiveingHeight 158

#define kSpaceWidth   8

#define kNameSpaceWidth 6

#define kFansSpace   14

@implementation EVAudienceInfoItem

@end

/** 主播信息，可以收起/展开 */
@interface EVAnchorInfoView ()

@property ( nonatomic, strong ) UIWindow *containerWindow;
@property ( nonatomic, weak ) UIView *extendView;
@property ( nonatomic, weak) UIImageView *iconImageView;
@property ( nonatomic, weak) EVVideoTopView *infoView;


@property ( nonatomic, weak) UILabel *titleLabel;
@property ( nonatomic, weak) UILabel *topicLabel;//视频分类
@property ( nonatomic, weak) UILabel *idLabel;  // ID
@property ( nonatomic, weak) UILabel *videoCountLabel;
@property ( nonatomic, weak) UILabel *fansCountLabl;
@property ( nonatomic, weak) UILabel *focusCountLabel;
@property ( nonatomic, weak) UIButton *indexButton;
@property ( nonatomic, weak) UIButton *messageButton;
@property ( weak, nonatomic ) UILabel *nickNameLabel;


/** @他 */
@property ( nonatomic, weak) UIButton *focusButton;
@property (nonatomic, weak) UIButton *reportButton;  // 举报按钮


@property ( nonatomic, assign) BOOL open;
@property ( nonatomic, assign) BOOL foreMenuButtonHidden;
@property ( nonatomic, assign) BOOL animating;
@property ( nonatomic, assign) BOOL watchSide;

@property ( nonatomic, assign) BOOL insetInfoView;


@property ( nonatomic, assign) CGRect infoVieworginFrame;


@property ( nonatomic, assign) BOOL topicUpdate;

@property ( nonatomic, assign) BOOL isUserVideo; /**< 是否是主播自己的音、视频 */
/** 点击window */
@property ( nonatomic, strong ) UITapGestureRecognizer *tap;


@property (nonatomic, weak) UILabel *moneyCountLabel;
@property (nonatomic, weak) UIView  *separatorLine;

/** 标记展开时间 */
@property ( nonatomic ) NSInteger showTime;
@property (nonatomic, weak) UIView *bottomView;

- (void)setCurrrUserInfoView;

@property (nonatomic, weak)NSLayoutConstraint *focusToBottomConstraint;
@end

@implementation EVAnchorInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setAnchorInfoView];
        self.backgroundColor = [UIColor clearColor];
        [CCNotificationCenter addObserver:self selector:@selector(updateTime) name:CCUpdateForecastTime object:nil];
    }
    return self;
}

- (void)updateTime
{
    if ( self.showTime == kDefaultShowAnchorInfoTime && self.open )
    {
    
    }
    self.showTime++;
}

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
    [self.containerWindow resignKeyWindow];
    self.containerWindow = nil;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void)hideCover
{
    [self userMessageClose];
}


- (void)setAnchorInfoView
{
    UIWindow *containerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containerWindow.backgroundColor = [UIColor clearColor];
    [containerWindow makeKeyAndVisible];
    self.containerWindow = containerWindow;
    containerWindow.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover)];
    self.tap = tap;
    [containerWindow addGestureRecognizer:tap];
    
    
    /** 真正展示出来的view */
    UIView *extendView = [[UIView alloc] init];
    extendView.frame = CGRectMake(0, -kExtendViewHeight, ScreenWidth, kExtendViewHeight);
    [containerWindow addSubview:extendView];
    extendView.backgroundColor = [UIColor whiteColor];
    extendView.alpha = 1.0;
    self.extendView = extendView;

    
    /** 头像 */
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.image = [UIImage imageNamed:@"avatar"];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 0.5 * CCICON_HEIGHT;
    self.iconImageView = iconImageView;
    [extendView addSubview:iconImageView];
    [iconImageView autoSetDimensionsToSize:CGSizeMake(CCICON_HEIGHT, CCICON_HEIGHT)];
    [iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    
    
    CGFloat infoContainViewW = ScreenWidth;
    CGFloat marginSide = 70;
    CGFloat labelTextMaxW = infoContainViewW - marginSide * 2;
    
//     昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.text = kE_GlobalZH(@"loading");
    nickNameLabel.numberOfLines = 1;
    nickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nickNameLabel.font = CCBoldFont(15);
    nickNameLabel.textColor = [UIColor evTextColorH1];
    [extendView addSubview:nickNameLabel];
    [nickNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:10];
    [nickNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:extendView withOffset:25];
    [nickNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [nickNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    UIButton *reportButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    reportButton.tag = CCAudienceInfoReport;
    [reportButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [extendView addSubview:reportButton];
    reportButton.layer.borderColor = [UIColor evLineColor].CGColor;
    reportButton.layer.borderWidth = 1.0;
    reportButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [reportButton setTitle:kE_GlobalZH(@"e_report") forState:(UIControlStateNormal)];
    [reportButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    reportButton.layer.cornerRadius = 3.f;
    reportButton.hidden = NO;
    self.reportButton = reportButton;
    [reportButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:extendView withOffset:-10.0];
    [reportButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:extendView withOffset:15.0];
    [reportButton autoSetDimensionsToSize:CGSizeMake(45, 21)];

    
    // ID
    UILabel *idLabel = [[UILabel alloc] init];
    [extendView addSubview:idLabel];
    idLabel.font = [UIFont systemFontOfSize:12];
    idLabel.textColor = [UIColor evTextColorH2];
    [idLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    [idLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nickNameLabel withOffset:8];
    idLabel.text = [NSString stringWithFormat:@"ID:%@",kE_GlobalZH(@"loading")];
    self.idLabel = idLabel;

    /** 视频标题 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = kE_GlobalZH(@"loading");
    titleLabel.preferredMaxLayoutWidth = labelTextMaxW;
    titleLabel.textColor = idLabel.textColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [extendView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel = titleLabel;
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:idLabel withOffset:8];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    [titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:extendView withOffset:-10];
    [titleLabel autoSetDimension:ALDimensionHeight toSize:15];
    
    

    UIFont *labelFont = [UIFont systemFontOfSize:16.0];
    UIColor *labelColor = [UIColor colorWithHexString:@"#403B37"];
    
    UIFont *countFont = [UIFont systemFontOfSize:11.0];
    UIColor *countColor = [UIColor evTextColorH2];
    
    float labelWid = ScreenWidth / 3;
    
    
   
    
    UILabel *moneyCountLabel = [[UILabel alloc]init];
    moneyCountLabel.font = labelFont;
    moneyCountLabel.textColor = labelColor;
    moneyCountLabel.textAlignment = NSTextAlignmentCenter;
    [extendView addSubview:moneyCountLabel];
    moneyCountLabel.text = @"0";
    self.moneyCountLabel = moneyCountLabel;
    [moneyCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:kFansSpace];
    [moneyCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:extendView withOffset:0];
    [moneyCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.font = countFont;
    moneyLabel.textColor = countColor;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [extendView addSubview:moneyLabel];
    moneyLabel.text = kE_GlobalZH(@"send_coin");
    [moneyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:extendView];
    self.focusToBottomConstraint  =[moneyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:moneyCountLabel withOffset:kNameSpaceWidth];
    [moneyLabel autoSetDimension:ALDimensionWidth toSize:labelWid];

    // 粉丝数
    UILabel *fansCountLabel = [[UILabel alloc] init];
    fansCountLabel.font = labelFont;
    fansCountLabel.textColor = labelColor;
    fansCountLabel.text = @"0";
    fansCountLabel.textAlignment = NSTextAlignmentCenter;
    [extendView addSubview:fansCountLabel];
    _fansCountLabl = fansCountLabel;
    [fansCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:moneyCountLabel];
    [fansCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:moneyCountLabel withOffset:0];
    [fansCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    // 粉丝
    UILabel *fansLabel = [[UILabel alloc] init];
    fansLabel.font = countFont;
    fansLabel.textColor = countColor;
    fansLabel.textAlignment = NSTextAlignmentCenter;
    [extendView addSubview:fansLabel];
    fansLabel.text = kE_GlobalZH(@"e_fans");
    [fansLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:moneyLabel];
    [fansLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:moneyLabel withOffset:0];
    [fansLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    
    // 关注数
    UILabel *focusCountLabel = [[UILabel alloc] init];
    [extendView addSubview:focusCountLabel];
    focusCountLabel.font = labelFont;
    focusCountLabel.textAlignment = NSTextAlignmentCenter;
    focusCountLabel.textColor = labelColor;
    [focusCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fansCountLabel];
    [focusCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fansCountLabel withOffset:0];
    [focusCountLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    _focusCountLabel = focusCountLabel;
    
    // 关注
    UILabel *focusLabel = [[UILabel alloc] init];
    focusLabel.font = countFont;
    focusLabel.textColor = countColor;
    focusLabel.textAlignment = NSTextAlignmentCenter;
    [extendView addSubview:focusLabel];
    focusLabel.text = kNavigatioBarFollow;
    [focusLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fansLabel];
    [focusLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fansLabel withOffset:0];
    [focusLabel autoSetDimension:ALDimensionWidth toSize:labelWid];
    
    
    
    
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor clearColor];
    [extendView addSubview:bottomView];
    bottomView.hidden = YES;
    [bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:extendView withOffset:-46];
    [bottomView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:extendView];
    [bottomView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 46)];
    self.bottomView = bottomView;

    UIView *lineView = [[UIView alloc] init];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:45.];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0.];
    [lineView autoSetDimension:ALDimensionHeight toSize:.5];
    _separatorLine = lineView;    
    
  
    
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
    UIColor *buttonColor = [UIColor colorWithHexString:kGlobalGreenColor];
    
    // 分割线颜色
    UIColor *lineColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 按钮字体
    UIFont *buttonFont = [UIFont boldSystemFontOfSize:13];
    
    // 按钮数量
    NSInteger count = tags.count;
    
    // 标记当前要添加的按钮左侧的按钮
    UIButton *leftButton;
    
    for (int i = 0; i < count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [superView addSubview:button];
        if ( i == 0 ) {
            // 设置第一个按钮的约束
            [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:superView withMultiplier:1.0 / count];
            [button autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.];
            [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.];
            [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_separatorLine];
        } else {
            // 设置后面按钮的约束
            [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:leftButton];
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftButton];
            [button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftButton];
        }
        
        if ( i < count - 1 ) {
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
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 将当前按钮标记为左侧按钮
        leftButton = button;
        
        // 标记关注按钮
        if ( button.tag == CCAudienceInfoFocus ) {
            if ( [superView isKindOfClass:[superView class]] ) {
                self.focusButton = button;
                [self.focusButton setTitle:kE_GlobalZH(@"e_cancel_follow") forState:(UIControlStateSelected)];
            }
        }
    }
}


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    if ( self.infoVieworginFrame.size.width == 0 ) {
    }
    if ( !self.insetInfoView ) {
        self.insetInfoView = YES;
    }
}


- (void)buttonDidClicked:(UIButton *)button
{
    [self hideCover];
    [self.infoView buttonDidClicked:button];
}
- (void)userMessageOpen
{
    WEAK(self)
    [EVVideoFunctions setBottomLeftAndBottomRightCorner:self.extendView];
    CGRect frame = self.extendView.frame;
    if (self.open || frame.origin.y > 0) {
        
        [self userMessageClose];
        
    }else {
        if (self.isUserVideo) {
            self.containerWindow.hidden = NO;
            self.bottomView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                weakself.extendView.frame = CGRectMake(0, 0, ScreenWidth,kExtendLiveingHeight);
            }];
        }else {
            self.containerWindow.hidden = NO;
            self.bottomView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                weakself.extendView.frame = CGRectMake(0, 0, ScreenWidth,kExtendViewHeight);
            }];
        }
    }
}
- (void)userMessageClose
{
    WEAK(self)
    CGRect frame = self.extendView.frame;
    if (self.animating || frame.origin.y < 0) {
        return;
    }
    if (self.isUserVideo) {
        [UIView animateWithDuration:0.3 animations:^{
            weakself.extendView.frame = CGRectMake(0, -kExtendLiveingHeight,ScreenWidth,kExtendLiveingHeight);
        } completion:^(BOOL finished) {
            weakself.containerWindow.hidden = YES;
        }];
    }else {
        
    }[UIView animateWithDuration:0.3 animations:^{
        weakself.extendView.frame = CGRectMake(0, -kExtendViewHeight,ScreenWidth,kExtendViewHeight);
    } completion:^(BOOL finished) {
        weakself.containerWindow.hidden = YES;
    }];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ( !self.open ){

    }else {
        self.hidden = YES;
    }
    self.open = !self.open;
    self.iconImageView.userInteractionEnabled = YES;
}

- (UILabel *)countLabel
{
    UILabel *videoCountLabel = [[UILabel alloc] init];
    videoCountLabel.text = kE_GlobalZH(@"loading");
    videoCountLabel.textAlignment = NSTextAlignmentLeft;
    videoCountLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    videoCountLabel.font = self.titleLabel.font;
    return videoCountLabel;
}

- (UIButton *)menuButton
{
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setTitleColor:[UIColor colorWithHexString:@"#FB6655"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
    menuButton.titleLabel.font = CCBoldFont(12.0);
    return menuButton;
}

- (UILabel *)buttonTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"#FB6655"];
    label.font = CCNormalFont(13);
    return label;
}

- (void)setCurrrUserInfoView
{
    CGRect frame = CGRectMake(0, -kExtendLiveingHeight, ScreenWidth,kExtendLiveingHeight);
    self.extendView.frame = frame;
    self.bottomView.hidden = YES;
    self.containerWindow.hidden = YES;
}

@end

/** 视频界面上部分 */
@interface EVVideoTopView ()

@property (nonatomic,weak) UIImageView *iconImageView;
@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,weak) UILabel *watchingCountLabel;     // 头像左下方的统计

/** 观看数、正在观看数、点赞数 */
@property ( nonatomic, weak ) UIView *watchCountBGView;

/** 切换摄像头 */
@property (nonatomic,weak) UIButton *cameraButton;
@property (nonatomic,weak) UIButton *flashButton;

@property (nonatomic,strong) NSArray *keyPaths;

@property (nonatomic, weak) UIButton *followButton;
@end

@implementation EVVideoTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setVideoTopView];
        
    }
    return self;
}


- (void)dealloc
{
    [self removeOberserver];
    _listenerItem.delegate = nil;
}

- (void)close
{
    [self.extendView userMessageClose];
}

- (void)closeNoAnimation
{
    CGRect frame = self.extendView.frame;
    frame.size.width = 0;
    frame.size.height = 0;
    self.extendView.extendView.frame = frame;
    self.extendView.containerWindow.hidden = YES;
}

- (void)tap
{
    [self.extendView userMessageOpen];
}

- (void)setVideoTopView
{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
    [self addSubview:backView];
    backView.layer.cornerRadius = CCBACKVIEW_HEIGHT * 0.5;
    backView.clipsToBounds = YES;
    [backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    self.backViewConstraint =  [backView autoSetDimension:ALDimensionWidth toSize:CCBACKVIEW_WIDTH];
    [backView autoSetDimension:ALDimensionHeight toSize:CCAUDIENCEINFOVIEW_HEIGHT];
    
    
    /** 头像 */
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.image = [UIImage imageNamed:@"avatar"];
    [backView addSubview:iconImageView];
    [iconImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:backView withOffset:1.0];
    [iconImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backView withOffset:1.0];
    [iconImageView autoSetDimension:ALDimensionHeight toSize:CCBACKVIEW_HEIGHT];
    [iconImageView autoSetDimension:ALDimensionWidth toSize:CCBACKVIEW_HEIGHT];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 0.5 * CCBACKVIEW_HEIGHT;
    self.iconImageView = iconImageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [iconImageView addGestureRecognizer:tap];


    
    /** 播放时间背景 */
    CGFloat labelBGHeight = 0.5 * CCAUDIENCEINFOVIEW_HEIGHT;
    
    UILabel *timeLabel = [self normalFontLabel];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    timeLabel.hidden = NO;
    self.timeLabel = timeLabel;
    [timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:3];
    [timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImageView withOffset:-(0.25 * CCAUDIENCEINFOVIEW_HEIGHT)];
    timeLabel.text = kE_GlobalZH(@"living");
    
    
    /** 看过、正在看、点赞个数 */
    CGFloat margin = 25;
    UIView *watchCountBGView = [[UIView alloc] init];
    watchCountBGView.backgroundColor = [UIColor whiteColor];
    watchCountBGView.layer.cornerRadius = labelBGHeight / 2.0;
    [self addSubview:watchCountBGView];
    watchCountBGView.hidden = YES;
    [watchCountBGView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:iconImageView];
    [watchCountBGView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:-margin];
    [watchCountBGView autoSetDimension:ALDimensionHeight toSize:labelBGHeight];
    self.watchCountBGView = watchCountBGView;
    
    UILabel *watchingCountLabel = [self normalFontLabel];
    watchingCountLabel.textColor = [UIColor whiteColor];
    watchingCountLabel.textAlignment = NSTextAlignmentCenter;
    watchingCountLabel.hidden = NO;
    [self addSubview:watchingCountLabel];
    [watchingCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:3];
    [watchingCountLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImageView withOffset:(0.25 * CCAUDIENCEINFOVIEW_HEIGHT)];
    self.watchingCountLabel = watchingCountLabel;
    watchingCountLabel.text = @"0人";
    
    
    
    UIButton *followButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    followButton.backgroundColor = [UIColor evAssistColor];
    [backView addSubview:followButton];
    self.followButton = followButton;
    followButton.tag = CCAudienceInfoFollow;
    followButton.layer.cornerRadius = CCBACKVIEW_HEIGHT * 0.25;
    followButton.clipsToBounds = YES;
    followButton.hidden = YES;
    [followButton setTitle:kNavigatioBarFollow forState:(UIControlStateNormal)];
    followButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [followButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backView withOffset:-kSpaceWidth];
    [followButton autoSetDimension:ALDimensionWidth toSize:CCAUDIENCEINFOVIEW_HEIGHT];
    [followButton autoSetDimension:ALDimensionHeight toSize:CCBACKVIEW_HEIGHT * 0.5];
    [followButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backView withOffset:CCBACKVIEW_HEIGHT * 0.25];
    [followButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self bringSubviewToFront:iconImageView];
    
    /** 取消按钮 */
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.tag = CCAudienceInfoCancel;
    [cancelButton setImage:[UIImage imageNamed:@"living_over_close"] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [self addSubview:cancelButton];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-10];
    [cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    /** 主播信息 */
    EVAnchorInfoView *anchorInfoView = [[EVAnchorInfoView alloc] init];
    anchorInfoView.infoView = self;
    [self addSubview:anchorInfoView];
    [anchorInfoView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:-10];
    [anchorInfoView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:-10];
    self.extendView = anchorInfoView;
    
    [self setUpObserver];
    
    self.listenerItem = [[EVControllerItem alloc] init];
    self.listenerItem.delegate = self;
    
}

- (void)getVideoInfoSuccess:(BOOL)success
{
    
}

- (UILabel *)normalFontLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (void)setUpObserver
{
    self.item = [[EVAudienceInfoItem alloc] init];
    
    self.keyPaths = @[
                      @"iconURLString",
                      @"mode",
                      @"watchCount",
                      @"watchingCount",
                      @"likeCount",
                      @"time",
                      @"gender",
                      @"level",
                      @"watchSide",
                      @"videoCount",
                      @"audioCount",
                      @"focusCount",
                      @"followed",
                      @"title",
                      @"location",
                      @"nickname",
                      @"name",
                      @"focusButtonEnable",
                      @"fansCount",
                      @"topic",
                      @"continueLiving",
                      @"certification",
                      @"sendecoin"
                      ];
    
    for ( NSString *item in self.keyPaths )
    {
        [self.item addObserver:self forKeyPath:item options:NSKeyValueObservingOptionNew context:nil];
    }
    self.extendView.focusButton.userInteractionEnabled = NO;
    self.flashButton.hidden = YES;
    self.cameraButton.hidden = NO;
}



- (void)removeOberserver
{
    for ( NSString *item in _keyPaths )
    {
        [_item removeObserver:self forKeyPath:item];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"iconURLString"] )
    {
        __weak typeof(self) wself = self;
        [UIImage gp_imageWithURlString:self.item.iconURLString comolete:^(UIImage *image) {
            wself.iconImageView.image = image;
            wself.extendView.iconImageView.image = image;
        }];
    }
    else if ( [keyPath isEqualToString:@"mode"])
    {
        switch ( self.item.mode )
        {
            case CCAudienceInfoItemReplay:
            {
                [self observeObjectItemReplay];
            }
                break;
            case CCAudienceInfoItemWatchLive:
            {
                [self observeObjectItemWatchLive];
            }
                break;
                
            case CCAudienceInfoItemLiving:
            {
                [self observeObjectItemLiving];
               
            }
                 break;
            default:
                break;
        }
    }
    else if ( [keyPath isEqualToString:@"watchCount"]
             || [keyPath isEqualToString:@"watchingCount"]
             || [keyPath isEqualToString:@"likeCount"] )
    {
        
        self.watchingCountLabel.hidden = NO;
        self.watchCountBGView.hidden = NO;
        if ([keyPath isEqualToString:@"watchingCount"] || [keyPath isEqualToString:@"watchCount"]) {
            if (self.item.watchingCount <= 0) {
                self.watchingCountLabel.text = @"0人";
            }else {
                  self.watchingCountLabel.text = [NSString stringWithWatchingCount:self.item.watchingCount];
            }
        }
        if ( [self.protocalDelegate respondsToSelector:@selector(audienceInfoViewUpdate:count:)] &&  [keyPath isEqualToString:@"likeCount"] )
        {
            [self.protocalDelegate audienceInfoViewUpdate:CCAudiencceInfoViewProtocolLike count:self.item.likeCount];
        }
    }
    else if ( [keyPath isEqualToString:@"time"] )
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@", self.item.time];
    
    }
    else if ( [keyPath isEqualToString:@"watchSide"] )
    {
        self.flashButton.hidden = self.item.watchSide;
        self.cameraButton.hidden = self.item.watchSide;
        self.extendView.watchSide = self.item.watchSide;
    }
    else if ( [keyPath isEqualToString:@"videoCount"] )
    {
        self.extendView.videoCountLabel.text = [NSString stringWithFormat:@"%@ %@",kE_GlobalZH(@"living_video"), [NSString shortNumber:self.item.videoCount]];
    }
    else if ( [keyPath isEqualToString:@"focusCount"] )
    {
        self.extendView.focusCountLabel.text = [NSString stringWithFormat:@"%@", [NSString shortNumber:self.item.focusCount]];
    }
    else if ( [keyPath isEqualToString:@"fansCount"] )
    {
        self.extendView.fansCountLabl.text = [NSString stringWithFormat:@"%@", [NSString shortNumber:self.item.fansCount]];
    }
    else if ( [keyPath isEqualToString:@"followed"] )
    {
        self.extendView.focusButton.selected = self.item.followed;
        if (self.extendView.focusButton.selected == YES) {
            self.backViewConstraint.constant = 82;
            self.followButton.hidden = YES;
        }else{
            self.backViewConstraint.constant = 125;
            self.followButton.hidden = NO;
        }
        if (self.item.mode == CCAudienceInfoItemLiving) {
            self.backViewConstraint.constant = 125;
            self.followButton.hidden = YES;
        }
        self.item.userModel.followed = self.item.followed;
    }
    else if ( [keyPath isEqualToString:@"title"]  || [keyPath isEqualToString:@"topic"])
    {
        NSString *titleStr = [NSString stringWithFormat:@"#%@#  %@",self.item.topic.title,self.item.title];
        if ([self.item.topic.title isEqualToString:@""] || self.item.topic.title == nil) {
            titleStr = [NSString stringWithFormat:@"%@",self.item.title];
        }
        [self.extendView.titleLabel cc_setEmotionWithText:titleStr];
    }
    else if ( [keyPath isEqualToString:@"nickname"] )
    {
        self.extendView.nickNameLabel.text = self.item.nickname;
    }
    else if ( [keyPath isEqualToString:@"name"] )
    {
        self.extendView.idLabel.text = [NSString stringWithFormat:@"ID:%@",self.item.name];
        if ( !self.item.getUserInfoSuccess && self.item.name )
        {
            self.item.getUserInfoSuccess = YES;
            [self getUserInfo];
        }
        if ( [EVLoginInfo checkCurrUserByName:self.item.name])
        {
            self.extendView.isUserVideo = YES;
        }
    }
    else if ( [keyPath isEqualToString:@"topic"] )
    {
        
    }
}

- (void)observeObjectItemReplay
{
    NSString  *modeAlert = kE_GlobalZH(@"playback");
    self.timeLabel.text = [NSString stringWithFormat:@"%@",modeAlert];
    self.extendView.reportButton.hidden = NO;
    [self watchingAndReplay:@[kE_GlobalZH(@"add_follow"), kE_GlobalZH(@"private_letter"),kE_GlobalZH(@"home_user")] tagArray:@[@(CCAudienceInfoFocus),
                                                                                                                               @(CCAudienceInfoMessage),
                                                                                                                               @(CCAudienceInfoIndexPage)]];
}

- (void)observeObjectItemWatchLive
{
    NSString  *modeAlert = kE_GlobalZH(@"living");
    self.timeLabel.text = [NSString stringWithFormat:@"%@", modeAlert];
    self.extendView.reportButton.hidden = NO;
    [self watchingAndReplay:@[kE_GlobalZH(@"add_follow"), kE_GlobalZH(@"private_letter"), kE_GlobalZH(@"@_user"), kE_GlobalZH(@"home_user")] tagArray:@[@(CCAudienceInfoFocus),
                                                                                                                                                        @(CCAudienceInfoMessage),
                                                                                                                                                        @(CCAudienceInfoComment),
                                                                                                                                                        @(CCAudienceInfoIndexPage)]];
}

- (void)observeObjectItemLiving
{
    NSString  *modeAlert = kE_GlobalZH(@"living");
    self.timeLabel.text = [NSString stringWithFormat:@"%@", modeAlert];
    self.extendView.reportButton.hidden = YES;
    [self watchingAndReplay:@[kE_GlobalZH(@"add_follow"), kE_GlobalZH(@"private_letter"), kE_GlobalZH(@"@_user"), kE_GlobalZH(@"home_user")] tagArray:@[@(CCAudienceInfoFocus),
                                                                                                                                                        @(CCAudienceInfoMessage),
                                                                                                                                                        @(CCAudienceInfoComment),
                                                                                                                                                        @(CCAudienceInfoIndexPage)]];
    self.followButton.hidden = YES;
    self.backViewConstraint.constant = 125;
    self.timeLabel.hidden = NO;
    self.item.currUserName = self.item.name;
    self.item.likeCount = 0;
    self.item.watchCount = 0;
    self.item.watchingCount = 0;
    self.item.focusCount = 0;
    self.extendView.foreMenuButtonHidden = YES;
    [self.extendView setCurrrUserInfoView];
    [self getAnchorInfo];
}


- (void)watchingAndReplay:(NSArray *)titleArray tagArray:(NSArray *)tagArray
{
    NSArray *titles = titleArray;
    NSArray *tags = tagArray;
    [self.extendView setBottomButtonsWithTitles:titles tags:tags superView:self.extendView.bottomView];
}

- (void)setContacter:(EVControllerContacter *)contacter
{
    _contacter = contacter;
    [contacter addListener:self.listenerItem];
}

- (void)buttonDidClicked:(UIButton *)btn
{
    if ( btn.tag == CCAudienceInfoMessage  )
    {
        if ( self.item.userModel == nil )
        {
            [CCProgressHUD showError:kE_GlobalZH(@"fail_user_data_again") toView:self];
            
            if ( self.item.watchSide )
            {
                [self getUserInfo];
            }
            else
            {
                [self getAnchorInfo];
            }
            
            return;
        }
    }
    
    if ( [self.delegate respondsToSelector:@selector(audienceInfoView:didClicked:)] )
    {
        [self.delegate audienceInfoView:self didClicked:btn.tag];
    }
    

}


- (void)goToFront
{
    UIView *superView = self.superview;
    [superView bringSubviewToFront:self];
    [superView bringSubviewToFront:self.extendView];
}

#pragma mark - 直播端
- (void)getAnchorInfo
{
    __weak typeof(self) wself = self;
    [self.engine GETBaseUserInfoWithUname:self.item.name start:nil fail:nil success:^(NSDictionary *modelDict) {
        [wself fillAnchorInfo:modelDict];
    } sessionExpire:nil];
}

- (void)fillAnchorInfo:(NSDictionary *)info
{
    self.item.userModel = [EVUserModel objectWithDictionary:info];
    self.item.nickname = info[kNickName];
    self.item.location = info[kLocation];
    self.item.videoCount = [info[@"living_count"] integerValue];
    self.item.fansCount = [info[@"fans_count"] integerValue];
    self.item.audioCount = [info[@"audio_count"] integerValue];
    self.item.focusCount = [info[@"follow_count"] integerValue];
    self.item.certification = [info[@"certification"] integerValue];
    self.item.iconURLString = info[kLogourl];
    self.item.costecoin = [info[@"costecoin"] integerValue];
    self.item.userModel.followed = self.item.followed;
    self.item.userModel.sendecoin = [info[@"sendecoin"] integerValue];
    self.item.followed = [info[@"followed"] boolValue];
    self.item.name = info[kNameKey];
}

#pragma mark - 观看端
- (void)getUserInfo
{
    __weak typeof(self) wself = self;
    [self.engine GETBaseUserInfoWithUname:self.item.name start:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *modelDict) {
        wself.item.getUserInfoSuccess = YES;
        self.extendView.focusButton.userInteractionEnabled = YES;
        [wself fillWithUserInfo:modelDict];
    } sessionExpire:nil];
}

- (void)fillWithUserInfo:(NSDictionary *)userInfo
{
    self.item.userModel = [EVUserModel objectWithDictionary:userInfo];
    self.item.nickname = userInfo[kNickName];
    self.item.videoCount = [userInfo[@"living_count"] integerValue];
    self.item.focusCount = [userInfo[@"follow_count"] integerValue];
    self.item.audioCount = [userInfo[@"audio_count"] integerValue];
    self.item.fansCount = [userInfo[@"fans_count"] integerValue];
    self.item.gender = userInfo[@"gender"];
    self.item.costecoin = [userInfo[@"costecoin"] integerValue];
    self.item.userModel.sendecoin = [userInfo[@"sendecoin"]integerValue];
    self.item.followed = [userInfo[@"followed"] boolValue];
    if ( [self.item.name isEqualToString:self.item.currUserName] )
    {
        self.extendView.foreMenuButtonHidden = YES;
        [self.extendView setCurrrUserInfoView];
    }
}

- (void)show
{

}

@end
