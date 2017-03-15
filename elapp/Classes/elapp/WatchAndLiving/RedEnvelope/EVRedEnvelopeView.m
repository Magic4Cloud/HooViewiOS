//
//  EVRedEnvelopeView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRedEnvelopeView.h"
#import "UIImageView+WebCache.h"
#import <PureLayout.h>
#import "EVRedEnvelopeCell.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVLoginInfo.h"
#import "EVSDKLiveMessageEngine.h"


#define AvatarImageWidth 75.f
#define CancelButtonWidth 40.f
#define RedEnvelopeViewWidth 275.f
#define RedEnvelopeViewHeight 366.5f

@class EVBackgroundWindow;

static BOOL sAnimating;
static NSMutableArray *sRedEnvelopeQueue;
static EVBackgroundWindow *sBackgroundWindow;
static EVRedEnvelopeView *sCurrentRedEnvelopeView;
static NSMutableDictionary *sRedEnvelopeDictionary;
static NSMutableDictionary *sRedEnvelopeBrokenDic;  //hid= 1：你抢过红包；2：红包已抢完；0：没有抢过继续抢

@interface EVRedEnvelopeView () <UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate,UIApplicationDelegate,CAAnimationDelegate>

#ifdef __IPHONE_7_0
@property (nonatomic, assign) UIViewTintAdjustmentMode oldTintAdjustmentMode;
#endif

@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;
@property (nonatomic, strong) UIWindow *currentKeyWindow;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, weak)   UIWindow *oldKeyWindow;
@property (nonatomic, weak)   UILabel *resultLabel;
@property (nonatomic, weak)   UILabel *rstLabel;
@property (nonatomic, weak)   UIButton * seeEveryoneLuckButton;
@property (nonatomic, weak)   UITableView *mTableView;
@property (nonatomic, weak) UIButton *chaiBtn;
@property (nonatomic, weak) UILabel *errorTipLabel;
@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, assign) BOOL isChai;

@property (nonatomic, strong) NSMutableArray *allRedArray;

- (void)setup;

@end

#define failAlert  kGrab_slow
const UIWindowLevel UIWindowLevelDefault = 2016.0;
const UIWindowLevel UIWindowLevelBackground = 1987.0;

@interface EVBackgroundWindow : UIWindow

@end

@implementation EVBackgroundWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelBackground;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextFillRect(context, self.bounds);
}

@end


@interface EVRedEnvelopeCtrl : UIViewController

@property (nonatomic, strong) EVRedEnvelopeView *redEnvelopeView;

@end

@implementation EVRedEnvelopeCtrl

- (void)loadView
{
    self.view = self.redEnvelopeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.redEnvelopeView setup];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end


@implementation EVRedEnvelopeView

+ (void)initialize
{
    if (self != [EVRedEnvelopeView class])
        return;
    sRedEnvelopeBrokenDic = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
    
}

#pragma mark - Class methods

+ (NSMutableArray *)sharedQueue
{
    if (!sRedEnvelopeQueue) {
        sRedEnvelopeQueue = [NSMutableArray array];
    }
    return sRedEnvelopeQueue;
}

+ (void)clearData
{
    sRedEnvelopeQueue = nil;
    sRedEnvelopeDictionary = nil;
    sCurrentRedEnvelopeView = nil;
    sBackgroundWindow = nil;
}

+ (EVRedEnvelopeView *)currentView
{
    return sCurrentRedEnvelopeView;
}

+ (void)setCurrentView:(EVRedEnvelopeView *)currentView
{
    sCurrentRedEnvelopeView = currentView;
}

+ (void)setAllRedEnvelope:(NSMutableDictionary *)redEnvelopeDic
{
    sRedEnvelopeDictionary = redEnvelopeDic;
}

+ (BOOL)isAnimating
{
    return sAnimating;
}

+ (void)setAnimating:(BOOL)animating
{
    sAnimating = animating;
}

