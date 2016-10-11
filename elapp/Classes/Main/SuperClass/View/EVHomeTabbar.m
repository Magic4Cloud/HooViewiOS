//
//  EVHomeTabbar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeTabbar.h"
#import <PureLayout.h>

#define K_ANIMATION_TIME 0.3

CGFloat const tabBarRealHeight = 75.f;          /**< tabBar实际高度 */
static CGFloat const tabBarBtnHeight = 50.f;    /**< tabBar上按钮的高度 */
static CGFloat const liveBtnWidth  = 69.f;      /**< 直播按钮宽度 */
static CGFloat const liveBtnHeight = 76.f;      /**< 直播按钮高度 */

@interface EVHomeTabbar ()

@property (nonatomic,weak) UIButton *selectButton;

@property (nonatomic,weak) UIButton *activityButton;
@property (nonatomic,weak) UIButton *homeButton;
@property (nonatomic,weak) UIButton *friendCircleButton;
@property (nonatomic,weak) UIButton *letterButton;

@property (nonatomic, assign) BOOL tabbarShow;

@property (nonatomic,weak) UIView *redPoint;

@end

@implementation EVHomeTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    UIImage *image = [UIImage imageNamed:@"appbar_pic"];
    imageView.image = image;
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    // 主页
    UIButton *homeButton = [self buttonWithNorImage:@"appbar_icon_home_nor" selectedImage:@"appbar_icon_home" title:nil];
    [self addSubview:homeButton];
    homeButton.tag = CCHomeTabbarButtonTimeLine;
    self.homeButton = homeButton;
    
    // 直播
    UIButton *liveButton = [[UIButton alloc] init];
    [liveButton setImage:[UIImage imageNamed:@"appbar_icon_liveopen"] forState:UIControlStateNormal];
    [self addSubview:liveButton];
    liveButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    liveButton.tag = CCHomeTabbarButtonLive;
    [liveButton addTarget:self action:@selector(buttonDidClicked:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    // 私信
    UIButton *letterButton = [self buttonWithNorImage:@"appbar_icon_message_nor" selectedImage:@"appbar_icon_message" title:nil];
    [self addSubview:letterButton];
    letterButton.tag = CCHomeTabbarButtonLetter;
    self.letterButton = letterButton;
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.hidden = YES;
    redPoint.userInteractionEnabled = NO;
    redPoint.backgroundColor = [UIColor redColor];
    [letterButton addSubview:redPoint];
    self.redPoint = redPoint;
    
    for ( UIView *subView in self.subviews )
    {
        if ( [subView isKindOfClass:[UIButton class]] && subView.tag != CCHomeTabbarButtonLive )
        {
            UIButton *btn = (UIButton *)subView;
            [btn addTarget:self action:@selector(buttonDidClicked:withEvent:) forControlEvents:UIControlEventTouchDown];
        }
    }
    
    [homeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [homeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [homeButton autoSetDimension:ALDimensionWidth toSize:(ScreenWidth-liveBtnWidth)/2.f];
    [homeButton autoSetDimension:ALDimensionHeight toSize:tabBarBtnHeight];
    
    [liveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [liveButton autoSetDimensionsToSize:CGSizeMake(liveBtnWidth, liveBtnHeight)];
    
    [letterButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [letterButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [letterButton autoSetDimension:ALDimensionWidth toSize:(ScreenWidth-liveBtnWidth)/2.f];
    [letterButton autoSetDimension:ALDimensionHeight toSize:tabBarBtnHeight];
    
    self.selectButton = homeButton;
    homeButton.selected = YES;
    self.selectedIndex = 0;
    
    self.tabbarShow = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat redPointWH = 6;
    self.redPoint.layer.cornerRadius = 0.5 * redPointWH;
    self.redPoint.frame = CGRectMake(0, 0, redPointWH, redPointWH);
    CGRect messageButtonImageViewFrame = self.letterButton.imageView.frame;
    CGFloat messageButtonImageViewMarginR = 7;
    CGFloat messageButtonImageViewMarginT = 4;
    CGFloat redPointCenterX = CGRectGetMaxX(messageButtonImageViewFrame) - messageButtonImageViewMarginR ;
    CGFloat redPointCenterY = messageButtonImageViewFrame.origin.y + messageButtonImageViewMarginT ;
    self.redPoint.center = CGPointMake(redPointCenterX, redPointCenterY);
}

- (UIButton *)buttonWithNorImage:(NSString *)norImage
                   selectedImage:(NSString *)selectedImage
                           title:(NSString *)title
{
    UIButton *activityButton = [[UIButton alloc] init];
    activityButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [activityButton setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [activityButton setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];

    return activityButton;
}

- (void)buttonDidClicked:(UIButton *)button withEvent:(UIEvent *)event
{
    if ( button == self.selectButton )
    {
        return;
    }
    
    if ( button.tag == CCHomeTabbarButtonLive )
    {
        if ( [self.delegate respondsToSelector:@selector(homeTabbarDidClickedLiveButton)] )
        {
            [self.delegate homeTabbarDidClickedLiveButton];
        }
        return;
    }

    if ( [self.delegate respondsToSelector:@selector(homeTabbarDidClicked:)] )
    {
        [self.delegate homeTabbarDidClicked:button.tag];
    }
    
    if ( button.tag != CCHomeTabbarButtonLive )
    {
        self.selectButton.selected = NO;
        button.selected = YES;
        self.selectButton = button;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.selectButton.selected = NO;
    _selectedIndex = selectedIndex;
    UIButton *btn = self.selectButton;
    switch ( selectedIndex )
    {
        case 0:
            btn = self.homeButton;
            break;
            
        case 1:
            btn = self.activityButton;
            break;
            
        case 2:
            btn = self.friendCircleButton;
            break;
            
        case 3:
            btn = self.letterButton;
            break;
            
        default:
            break;
    }
    
    btn.selected = YES;
    self.selectButton = btn;
}

- (void)hideTabbarWithAnimation
{
    if ( !self.tabbarShow )
    {
        return;
    }
    self.tabbarShow = NO;
    
    
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
        self.frame = frame;
    }];
    
}

- (void)showTabbarWithAnimation
{
    if ( self.tabbarShow )
    {
        return;
    }
    self.tabbarShow = YES;
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
        self.frame = frame;
    }];
    
}

@end


@interface CCHomeTabbarContainer ()
@end

@implementation CCHomeTabbarContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        EVHomeTabbar *tabbar = [[EVHomeTabbar alloc] init];
        [self addSubview:tabbar];
        [tabbar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.backgroundColor = [UIColor clearColor];
        
        self.tabbar = tabbar;
        
    }
    return self;
}

- (void)setShowRedPoint:(BOOL)showRedPoint
{
    _showRedPoint = showRedPoint;
    self.tabbar.redPoint.hidden = !showRedPoint;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for ( UIView *item in self.subviews )
    {
        if ( ![item isKindOfClass:[EVHomeTabbar class]] )
        {
            item.hidden = YES;
        }
    }
    
    self.tabbar.frame = self.bounds;
}

- (void)hideTabbarWithAnimation
{
    [self.tabbar hideTabbarWithAnimation];
}

- (void)showTabbarWithAnimation
{
    [self.tabbar showTabbarWithAnimation];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.tabbar.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex
{
    return self.tabbar.selectedIndex;
}

@end