+ (void)showBackground
{
    if ( !sBackgroundWindow ) {
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if( [[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)] )
        {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        sBackgroundWindow = [[EVBackgroundWindow alloc] initWithFrame:frame];
        [sBackgroundWindow makeKeyAndVisible];
        sBackgroundWindow.alpha = 0;
        
        //
        [UIView animateWithDuration:0.3
                         animations:^{
                             sBackgroundWindow.alpha = 1;
                         }];
    }
}

+ (void)hideBackground:(BOOL)animated
{
    if ( !animated ) {
        [sBackgroundWindow removeFromSuperview];
        sBackgroundWindow = nil;
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         sBackgroundWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [sBackgroundWindow removeFromSuperview];
                         sBackgroundWindow = nil;
                     }];
}

#pragma mark - Public

- (void)show
{
    if (self.isVisible) {
        return;
    }
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
#ifdef __IPHONE_7_0
    if ([self.oldKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        self.oldTintAdjustmentMode = self.oldKeyWindow.tintAdjustmentMode;
        self.oldKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
#endif
    
    
    if ([EVRedEnvelopeView isAnimating]) {
        return;
    }
    
    if ([EVRedEnvelopeView currentView].isVisible) {
        EVRedEnvelopeView *view = [EVRedEnvelopeView currentView];
        [view dismissAnimated:YES cleanup:NO];
        return;
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    
    EVRedEnvelopeCtrl *redEnvelopeCtrl = [[EVRedEnvelopeCtrl alloc] initWithNibName:nil bundle:nil];
    redEnvelopeCtrl.redEnvelopeView = self;
  
    if (redEnvelopeCtrl.redEnvelopeView.currentModel.htp ==  CCRedEnvelopeTypeSystem) {
        self.visible = NO;
        [EVRedEnvelopeView setAnimating:NO];
        return;
    }else{
        
    }

    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        
    }];
    
}
- (void)buttonShow
{
    if (self.isVisible) {
        return;
    }
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
#ifdef __IPHONE_7_0
    if ([self.oldKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        self.oldTintAdjustmentMode = self.oldKeyWindow.tintAdjustmentMode;
        self.oldKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
#endif
    
    if (![[EVRedEnvelopeView sharedQueue] containsObject:self]) {
        [[EVRedEnvelopeView sharedQueue] addObject:self];
    }
    
    if ([EVRedEnvelopeView isAnimating]) {
        return;
    }
    
    if ([EVRedEnvelopeView currentView].isVisible) {
        EVRedEnvelopeView *view = [EVRedEnvelopeView currentView];
        [view dismissAnimated:YES cleanup:NO];
        return;
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    
    self.visible = YES;
    
    
    [EVRedEnvelopeView setAnimating:YES];
    [EVRedEnvelopeView setCurrentView:self];
    [EVRedEnvelopeView showBackground];
    
    EVRedEnvelopeCtrl *redEnvelopeCtrl = [[EVRedEnvelopeCtrl alloc] initWithNibName:nil bundle:nil];
    redEnvelopeCtrl.redEnvelopeView = self;
    
    if ( !self.currentKeyWindow ) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelDefault;
        window.rootViewController = redEnvelopeCtrl;
        self.currentKeyWindow = window;
    }
    [self.currentKeyWindow makeKeyAndVisible];
    
    
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        
    }];
}
#pragma mark - Animation

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [EVRedEnvelopeView setCurrentView:nil];
        
        EVRedEnvelopeView *nextView;
        NSInteger index = [[EVRedEnvelopeView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < (NSInteger)[EVRedEnvelopeView sharedQueue].count - 1) {
            nextView = [EVRedEnvelopeView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[EVRedEnvelopeView sharedQueue] removeObject:self];
            if ( self.currentModel.hid )
            {
                for ( NSString * hid in sRedEnvelopeDictionary.allKeys)
                {
                    if (![hid isEqualToString:self.currentModel.hid])
                    {
                    }
                }
            }
        }
        
        [EVRedEnvelopeView setAnimating:NO];
        
        if (!isVisible) {
            return;
        }
        else
        {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
        }
        
        if (nextView) {
            [nextView buttonShow];
        } else {
            if ([EVRedEnvelopeView sharedQueue].count > 0) {
                EVRedEnvelopeView *view = [[EVRedEnvelopeView sharedQueue] lastObject];
                [view buttonShow];
            }
        }
    };
    
    if (animated && isVisible) {
        [EVRedEnvelopeView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([EVRedEnvelopeView sharedQueue].count == 1) {
            [EVRedEnvelopeView hideBackground:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([EVRedEnvelopeView sharedQueue].count == 0) {
            [EVRedEnvelopeView hideBackground:YES];
        }
    }
    
    UIWindow *window = self.oldKeyWindow;
#ifdef __IPHONE_7_0
    if ([window respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        window.tintAdjustmentMode = self.oldTintAdjustmentMode;
    }
#endif
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

- (void)rotationAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = .6f;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.chaiBtn.layer addAnimation:animation forKey:@"chaiBtn-layer-rotate-layer"];
}

- (void) deleteRotationAnimation
{
    [self.chaiBtn.layer removeAnimationForKey:@"chaiBtn-layer-rotate-layer"];
    [self.chaiBtn removeFromSuperview];
}

- (void)exchangeViewAnimation
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"animation_exchangeSubview" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.containerView cache:YES];
    NSInteger first = [[self.containerView subviews] indexOfObject:[self.containerView viewWithTag:100]];
    NSInteger second = [[self.containerView subviews] indexOfObject:[self.containerView viewWithTag:101]];
    [self.containerView exchangeSubviewAtIndex:first withSubviewAtIndex:second];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    [UIView commitAnimations];
}

- (void) didStopAnimation
{
    EVLog(@"animation_exchangeSubview end");
}

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case EVViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
            
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case EVViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case EVViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
            
        default:
            break;
    }
}

- (void)resetTransition
{
    [self.containerView.layer removeAllAnimations];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout
{
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout
{
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
    
    self.containerView.transform = CGAffineTransformIdentity;
    [self.containerView autoCenterInSuperview];
    [self.containerView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
}

#pragma mark - Setup

- (void)setup
{
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    [self setupSecondView];
    [self setupFirstView];
    
    [self invalidateLayout];
}

- (void)setupSecondView
{
    EVRedEnvelopeItemModel *currModel = [EVRedEnvelopeView currentView].currentModel;
    
    UIView *secondView = [[UIView alloc] init];
    secondView.tag = 101;
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.layer.cornerRadius = 10.f;
    secondView.clipsToBounds = YES;
    [self.containerView addSubview:secondView];
    [secondView autoCenterInSuperview];
    [secondView autoSetDimensionsToSize:CGSizeMake(RedEnvelopeViewWidth, RedEnvelopeViewHeight)];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"living_redpaper_opened"]];
    img.userInteractionEnabled = YES;
    [secondView addSubview:img];
    [img autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:secondView];
    [img autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:secondView];
    [img autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:secondView];
    [img autoSetDimension:ALDimensionHeight toSize:71.f];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setImage:[UIImage imageNamed:@"living_icon_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = EVButtonTag_Cancel;
    [self.containerView addSubview:cancelBtn];
    [cancelBtn autoSetDimensionsToSize:CGSizeMake(CancelButtonWidth, CancelButtonWidth)];
    [cancelBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:secondView];
    [cancelBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:secondView];
    
    UIImageView *avatarImg = [[UIImageView alloc]init];
    avatarImg.layer.cornerRadius = AvatarImageWidth * 0.5f;
    avatarImg.clipsToBounds = YES;
    avatarImg.backgroundColor = [UIColor lightGrayColor];
    if (currModel.htp == CCRedEnvelopeTypeSystem) {
        NSString *replyStr = [NSString stringWithFormat:@"%@",[EVSDKLiveMessageEngine logourlWithLogoSufix:currModel.hlg]];
        [avatarImg sd_setImageWithURL:[NSURL URLWithString:replyStr]];
    }else{
        NSString *strUrl = [NSString stringWithFormat:@"%@",[EVSDKLiveMessageEngine logourlWithLogoSufix:currModel.ulg]];
        [avatarImg sd_setImageWithURL:[NSURL URLWithString:strUrl]];
    }
    [secondView addSubview:avatarImg];
    [avatarImg autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [avatarImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:secondView withOffset:17.f];
    [avatarImg autoSetDimensionsToSize:CGSizeMake(AvatarImageWidth, AvatarImageWidth)];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = currModel.hnm ? currModel.hnm : kE_GlobalZH(@"congratulation_fortune");
    tipLabel.textColor = [UIColor colorWithHexString:@"#5D5854" alpha:0.7];
    tipLabel.font = [UIFont systemFontOfSize:12.f];
    [secondView addSubview:tipLabel];
    [tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:avatarImg withOffset:8.f];
    
    UILabel *resultLabel = [[UILabel alloc]init];
    resultLabel.textColor = [UIColor colorWithHexString:@"#5D5854" alpha:1.0];
    resultLabel.font = [UIFont systemFontOfSize:20.f];
    [secondView addSubview:resultLabel];
    [resultLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [resultLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel withOffset:10.f];
    self.resultLabel = resultLabel;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [secondView addSubview:tableView];
    [tableView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:resultLabel withOffset:10.f];
    [tableView autoSetDimensionsToSize:CGSizeMake(RedEnvelopeViewWidth, 198.f)];
    self.mTableView = tableView;
}

- (void)setupFirstView
{
    EVRedEnvelopeItemModel *currModel = [EVRedEnvelopeView currentView].currentModel;
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.tag = 100;
    bgImageView.userInteractionEnabled = YES;
    [self.containerView addSubview:bgImageView];
    [bgImageView autoCenterInSuperview];
    [bgImageView autoSetDimensionsToSize:CGSizeMake(RedEnvelopeViewWidth, RedEnvelopeViewHeight)];
    self.bgImageView = bgImageView;
    
    UIButton *chaiBtn = [[UIButton alloc]init];
    [chaiBtn setBackgroundImage:[UIImage imageNamed:@"living_redpaper_dismantle"] forState:UIControlStateNormal];
    chaiBtn.tag = EVButtonTag_Chai;
    [chaiBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:chaiBtn];
    [chaiBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [chaiBtn autoSetDimensionsToSize:CGSizeMake(55, 57)];
    [chaiBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgImageView withOffset:155.5f];
    self.chaiBtn = chaiBtn;
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setImage:[UIImage imageNamed:@"living_icon_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = EVButtonTag_Cancel;
    [self.containerView addSubview:cancelBtn];
    [cancelBtn autoSetDimensionsToSize:CGSizeMake(CancelButtonWidth, CancelButtonWidth)];
    [cancelBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgImageView];
    [cancelBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgImageView];
    
    UIImageView *avatarImg = [[UIImageView alloc]init];
    avatarImg.layer.cornerRadius = AvatarImageWidth * 0.5f;
    avatarImg.clipsToBounds = YES;
    avatarImg.backgroundColor = [UIColor lightGrayColor];
    [bgImageView addSubview:avatarImg];
    self.avatarImg = avatarImg;
    [avatarImg autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [avatarImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgImageView withOffset:20.f];
    [avatarImg autoSetDimensionsToSize:CGSizeMake(AvatarImageWidth, AvatarImageWidth)];
    
    if (currModel.htp == CCRedEnvelopeTypeSystem) {
         NSString *replyStr = [NSString stringWithFormat:@"%@",[EVSDKLiveMessageEngine logourlWithLogoSufix:currModel.hlg]];
        [avatarImg sd_setImageWithURL:[NSURL URLWithString:replyStr]];
    }else{
        NSString *strUrl = [NSString stringWithFormat:@"%@",[EVSDKLiveMessageEngine logourlWithLogoSufix:currModel.ulg]];
        [avatarImg sd_setImageWithURL:[NSURL URLWithString:strUrl]];
    }
   
    
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = currModel.hnm ? currModel.hnm : kE_GlobalZH(@"congratulation_fortune");
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15.f];
    [bgImageView addSubview:tipLabel];
    [tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:avatarImg withOffset:15.f];
    
    UILabel *rstLabel = [[UILabel alloc]init];
    rstLabel.hidden = YES;
    bgImageView.image = [UIImage imageNamed:@"living_redpaper_opened_no"];
    if ( [sRedEnvelopeBrokenDic[currModel.hid] intValue] == 1 )
    {
        rstLabel.text = kE_GlobalZH(@"already_red_pack");
        rstLabel.hidden = NO;
        chaiBtn.hidden = YES;
        bgImageView.image = [UIImage imageNamed:@"living_redpaper_opened_yes"];
    }
    else if ( [sRedEnvelopeBrokenDic[currModel.hid] intValue] == 2 )
    {
        rstLabel.text = failAlert;
        rstLabel.hidden = NO;
        chaiBtn.hidden = YES;
        bgImageView.image = [UIImage imageNamed:@"living_redpaper_opened_yes"];
    }
    rstLabel.textColor = [UIColor whiteColor];
    rstLabel.font = [UIFont systemFontOfSize:18.f];
    [bgImageView addSubview:rstLabel];
    [rstLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [rstLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel withOffset:30.f];
    self.rstLabel = rstLabel;
    
    UIButton *seeEveryoneLuckButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [seeEveryoneLuckButton setTitle:kE_GlobalZH(@"red_look_luck") forState:UIControlStateNormal];
    [seeEveryoneLuckButton setTitleColor:[UIColor colorWithHexString:@"#F7C35B"] forState:UIControlStateNormal];
    seeEveryoneLuckButton.titleLabel.font = [UIFont systemFontOfSize:11];
    seeEveryoneLuckButton.titleEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 11);
    [seeEveryoneLuckButton setImage:[UIImage imageNamed:@"chatroom_redpacket_open_record"] forState:UIControlStateNormal];
    [seeEveryoneLuckButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [seeEveryoneLuckButton setImageEdgeInsets:UIEdgeInsetsMake(2, 57, 0, -57)];
    [seeEveryoneLuckButton setTintColor:[UIColor colorWithHexString:@"#F7C35B"]];
    [seeEveryoneLuckButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    seeEveryoneLuckButton.tag = EVButtonTag_See;
    [bgImageView addSubview:seeEveryoneLuckButton];
    [seeEveryoneLuckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.rstLabel withOffset:160];
    [seeEveryoneLuckButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [seeEveryoneLuckButton autoSetDimensionsToSize:CGSizeMake(120, 40)];
    self.seeEveryoneLuckButton = seeEveryoneLuckButton;
    self.seeEveryoneLuckButton.hidden = !self.chaiBtn.hidden;
    
    UILabel *errorTipLabel = [[UILabel alloc]init];
    errorTipLabel.text = kE_GlobalZH(@"noNetwork");
    errorTipLabel.hidden = YES;
    errorTipLabel.textColor = [UIColor whiteColor];
    errorTipLabel.font = [UIFont systemFontOfSize:15.f];
    [bgImageView addSubview:errorTipLabel];
    [errorTipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [errorTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgImageView withOffset:-15.f];
    self.errorTipLabel = errorTipLabel;
}

- (void)teardown
{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.currentKeyWindow = nil;
    self.layoutDirty = NO;
    self.containerView = nil;
    self.resultLabel = nil;
    self.rstLabel = nil;
    self.mTableView = nil;
    self.chaiBtn = nil;
    [self.engine cancelAllOperation];
    self.engine = nil;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *Array = sRedEnvelopeDictionary[[EVRedEnvelopeView currentView].currentModel.hid];
    
    return Array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, 30.f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3" alpha:1.f];
    
    NSString *text = kE_GlobalZH(@"red_rank_list");
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:11.f];
    label.textColor = [UIColor colorWithHexString:@"#5d5854" alpha:.5f];
    label.text = text;
    [headerView addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UILabel *dividingLine = [[UILabel alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [headerView addSubview:dividingLine];
    [dividingLine autoSetDimension:ALDimensionHeight toSize:.5f];
    [dividingLine autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [dividingLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView];
    [dividingLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerView];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifierKey";
    EVRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( !cell )
    {
        cell = [[EVRedEnvelopeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *arr = sRedEnvelopeDictionary[[EVRedEnvelopeView currentView].currentModel.hid];
    cell.itemModel = arr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case EVButtonTag_Cancel:
        {
            [self dismissAnimated:YES];
        }
            break;
            
        case EVButtonTag_Chai:
        {
            [self loadData];
        }
            
            break;
        case EVButtonTag_See:
        {
            [self seeLuck];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - loadData

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        self.engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (void)seeLuck
{
    [self.engine cancelAllOperation];
    
    EVRedEnvelopeView *curView = [EVRedEnvelopeView currentView];
    NSString *hid = curView.currentModel.hid;
    self.errorTipLabel.hidden = YES;
    self.bgImageView.image = [UIImage imageNamed:@"living_redpaper_opened_yes"];
    [self deleteRotationAnimation];
    
    int value = 0;
    for (EVRedEnvelopeItemModel * model in sRedEnvelopeDictionary[hid])
    {
        EVLoginInfo *loginInfo = [EVLoginInfo localObject];
        if ([model.name isEqualToString:loginInfo.name]) {
            value = [model.ecoin intValue];
        }
    }
    
    NSString *string = [NSString stringWithFormat:@"%d%@", value,kE_Coin];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(string.length - 2, 2)];
    self.resultLabel.attributedText = attStr;
    if ([sRedEnvelopeBrokenDic[hid] intValue] == 2) {
        self.resultLabel.hidden = YES;
    }
    
    [self deleteSameModelsWithHid:hid];
    
    [self.mTableView reloadData];
    [self exchangeViewAnimation];
}

- (void)loadData
{
    [self.engine cancelAllOperation];
    
    EVRedEnvelopeView *curView = [EVRedEnvelopeView currentView];
    NSString *hid = curView.currentModel.hid;
    __weak typeof(curView) wself = curView;
    [self.engine GETRedEnvelopeVid:curView.vid code:hid start:^{
        wself.errorTipLabel.hidden = YES;
        wself.rstLabel.hidden = YES;
        [wself rotationAnimation];
    } fail:^(NSError *error) {
        wself.errorTipLabel.hidden = NO;
        [wself.chaiBtn.layer removeAnimationForKey:@"chaiBtn-layer-rotate-layer"];
    } success:^(NSDictionary *retinfo) {
        wself.errorTipLabel.hidden = YES;
        wself.bgImageView.image = [UIImage imageNamed:@"living_redpaper_opened_yes"];
        [wself deleteRotationAnimation];
        
        NSLog(@"------------------   %@",retinfo);
        NSMutableArray *userNames = [NSMutableArray array];
        NSArray *userArray = [EVRedEnvelopeModel objectWithDictionaryArray:retinfo[@"users"]];
        for (EVRedEnvelopeModel *userModel in userArray) {
            [userNames addObject:userModel.name];
        }
         self.isChai = YES;
        if([userNames containsObject:[EVLoginInfo localObject].name]) {
            
            for (EVRedEnvelopeModel *userModel in userArray) {
                
                if ([userModel.name isEqualToString:[EVLoginInfo localObject].name]) {
                   
                    NSString *string = [NSString stringWithFormat:@"%ld%@", [userModel.ecoin integerValue],kE_Coin];
                    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
                    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(string.length - 2, 2)];
                    wself.resultLabel.attributedText = attStr;
                    
                    if ( wself.grabRedEnveloCompleteHandler )
                    {
                        wself.grabRedEnveloCompleteHandler(wself, [userModel.ecoin integerValue]);
                    }
                }
                
            }
            
        }else {
            wself.rstLabel.hidden = NO;
            wself.rstLabel.text = failAlert;
            sRedEnvelopeBrokenDic[hid] = @(2);
            wself.seeEveryoneLuckButton.hidden = NO;
            
            return;
        }
        
      
        NSArray *allUserA = [EVRedEnvelopeItemModel objectWithDictionaryArray:retinfo[@"users"]];
        [self.allRedArray addObjectsFromArray:allUserA];
        
        [sRedEnvelopeDictionary setValue:allUserA forKey:hid];
        sRedEnvelopeBrokenDic[hid] = @(1);
        
        [wself.mTableView reloadData];
        [wself exchangeViewAnimation];
        
    } sessionExpire:^{
        [wself deleteRotationAnimation];
        EVRelogin(wself);
    }];
}

- (void)deleteSameModelsWithHid:(NSString *)hid
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    for (EVRedEnvelopeItemModel * model in sRedEnvelopeDictionary[hid]) {
        [dic setObject:model forKey:model.name];
    }
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (NSString * key in dic.allKeys) {
        EVRedEnvelopeItemModel * model = [dic objectForKey:key];
        [array addObject:model];
    }
    
    [sRedEnvelopeDictionary setObject:array forKey:hid];
}

- (NSMutableArray *)allRedArray
{
    if (!_allRedArray) {
        _allRedArray = [NSMutableArray array];
    }
    
    return _allRedArray;
}

@end
