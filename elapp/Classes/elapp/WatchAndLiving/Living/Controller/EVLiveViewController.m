//
//  EVLiveViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveViewController.h"
#import <PureLayout.h>
#import "EVShareManager.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVNetWorkStateManger.h"
#import "EVRecoderInfo.h"
#import "EVStreamer.h"
#import "EVAlertManager.h"
#import "EVLoginInfo.h"
#import "EVEventController.h"
#import "EVLiveEvents.h"
#import "UzysImageCropperViewController.h"
#import "EVVideoTopicItem.h"
#import "EVLiveBottomItemView.h"
#import "EVLiveSlider.h"
#import "AppDelegate.h"
#import "EVLiveTipsLabel.h"
#import "EVLiveAnchorSendRedPacketView.h"
#include <sys/time.h>
#import "EVLiveEncode.h"        
#import "EVFantuanContributionListVC.h"
#import "EVMessageManager.h"
#import "EVLiveEndView.h"
#import "EVLimitViewController.h"
#import "EVAudioPlayer.h"
#import "EVMusicView.h"
#import "EVLiveMessage.h"
#import "EVLiveMessage.h"
#import "EVHVPrePareController.h"
#import "EVHVLiveShareView.h"
#import "EVHVGiftAniView.h"
#import "EVSDKLiveEngineParams.h"


#define kDefaultErrorStateTitle             kNoNetworking
#define kLoadTitleNoNetWork                 kFailNetworking
#define kDismissAnimationTime               0.3
#define kMaxTitleLegth                      20
#define kCropImageSize                      CGSizeMake(ScreenWidth, (9*ScreenWidth)/16)
#define FOCUS_BUTTON_NORMAL_WH 100
#define FOCUS_BUTTON_FOCUS_WH 60
#define kLiveUpdateStateTimeInterval        5

typedef NS_ENUM(NSInteger, EVLiveShareType)
{
    EVLiveShareSina,
    EVLiveShareQQ,
    EVLiveShareWeiXin,
    EVLiveShareFriendCircle
};

typedef NS_ENUM(NSInteger, EVToggleCameraType)
{
    EVToggleCameraPrepare,
    EVToggleCameraLiving
};

static inline long long getcurrsecond()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    long long seconds = tv.tv_sec;
    return seconds;
}

@interface EVLiveViewController () < UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,EVControllerContacterProtocol, UzysImageCropperDelegate, EVLiveBottomItemViewDelegate, EVLiveEndViewDelegate, EVLiveSliderDelegate, CCLiveAnchorSendRedPacketViewDelegate,EVLivePrePareViewDelegate,EVVideoCodingDelegate,EVLivePrePareViewDelegate,EVLimitViewControllerDelegate,EVMusicViewDelegate,EVSDKMessageDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UzysImageCropperViewController *imageCropperViewController;   /**< 图片剪切器 */
@property (nonatomic, assign) BOOL focusing;//判断是否正在对焦

@property ( nonatomic, strong ) UITapGestureRecognizer *focusTap;//对焦的手势

@property (nonatomic, weak) UIView *livingView;//摄像头的视图

@property (nonatomic, strong) EVRecoderInfo *recoderInfo;//数据模型

@property (nonatomic,strong) EVBaseToolManager *engine;//请求

@property (nonatomic,assign) UIView *cover;//不明确视图

@property (nonatomic,weak) UILabel *coverLabel;

@property (nonatomic,strong) EVControllerItem *controllerItem;//收到的视频状态

@property (nonatomic,strong) EVEventController *eventController;//播放器事件处理器

@property (nonatomic,strong) NSArray *observerKeyPaths;//living视图方法的观察者

@property ( nonatomic, weak ) UIButton *muteItem;//静音按钮

@property (nonatomic,weak) EVLiveEndView *liveEndView;//直播停止视图

@property (nonatomic,weak) EVLiveSlider *slider;//花动调大小

@property (nonatomic,weak) UIButton *cameraFocusButton;//是选择对焦大小的button

@property ( nonatomic, weak ) EVLiveAnchorSendRedPacketView *sendPacketView;//主播发红包

@property (assign, nonatomic) BOOL isStartBtnClicked; /**< 是否点击了开始按钮，如果已经点击了开始按钮，那么从后台回来则开始直播 */

@property (assign, nonatomic) BOOL isBeautyOn; /**< 是否开启美颜，默认0不开启 */
@property (assign, nonatomic) BOOL isSharing; /**< 是否处于分享状态 */
@property (copy, nonatomic) NSString *getLiveUrl; /**< 二次获取直播url的请求地址 */
@property (assign, nonatomic) EVLiveState liveState; /**< 直播状态 */
@property (assign, nonatomic) BOOL isBadNetworkAlertingToClose; /**< 当前是否正在提示网络差到不能直播（控制提示只出现一次） */
@property (assign, nonatomic) long long lastNotitionTime; /**< 上次提示用户关闭的时间 */

@property (assign, nonatomic) long long anchorEcoinCount;

@property (nonatomic, strong) EVLiveEncode *liveEncode;

@property (nonatomic,strong) dispatch_queue_t countTimeQueue;

@property ( nonatomic, strong ) NSDateFormatter *formatter;

@property (nonatomic,strong) EVLimitViewController *limitVC;

@property (nonatomic, strong) EVMusicView *musicView;


@property (nonatomic, copy) NSString *callid;

@property (nonatomic, assign) BOOL isEndLink;

@property (nonatomic, weak) EVHVLiveShareView *liveShareView;

@property (nonatomic, weak) UIImageView *startAniImageView;


@property (nonatomic, assign) NSInteger isVideoTimer;


@end

@implementation EVLiveViewController
#pragma mark - ***********         Init💧         ***********
//轮播图可能会用到
+ (instancetype)liveViewControllerWithActivityInfo:(NSDictionary *)params
{
    EVLiveViewController *livingVC = [[EVLiveViewController alloc] init];
    if ( params[kVideo_title] )
    {
        // 如果有活动标题使用活动标题
        livingVC.recoderInfo.title = params[kVideo_title];
    }
    return livingVC;
}

+ (instancetype)liveViewControllerWithPasswordInfo:(NSDictionary *)passwordInfo
{
    EVLiveViewController *liveVC = [[EVLiveViewController alloc] init];
    return liveVC;
}

#pragma mark - ----------------------------------------------------------------------------

//添加观察对象
- (void)initContacterListener
{
    [self.controllerItem.events addObjectsFromArray:@[CCLiveStop, CCLiveSaveAndLeave,CCLiveReadingDestroy,CCLiveMuteButtonDidClicked, CCLiveReconnectedStreamEnd, LIVE_CAMERA_FOCUS]];
    [self.contacter addListener:self.controllerItem];
}

#pragma EVControllerContacterProtocol
- (void)receiveEvents:(NSString *)event withParams:(NSDictionary *)params
{
    if ( [event isEqualToString:CCLiveStop] )
    {
        self.recoderInfo.userRequestStop = YES;
        [self.liveEncode shutDownEncoding];
    }
    else if ( [event isEqualToString:CCLiveSaveAndLeave] || [event isEqualToString:CCLiveReadingDestroy] )
    {
        [self liveViewControllerDismissComplete:nil];
    }
    else if ( [event isEqualToString:CCLiveMuteButtonDidClicked] )
    {
        BOOL mute =  [params[CCLiveMuteButtonDidClicked] boolValue];
        [self muteRecoder:mute];
    }
    else if ( [event isEqualToString:CCLiveReconnectedStreamEnd] )
    {

    }
    else if ( [event isEqualToString:LIVE_CAMERA_FOCUS] )
    {
        CGPoint location = [params[LIVE_CAMERA_FOCUS] CGPointValue];
        self.liveEncode.focusFloat = location;
    }
}

//相机聚焦失败
- (void)cameraFocusFail:(NSString *)fail
{
    [EVProgressHUD showError:fail];
}

#pragma mark - EVLiveSliderDelegate
- (void)liveSlider:(EVLiveSlider *)slider valueChanged:(CGFloat)value
{
    self.recoderInfo.scale = value;
}

- (void)setUpPin
{
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePin:)];
    [self.view addGestureRecognizer:pin];
}

- (void)scalePin:(UIPinchGestureRecognizer *)pin
{
    if ( pin.state == UIGestureRecognizerStateBegan )
    {
        [self.slider showSlider];
    }
    else if ( pin.state == UIGestureRecognizerStateEnded )
    {
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.slider hiddenSlider];
        });
    }
    CGFloat diff = pin.scale - 1;
    self.slider.value += diff;
    pin.scale = 1;
}


#pragma mark - EVLiveShareViewDelegate
- (void)liveShareViewDidClickButton:(EVLiveShareButtonType)type
{
    NSString *nickName = [EVLoginInfo localObject].nickname;
    NSString *videoTitle = self.recoderInfo.title;
    NSString *shareUrlString = self.recoderInfo.share_url;

    if ([EVLoginInfo localObject].logourl == nil) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self liveShareViewDidClickButton:type];
        });
    }
    
    self.isSharing = YES;
    ShareType shareType = ShareTypeLiveAnchor;

    [UIImage gp_imageWithURlString:[EVLoginInfo localObject].logourl comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:nickName descriptionReplaceName:videoTitle descriptionReplaceId:nil URLString:shareUrlString image:image  outImage:nil];
    }];
    
}

#pragma mark - ***********      Networks 🌐       ***********
//用户资产信息得到火眼豆
- (void)getMyAssets
{
    __weak typeof(self) wself = self;
    [self.engine GETUserAssetsWithStart:^{
        
    } fail:^(NSError *error) {
        EVLog(@"get asset fail");
    } success:^(NSDictionary *videoInfo) {
        EVLog(@"get asset suEVess");
        [wself updateAssetWithInfo:videoInfo];
    } sessionExpire:^{
        EVRelogin(wself);
    }];
}
#pragma mark - ***********     Life Cycle ♻️      ***********
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
}

- (void)setNewOrientation:(BOOL)fullscreen
{
    if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpView];

    _isBeautyOn = YES;
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    EVLog(@"-------------  %d",[UIApplication sharedApplication].idleTimerDisabled);
//    if ([UIApplication sharedApplication].idleTimerDisabled == YES) {
//        [[EVAlertManager shareInstance] configAlertViewWithTitle:@"123" message:@"123" cancelTitle:@"123" WithCancelBlock:^(UIAlertView *alertView) {
//            
//        }];
//    }
  
    [self initContacterListener];

    [self setUpNotification];

    [self getMyAssets];
    
    [self updateAnchorInfo];
    
//    self.videoInfoView.item.mode = EVAudienceInfoItemLiving;

//    self.countTimeQueue = dispatch_queue_create("live count queue", DISPATCH_QUEUE_SERIAL);
    
//    [self setUpAudioPlayer];
    
//    self.linkManager.delegate = self;

    UIImageView *startAniImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:startAniImageView];
    self.startAniImageView = startAniImageView;
    self.startAniImageView.frame = CGRectMake((ScreenHeight - 80)/2, (ScreenWidth - 80)/2, 80, 80);
    self.startAniImageView.hidden  = NO;
    NSArray *arrayImage = @[@"ic_countdown3",@"ic_countdown2",@"ic_countdown1"];
    NSMutableArray *aniImages = [NSMutableArray array];
    for (NSInteger i = 0; i < arrayImage.count; i++) {
        UIImage *image = [UIImage imageNamed:arrayImage[i]];
        [aniImages addObject:image];
    }
    self.startAniImageView.animationImages  = aniImages;
    self.startAniImageView.animationDuration = 3;
    self.startAniImageView.animationRepeatCount = 0;

    EVHVGiftAniView *giftAniView = [[EVHVGiftAniView alloc] initWithFrame:CGRectMake(ScreenHeight - 100, ScreenWidth - 200, 80, 190)];
    giftAniView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:giftAniView];
    self.giftAniView = giftAniView;
    
}

- (void)receiveTimeUpdate:(NSNotification *)notification
{
    EVLog(@"==============================  %ld",self.isVideoTimer);
    self.isVideoTimer ++;
}

- (void)onFrameAnimationFinished:(NSTimer *)timer{
    UIImageView * imageView = (UIImageView *)[timer userInfo];
    [imageView removeFromSuperview];
}


- (void)setInitLiveEncode
{
    self.liveEncode = [[EVLiveEncode alloc]init];
    self.liveEncode.delegate = self;
    [self.liveEncode initWithLiveEncodeView:self.livingView];
    [self toggleCameraWithType:EVToggleCameraLiving];
}

- (void)setUpAudioPlayer
{
    NSString *pathFile = [[NSBundle mainBundle]pathForResource:@"Eagles - 加州旅馆.mp3" ofType:nil];
    
    [[EVAudioPlayer sharePlayer] setFilePath:pathFile];

    [[EVAudioPlayer sharePlayer] setSupportLoop:YES];
    
}


- (void)EVRecordAudioBufferList:(AudioBufferList *)audioBufferList
{
    [[EVAudioPlayer sharePlayer] mixWithRecordedBuffer:audioBufferList];
}


- (void)dealloc
{
    EVLog(@"EVLiveViewController is dealloc");
    _recoderInfo.needToReconnect = NO;
    [self removeObserver];
    [EVNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.liveEncode shutDownEncoding];
    _controllerItem.delegate = nil;
    _observerKeyPaths = nil;
    _imageCropperViewController = nil;
}

- (void)riceAmoutViewDidSelect
{
    EVFantuanContributionListVC *fantuanVC = [[EVFantuanContributionListVC alloc] init];
//    fantuanVC.name = self.videoInfoView.item.name;
    fantuanVC.isAnchor = YES;
    [self.navigationController pushViewController:fantuanVC animated:YES];
}


- (void)updateAnchorInfo
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
//    self.videoInfoView.item.nickname = loginInfo.nickname;
//    self.videoInfoView.item.gender = loginInfo.gender;
//    self.videoInfoView.item.watchSide = YES;
//    self.videoInfoView.item.location = loginInfo.location;
//    self.videoInfoView.item.name = loginInfo.name;
    self.anchorName = loginInfo.name;
}

// 更新资产信息
- (void)updateAssetWithInfo:(NSDictionary *)Info
{
   self.anchorEcoinCount = [Info[kEcoin] longLongValue];
}

- (void)forceToShutDown:(void (^)())complete
{
    // 如果还在直播设置页 就直接关掉
    if ( self.prepareView ) {
        [self finishLivePage];
    } else {
        [self sessionExpireAndRelogin];
    }
}

- (void)codingStateChanged:(EVEncodedState)state
{

    switch ( state )
    {
        case EVEncodedStateEncoderError:
        {
            // 编码器初始化失败
            [_liveEncode shutDownEncoding];
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"device_fail_living") comfirmTitle:kOK WithComfirm:^{
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
                [self setNewOrientation:NO];//调用转屏代码90
                self.recoderInfo.userRequestStop = YES;
                [self requestLiveStop];
                [[EVAudioPlayer sharePlayer] stop];
            }];
        }
            break;
            
        case EVEncodedStateConnecting:
        {
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"connection_server")];
        }
            break;
            
        case EVEncodedStateConnected:
        {
            self.liveState = EVLiveStateLiving;
            [self.tipsLabel hiddenWithAnimation];
        }
            break;
            
        case EVEncodedStateReconnecting:
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"again_connection")];
            break;
            
        case EVEncodedStateStreamOptimizComplete:
            self.liveState = EVLiveStateLiving;
            [self.tipsLabel hiddenWithAnimation];
            break;
            
        case EVEncodedStateStreamOptimizing:
            self.liveState = EVLiveStateNetworkBad;
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"network_poor_optimization")];
            break;
            
        case EVEncodedStateInitNetworkErreor:
                [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"not_network_init_error")];
            break;
        case EVEncodedStateNoNetWork:
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"network_weak_again_connection")];
            break;
            
        case EVEncodedStatePhoneCallComeIn:
        {
            self.liveState = EVLiveStatePhoneCallComeIn;
        }
            break;
            
        case EVEncodedStateLivingIsInterruptedByOther:
        {
            self.liveState = EVLiveStateHoldUp;
            //__weak typeof(self) wself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"living_end_again") comfirmTitle:kOK WithComfirm:^{
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
                
                [self setNewOrientation:NO];//调用转屏代码90
                self.recoderInfo.userRequestStop = YES;
                [self requestLiveStop];
                [[EVAudioPlayer sharePlayer] stop];
            }];
        }
            break;
            
        case EVEncodedStateNetWorkStateUnSuitForStreaming_lv1:
        {
            self.liveState = EVLiveStateNetworkWorse;
            if ( self.isBadNetworkAlertingToClose )
                return;
            
            long long interval = getcurrsecond() - self.lastNotitionTime;
            if ( interval < kLiveUpdateStateTimeInterval )
                return;
            self.isBadNetworkAlertingToClose = YES;
        }
            break;
            
        case EVEncodedStateNetWorkStateUnSuitForStreaming_lv2:
        {
            self.liveState = EVLiveStateNetworkWorst;
            if ( self.isBadNetworkAlertingToClose )
                return;
            self.recoderInfo.userRequestStop = YES;
            [self forceToRequestLiveStop];
            self.isBadNetworkAlertingToClose = YES;
            [_liveEncode shutDwonStream];
            [_liveEncode shutDwonStream];
            //__weak typeof(self) wself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"network_not_living") comfirmTitle:kOK WithComfirm:^{
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
                
                [self setNewOrientation:NO];//调用转屏代码90
                self.recoderInfo.userRequestStop = YES;
                [self requestLiveStop];
                [[EVAudioPlayer sharePlayer] stop];
            }];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - ***********      Actions 🌠        ***********
- (void)setUpObserver
{
    self.observerKeyPaths = @[@"recoderInfo.scale"];
    for ( NSString *item in self.observerKeyPaths )
    {
        [self addObserver:self forKeyPath:item options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserver
{
    for ( NSString *item in _observerKeyPaths )
    {
        [self removeObserver:self forKeyPath:item context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"recoderInfo.scale"] )
    {
        __weak typeof(self) wself = self;
        
        [self.liveEncode cameraZoomWithFactor:self.recoderInfo.scale fail:^(NSError *error) {
            [EVProgressHUD showError:kE_GlobalZH(@"zoom_fail") toView:wself.view];
        }];
    }
}

#pragma mark - ***********    Notifications 📢    ***********
#pragma mark - 直播的检测网络 和 直播准备
- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(netWorkChange:) name:CCNetWorkChangeNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(forceToClose) name:CCNeedToForceCloseLivePageOrWatchPage object:nil];
    EVNetworkStatus state = [EVNetWorkStateManger shareInstance].currNetWorkState;
    NSDictionary *userInfo = @{ CCNetWorkStateKey : @(state) };
    NSNotification *notification = [NSNotification notificationWithName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
    [self netWorkChange:notification];
}


// 检测网络状态的改变
- (void)netWorkChange:(NSNotification *)notification
{
    EVNetworkStatus status = [notification.userInfo[CCNetWorkStateKey] integerValue];
    if ( status == WithoutNetwork ) {
        // 直播还没准备好，也就是还在直播准备页的时候，对准备页进行处理
        if ( !self.recoderInfo.liveReady ) {
            [self.prepareView setLoadingInfo:kLoadTitleNoNetWork canStart:NO];
        }
    } else {
        if ( self.recoderInfo.recordRequested ) {
            return;
        }
        self.recoderInfo.recordRequested = YES;
        
        [self.prepareView setLoadingInfo:nil canStart:YES];
            // 普通直播
    }
}
// 强制关闭播放器
- (void)forceToClose
{
    [_liveEncode shutDownEncoding];
    [self liveViewControllerDismissComplete:nil];
}

- (void)closeRecorder
{
    // 关闭编码
    [_liveEncode shutDownEncoding];
}

- (void)boardCastContinueLiveInfo
{
    // AUDIENCE_CONTINUE_LIVIN
    [self updateVideoInfo:@{
                            AUDIENCE_CONTINUE_LIVING :
                                @YES, AUDIENCE_CONTINUE_LIVING :@YES}];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[AUDIENCE_UPDATE_TIME_MODE] = @(2);
    if ( self.recoderInfo.title ) {
        params[AUDIENCE_UPDATE_TITLE] = self.recoderInfo.title;
    }
    [self updateVideoInfo:params];
}

- (void)prepareToLiveWithInfo:(NSDictionary *)info
{
    self.recoderInfo.vid = info[kVid];
    self.vid =  self.recoderInfo.vid;
    self.recoderInfo.live_url = info[@"uri"];
    self.recoderInfo.share_url = info[@"share_url"];
    [_liveEncode upDateLiveUrl:info[@"uri"]];
    [self setUpObserver];
}


- (void)liveBottomView
{
    EVLiveBottomItemView *itemView = ((EVLiveBottomItemView*)self.bottomBtnContainerView);
    //不确定不隐藏的时候是否禁止
    if (itemView.cameraButton.hidden == YES) {
        itemView.flashButton.highlighted = YES;
        itemView.flashButton.userInteractionEnabled = NO;
    }
}

// 直播开始请求
- (void)requestLiveStart
{
    if (self.recoderInfo.vid == nil) {
        [EVProgressHUD showError:kE_GlobalZH(@"vid_nil")];
    }
    
    [self liveBottomView];
    self.bottomBtnContainerView.hidden = YES;
    self.recoderInfo.thumb = YES;
    __weak typeof(self) wself = self;
    self.liveEncode.startLiving = YES;
    self.bottomBtnContainerView.hidden = YES;
    wself.recoderInfo.startCountTime = YES;
    [wself boardCastLiveInfo];

}

- (void)startCountTime
{
    self.recoderInfo.currSecond = 0;
//     [EVNotificationCenter addObserver:self selector:@selector(modifyTime) name:EVUpdateTime object:nil];
}

- (void)modifyTime
{
    self.recoderInfo.currSecond++;
    //double currSecond = self.recoderInfo.currSecond;
    //NSString *time = [self stringFormattedTimeFromSeconds:&currSecond];
//    [self updateVideoInfo:@{AUDIENCE_UPDATE_PLAY_TIME: time}];
}

- (NSString *)stringFormattedTimeFromSeconds:(double *)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:*seconds];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [self.formatter setDateFormat:@"HH : mm : ss"];
    NSString *timeStr = [self.formatter stringFromDate:date];
    return timeStr;
}

- (void)boardCastLiveInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[AUDIENCE_UPDATE_TIME_MODE] = @(2);
    if ( self.recoderInfo.title ) {
        params[AUDIENCE_UPDATE_TITLE] = self.recoderInfo.title;
    }
    params[AUDIENCE_FONT_CARERA] = @(self.recoderInfo.fontCamera);
    params[AUDIENCE_FLASHLIGHT_ON] = @(self.recoderInfo.lighton);
    [self updateVideoInfo:params];
}

- (void)initialLiveViewDataView
{
    [self.prepareView disMiss];
    [self.view bringSubviewToFront:self.prepareView];
}

- (void)checkDelegate
{
    if ( self.foreCapture ) {
        if ( self.recoderInfo.thumbImage == nil ) {
            __weak typeof(self) wself =  self;
            [wself notifyDelegateWithImage:nil];
        } else {
            [self notifyDelegateWithImage:self.recoderInfo.thumbImage];
        }
    }
}

- (void)notifyDelegateWithImage:(UIImage *)image
{
    if ( [self.delegate respondsToSelector:@selector(liveDidStart:info:)] ) {
        if ( self.recoderInfo.vid ) {
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            if ( self.recoderInfo.vid ) {
                info[kVid] = self.recoderInfo.vid;
                if ( image ) {
                    info[kThumb] = image;
                }
            }
            [self.delegate liveDidStart:self info:info];
        }
    }
}

- (void)setUpView
{
    self.slidScrollView.contentSize = self.view.bounds.size;
    
    UIView *livingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:livingView];
    livingView.backgroundColor = [UIColor clearColor];
    self.livingView = livingView;
    [livingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view sendSubviewToBack:livingView];
   
    
    UIView *cover = [[UIView alloc] init];
    cover.hidden = YES;
    cover.backgroundColor = CCARGBColor(0, 0, 0, 0.5);
    cover.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:cover];
    [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.cover = cover;
    
    UILabel *coverLabel = [[UILabel alloc] init];
    coverLabel.textAlignment = NSTextAlignmentCenter;
    coverLabel.textColor = [UIColor whiteColor];
    coverLabel.font = [UIFont systemFontOfSize:14];
    [cover addSubview:coverLabel];
    [coverLabel autoCenterInSuperview];
    self.coverLabel = coverLabel;
    
    [self prepareForeView];
    
    [self addLiveEndView];
    
    [self addFocusView];
    
    // 点击手势用来对焦
    [self addFocusTapView];
    self.contentView.hidden = YES;
    
    self.floatView.isMng = YES;
}
- (void)addFocusTapView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
    
    UIView *focusView = [[UIView alloc] init];
    [self.contentView addSubview:focusView];
    [focusView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.riceAmountView];
    [focusView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTableView];
    focusView.backgroundColor = [UIColor clearColor];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusWithGesture:)];
//    [focusView addGestureRecognizer:focusTap];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[self.contentView class]]) {
        return YES;
    }else {
        return NO;
    }
}

// 直播状态提醒
- (void)addLiveStatusAlertView
{
    EVLiveTipsLabel *tipsLabel = [[EVLiveTipsLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    tipsLabel.hidden = YES;
    [tipsLabel hiddenWithAnimation];
}

// 对焦
- (void)addFocusView
{
    // 放大缩小对焦
    EVLiveSlider *slider = [[EVLiveSlider alloc] init];
    slider.alpha = 0.0;
    slider.delegate = self;
    slider.backgroundColor = [UIColor clearColor];
    [self.view addSubview:slider];
    [slider autoSetDimensionsToSize:CGSizeMake(LIVE_SLIDER_HEIGHT + 4 * LIVE_SLIDER_BUTTONWH , LIVE_SLIDER_WIDTH )];
    [slider autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    slider.transform = CGAffineTransformTranslate(slider.transform ,LIVE_SLIDER_HEIGHT * 0.5 - 0.5 * LIVE_SLIDER_WIDTH + 2 * LIVE_SLIDER_BUTTONWH, 0);
    slider.transform = CGAffineTransformRotate(slider.transform, - M_PI * 0.5);
    self.slider = slider;
    
    UIButton *cameraFocusButton = [[UIButton alloc] init];
    cameraFocusButton.hidden = YES;
    cameraFocusButton.frame = CGRectMake(0, 0, FOCUS_BUTTON_NORMAL_WH, FOCUS_BUTTON_NORMAL_WH);
    [cameraFocusButton setImage:[UIImage imageNamed:@"live_focus_big"] forState:UIControlStateNormal];
    [cameraFocusButton setImage:[UIImage imageNamed:@"live_focus_small"] forState:UIControlStateSelected];
    [self.view addSubview:cameraFocusButton];
    self.cameraFocusButton = cameraFocusButton;
    
    // 捏合手势，用来对焦
    [self setUpPin];
}

// 直播结束页面
- (void)addLiveEndView
{
    EVLiveEndView *liveEndView = [[EVLiveEndView alloc] init];
    liveEndView.delegate = self;
    liveEndView.frame = self.view.bounds;
    [self.view addSubview:liveEndView];
    _liveEndView = liveEndView;
    [liveEndView dismiss];
}


- (void)liveBottomItemViewButtonClick:(UIButton *)button
{
    switch ( button.tag )
    {
            
        case EVLiveBottomMuteItem:  // 静音
        {
            static BOOL selected = NO;
            self.muteItem.selected = !selected;
            [self.contacter boardCastEvent:CCLiveMuteButtonDidClicked withParams:@{CCLiveMuteButtonDidClicked: @(!selected)}];
            selected = !selected;
            break;
        }
        case EVLiveBottomFlashItem:
        {
            [self toggleLight];
        }
            break;
        case EVLivebottomCameraItem:
        {
             [self toggleCameraWithType:EVToggleCameraLiving];
        }
            break;
        case EVLiveBottomChatItem:  // 发送评论
            self.sendComment = YES;
            [self.chatTextView beginEdit];
            break;
            
        case EVLiveBottomShareItem:  // 分享
            [self showShareView:YES];
            break;
        
        case EVLiveBottomSendRedPacketItem: // 主播发红包
            self.sendPacketView.anchorEcoinCount = self.anchorEcoinCount;
            [self.sendPacketView show];
            break;
            
        case EVLivebottomFaceItem:
        {
            self.isBeautyOn = !self.isBeautyOn;
            [self.liveEncode enableFaceBeauty:self.isBeautyOn];
        }
            break;
        case EVLiveBottomPlayerItem:
        {
            [self.musicView showCover];
        }
            break;
        case EVLiveBottomLinkItem:
        {

        }
            break;
    }
}

- (void)noSeletedButton
{
    [self.prepareView.startLiveButton setBackgroundColor:[UIColor grayColor]];
    [self.prepareView.startLiveButton setEnabled:YES];
}

- (void)enableButton
{
    self.prepareView.startLiveButton.backgroundColor = [UIColor evMainColor];
    [self.prepareView.startLiveButton setEnabled:YES];
    self.prepareView.startLiveButton.userInteractionEnabled = YES;
}

- (void)prepareForeView
{
    EVLivePrePareView *prepareView = [[EVLivePrePareView alloc] init];
    [self.view addSubview:prepareView];
    prepareView.frame = self.view.bounds;
    prepareView.editTextFiled.delegate = self;
    prepareView.delegate = self;

    self.prepareView = prepareView;
    [self noSeletedButton];
    
    NSString *title = self.recoderInfo.title;
    // 设置默认标题
    if ( title != nil && self.recoderInfo.isDefaultTitle == NO ) {
        self.prepareView.title = title;
    }
}




#pragma mark - 直播网络状态提醒
- (void)updateLiveStatusWithTitle:(NSString *)title
{
    self.coverLabel.text = title;
    self.cover.hidden = NO;
}


- (void)updateResumeLiveStatusWithTitle:(NSString *)title
{
    self.coverLabel.text = title;
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        wself.cover.hidden = YES;
    });
}

#pragma mark - 服务器强行结束
- (void)liveForeToStop:(BOOL)fromServer
{
    if ( self.recoderInfo.userRequestStop )
    {
        return;
    }
    NSMutableString *title = [NSMutableString string];
    [title appendString:kE_GlobalZH(@"connection_time_out_live_end")];
    if ( fromServer ) {
        [title appendString:@"."];
    }
    [self forceToStopWithTitle:title];
}

- (void)forceToStopWithTitle:(NSString *)title
{
    __weak typeof(self) wself = self;
    self.recoderInfo.userRequestStop = YES;
    [self.liveEncode shutDwonStream];
    [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"living_end") message:title comfirmTitle:kOK WithComfirm:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [wself.contacter boardCastEvent:EVLiveRequestLiveStop withParams:nil];
    }];
    
}

- (void)EVInteractiveLiveUpdateStatus:(EVInteractiveLiveStatus)status
{
    
}

#pragma mark - pickLiveCover
- (void)startToPickCover
{
  
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:kCancel
                                        destructiveButtonTitle:nil
                                             otherButtonTitles: kE_GlobalZH(@"camera_shooting"), kE_GlobalZH(@"photo_gallery_change"), nil];
    [action showInView:self.view];
}


- (void)liveCategoryViewDidSelectItem:(EVVideoTopicItem *)item
{
    self.recoderInfo.topic.title = item.title;
    [self.prepareView.categoryButton setTitle:[NSString stringWithFormat:@"#%@#",item.title] forState:UIControlStateNormal];
}


#pragma mark - textFiled delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0 && self.prepareView.coverImage != nil) {
        [self enableButton];
    }else {
        [self noSeletedButton];
    }
    self.prepareView.title = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] )
    {
        [self.prepareView.editTextFiled resignFirstResponder];
        return NO;
    }
    else
    {
        NSString * replacedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ( replacedText.length > 20 )
        {
            textField.text = [replacedText substringToIndex:20];
            return NO;
        }
        if (range.length == 1) {
            return YES;
        }
    }
    return YES;
}

#pragma mark - pickLiveCover - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ( buttonIndex )
    {
        case 1: // 从相册中选取
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        case 0: // 拍照
        {
//            [self.prepareView startCaptureImage];
            [self addCarema];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - EVLiveEditTitleViewDelegate
- (void)liveEditTitleViewHidden
{
    self.bottomBtnContainerView.hidden = YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.chatTextView resignFirstResponder];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if ( image == nil ) {
        [EVProgressHUD showError:kE_GlobalZH(@"checking_image_save_photo")];
        return;
    }
    
    self.imageCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:image andframeSize:picker.view.frame.size andcropSize:CGSizeMake(1280, 720)];
    self.imageCropperViewController.delegate = self;
    [picker pushViewController:_imageCropperViewController animated:YES];
    [picker setNavigationBarHidden:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropperImage:(UIImage *)image originImage:(BOOL)originImage
{
    UzysImageCropperViewController *croperViewController = [[UzysImageCropperViewController alloc] initWithImage:image andframeSize:self.view.frame.size andcropSize:kCropImageSize originImage:originImage];
    croperViewController.delegate = self;
    [self presentViewController:croperViewController animated:YES completion:nil];
}

#pragma mark - UzysImageCropperDelegate
- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image
{
    UIImage *videoUpdatingThumb = [UIImage scaleImage:image scaleSize:kCropImageSize];
    self.recoderInfo.thumbImage = videoUpdatingThumb;
    
    [cropper dismissViewControllerAnimated:YES completion:^{
        self.prepareView.coverImage = image;
        if (self.prepareView.editTextFiled.text.length > 0 && self.prepareView.coverImage != nil) {
            [self enableButton];
        }else {
            [self noSeletedButton];
        }
    }];
   
    self.prepareView.captureSuccess = YES;
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EVAudienceViewControllerProtocol
- (void)topViewButtonType:(EVHVLiveTopViewType)type button:(UIButton *)button
{
    switch (type) {
        case EVHVLiveTopViewTypeClose:
        {
            AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            appDelegate.allowRotation = NO;//(以上2行代码,可以理解为打开横屏开关)
            
            [self setNewOrientation:NO];//调用转屏代码90
            self.recoderInfo.userRequestStop = YES;
            [self requestLiveStop];
            [[EVAudioPlayer sharePlayer] stop];
            
        }
            break;
        case EVHVLiveTopViewTypeMute:
        {
            button.selected = !button.selected;
            [self muteRecoder:button.selected];
        }
        
            break;
        case EVHVLiveTopViewTypeTurn:
        {
              [self toggleCameraWithType:EVToggleCameraLiving];
        }
            break;
        case EVHVLiveTopViewTypeShare:
        {
            self.liveShareView.hidden = NO;
            self.giftAniView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)audienceDidClicked:(EVAudienceInfoViewButtonType)btn
{
    
    switch ( btn )
    {
        case EVAudienceInfoCancel:
        {
            __weak typeof(self) weakself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"is_stop_living") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
                weakself.recoderInfo.userRequestStop = YES;
                [weakself requestLiveStop];
                [[EVAudioPlayer sharePlayer] stop];
            } cancel:nil];
        }
            break;
        
        case EVAudienceInfoCamera:
            [self toggleCameraWithType:EVToggleCameraPrepare];
            break;
        
        default:
            break;
    }
}

- (void)enterForeground
{
    if (self.isStartBtnClicked == NO) {
        return;
    }
    if ( !self.liveEncode.startLiving )  {
        
        [self initialLiveViewDataView];
        [self checkDelegate];
       
        self.bottomBtnContainerView.hidden = YES;
        self.recoderInfo.startCountTime = YES;
        [self boardCastLiveInfo];
    }
}

#pragma mark - liveShare
- (void)liveShareWithType:(EVLiveShareType)type
{
    EVLiveShareButtonType shareType = 0;
    switch (type)
    {
        case EVLiveShareSina:
            shareType = EVLiveShareSinaWeiBoButton;
            break;
        case EVLiveShareQQ:
            shareType = EVLiveShareQQButton;
            break;
        case EVLiveShareWeiXin:
            shareType = EVLiveShareWeiXinButton;
            break;
        case EVLiveShareFriendCircle:
            shareType = EVLiveShareFriendCircleButton;
            break;
        default:
            break;
    }
    [self liveShareViewDidClickButton:shareType];
}

- (void)addCarema
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备上没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - EVLivePrePareViewDelegate
- (void)livePrePareView:(EVLivePrePareView *)view didClickButton:(EVLivePrePareViewButtonType)type
{
    
    EVLiveBottomItemView *itemView = ((EVLiveBottomItemView*)self.bottomBtnContainerView);
    switch (type)
    {
        case EVLivePrePareViewButtonCaptureAnImage:
        {
            [self.liveEncode getCapture:^(UIImage *image) {
                [self cropperImage:image originImage:YES];
            }];
        }
            break;
        case EVLivePrePareViewButtonToggleCamera:
            
            [self toggleCameraWithType:EVToggleCameraLiving];
            itemView.cameraButton.selected = !itemView.cameraButton.selected;
            itemView.flashButton.highlighted = itemView.cameraButton.selected;
            itemView.flashButton.userInteractionEnabled = !itemView.cameraButton.selected;
            
            EVLog(@"user interaction enable = %d", itemView.flashButton.userInteractionEnabled);
            break;
            
        case EVLivePrePareViewButtonCancel:
            [self finishLivePage];
            
            break;
        case EVLivePrePareViewButtonLiveStart:
        {
            [self startLiving];
        }
            break;
        case EVLivePrePareViewButtonCover:
            [self startToPickCover];
            break;
        
        case EVLivePrePareViewButtonPermission:
        {
            [self gotoAthorityPage];
        }
            break;
        case EVLivePrePareViewButtonCategory:
        {
          
            
        }
            break;
            
        default:
            break;
    }
}



- (void)touchMusicButton:(MusicButtonType)musicType button:(UIButton *)btn
{
    switch (musicType) {
        case MusicButtonTypePlay:
        {
            [[EVAudioPlayer sharePlayer] play];
        }
            
            break;
        case MusicButtonTypePause:
        {
            [[EVAudioPlayer sharePlayer] pause];
        }
            break;
        
        case MusicButtonTypeResume:
        {
            [[EVAudioPlayer sharePlayer] resume];
        }
            break;
        
        case MusicButtonTypeStop:
        {
             [[EVAudioPlayer sharePlayer] stop];
        }
            break;
            
        default:
            break;
    }
}


- (void)startLiving
{
    self.isStartBtnClicked = YES;
 
    NSString *liveTitle = self.prepareView.title;
    self.recoderInfo.title = liveTitle;
    if (liveTitle.length <= 0 || self.prepareView.coverImage == nil) {
        [EVProgressHUD showError:@"请填写标题和上传封面"];
        return;
    }
    [EVProgressHUD showMessage:@"加载中" toView:self.view];
    WEAK(self)
    NSMutableDictionary *params = [self.recoderInfo liveStartParams];
    
    [self.engine GETLivePreStartParams:params Start:^{
        [EVProgressHUD showSuccess:@"请等待" toView:self.view];
    } fail:^(NSError *error) {
        NSString *customError = error.userInfo[kCustomErrorKey];
        if ( [customError isEqualToString:@"E_USER_PHONE_NOT_EXISTS"] ) {
            [weakself liveNeedToBindPhone];
        } else if ( customError ) {
            [weakself.prepareView setLoadingInfo:customError canStart:NO];
        } else {
            [weakself.prepareView setLoadingInfo:kDefaultErrorStateTitle canStart:NO];
        }
    } success:^(NSDictionary *info) {
        // 普通直播流程记录直播信息到本地
        if ( self.prepareView.currShareTye == EVLivePrePareViewShareNone && self.recoderInfo.vid != nil ) {
            [self requestLiveStart];
        } else {
            if ( self.recoderInfo.thumbImage ) {
                [self checkUserInfoAndStartLiving];
            } else {
                __weak typeof(self) wself = self;
                [wself checkUserInfoAndStartLiving];
            }
        }
        [EVNotificationCenter addObserver:self selector:@selector(receiveTimeUpdate:) name:EVUpdateTime object:nil];
        [EVProgressHUD hideHUDForView:self.view];
       
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
        
        [self setNewOrientation:YES];//调用转屏代码90
        self.tipsLabel.frame = CGRectMake(0, 0, ScreenHeight, 20);
        [self setInitLiveEncode];
        [NSTimer scheduledTimerWithTimeInterval:3
                                         target:self
                                       selector:@selector(onFrameAnimationFinished:)
                                       userInfo:self.startAniImageView
                                        repeats:NO];
        self.topicVid = info[@"vid"];
        self.startAniImageView.hidden = NO;
        [self.startAniImageView startAnimating];
        [self upLoadThumbWithVid:self.topicVid];
        [self prepareToLiveWithInfo:info];
        self.recoderInfo.startCountTime = YES;
        [self startCountTime];
        [self.liveEncode startEncoding];
        self.contentView.hidden = NO;
        [self initialLiveViewDataView];
        [self initSDKMessage];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//        if ([UIApplication sharedApplication].idleTimerDisabled == NO) {
//            [[EVAlertManager shareInstance] configAlertViewWithTitle:@"2222222222" message:@"123" cancelTitle:@"123" WithCancelBlock:^(UIAlertView *alertView) {
//                
//            }];
//        }
    } sessionExpire:^{
        EVRelogin(self);
    }];

}

- (void)upLoadThumbWithVid:(NSString *)vid
{
    if ( vid == nil || self.recoderInfo.thumbImage == nil ) {
        return;
    }
        NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
        NSString *fileName = [NSString stringWithFormat:@"file"];
        postParams[kFile] = fileName;

   [self.engine upLoadVideoThumbWithiImage:self.recoderInfo.thumbImage vid:vid fileparams:postParams success:^(NSDictionary *dict) {
       
   } sessionExpire:^{
       
   }];
}
- (void)gotoAthorityPage
{
    EVLimitViewController *limitVC = self.limitVC;
    if ( limitVC == nil ) {
        limitVC = [[EVLimitViewController alloc] init];
        limitVC.delegate = self;
        self.limitVC = limitVC;
    } else {
        limitVC.reuse = YES;
    }
    [self presentViewController:limitVC animated:YES completion:nil];
}



- (void)limitViewControllerDidComfirmWithPermission:(EVLivePermission)permission params:(NSDictionary *)params
{
    if ( permission == EVLivePermissionPassWord )
    {
        self.recoderInfo.password = params[kPassword];
    } else if (permission == EVLivePermissionPay) {
        self.recoderInfo.payPrice = params[@"price"];
    }
    self.recoderInfo.permission = permission;
}


- (void)checkUserInfoAndStartLiving
{
    EVLiveShareButtonType type = 0;
    switch ( self.prepareView.currShareTye )
    {
        case EVLivePrePareViewShareSina:
        {
            type = EVLiveShareSinaWeiBoButton;
        }
            break;
            
        case EVLivePrePareViewShareWeixin:
            type = EVLiveShareWeiXinButton;
            break;
            
        case EVLivePrePareViewShareFriendCircle:
            type = EVLiveShareFriendCircleButton;
            break;
            
        case EVLivePrePareViewShareQQ:
            type = EVLiveShareQQButton;
            break;
        case EVLivePrePareViewShareQQZone:
            type = EVLiveShareQQZoneButton;
            break;
            
        default:
            break;
    }
    [self liveShareViewDidClickButton:type];
}


- (void)finishLivePage
{
    // 防止循环引用
    [self.view endEditing:YES];
    [self liveViewControllerDismissComplete:nil];
}

- (void)initSDKMessage
{
    EVLiveMessage *liveMessage = [[EVLiveMessage alloc] init];
    liveMessage.delegate = self;
    self.messageSDKEngine = liveMessage;
}


#pragma mark - EVLiveAnchorSendRedPacketViewDelegate
- (void)liveAnchorSendPacketViewView:(EVLiveAnchorSendRedPacketView *)sendPacketView packets:(NSInteger)packets ecoins:(NSInteger)ecoins greetings:(NSString *)greetings
{
    EVLog(@"%zd --- %zd --- %@", packets, ecoins, greetings);
    [self.engine GETLiveSendRedPacketWithVid:self.vid ecoin:ecoins count:packets greeting:greetings start:^{
        
    } fail:^(NSError *error) {
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"send_red_fail")];
        [EVProgressHUD showError:errorStr];
    } success:^{
        self.anchorEcoinCount = self.anchorEcoinCount - ecoins;
        EVLog(@"send red packet suEVess");
    } sessionExpire:^{
        
    }];
}

#pragma mark - EVLiveEndViewDelegate 回放
- (void)liveEndView:(EVLiveEndView *)liveEndView
         didClicked:(EVLiveEndViewButtonType)type
{
    switch ( type )
    {
        case EVLiveEndViewReadingDestroyButton:
        {
            [self destroyAndQuit];
        }
            break;
        case EVLiveEndViewSaveVideoButton:
            if ( self.recoderInfo.noCanSaveVideo )
            {
                [self destroyAndQuit];
                return;
            }
            [self.contacter boardCastEvent:CCLiveSaveAndLeave withParams:nil];
            break;
        default:
            break;
    }
}

- (void)destroyAndQuit
{
    __weak typeof(self) wself = self;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).liveEngine GETAppdevRemoveVideoWith:self.recoderInfo.vid start:nil fail:^(NSError *error) {
        [wself dismissViewControllerAnimated:NO completion:nil];
        EVLog(@"!!!!!!!!appdev remove fail...");
    } success:^{
        [wself dismissViewControllerAnimated:NO completion:nil];
        EVLog(@"---------------appdev remove suEVess...");
    } sessionExpire:^{
        [wself dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.contacter boardCastEvent:CCLiveReadingDestroy withParams:nil];
}


- (void)liveLinkSelectAcccount:(nonnull EVLinkUserModel *)account
{
  
    
}

- (void)anchorAcceptSuccessCallid:(NSString *)callid
{
    self.callid = callid;
    [self.liveEncode startLinkChannelid:callid];
}

#pragma mark - liveOperatiion
- (void)toggleCameraWithType:(EVToggleCameraType)type
{
    __weak typeof(self) wself = self;
    if ( self.recoderInfo.totogling )
    {
        return;
    }
    self.recoderInfo.totogling = YES;
    [_liveEncode switchCamera:!self.recoderInfo.fontCamera complete:^(BOOL suEVess, NSError *error) {
        if( suEVess )
        {
            [wself recoderInfo].fontCamera = !wself.recoderInfo.fontCamera;
            if ( type == EVToggleCameraPrepare )
            {
//                [wself.videoInfoView buttonDidClicked:wself.videoInfoView.cameraButton];
            }
        }

        wself.recoderInfo.totogling = NO;
    }];
}

//开启闪光灯
- (void)toggleLight
{
    if ( self.recoderInfo.totogling ) return;
    self.recoderInfo.totogling = YES;
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ( [flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn] )
    {
        BOOL suEVess = [flashLight lockForConfiguration:NULL];
        if ( suEVess )
        {
            if ( [flashLight isTorchActive] )
            {
                [flashLight setTorchMode:AVCaptureTorchModeOff];
                self.recoderInfo.lighton = NO;
            }
            else
            {
                [flashLight setTorchMode:AVCaptureTorchModeOn];
                self.recoderInfo.lighton = YES;
            }
            [flashLight unlockForConfiguration];
        }
    }
    
    self.recoderInfo.totogling = NO;
    [self.contacter boardCastEvent:CCLiveInfoUpdate
                        withParams:@{
                                     CCLiveInfoKey : @{AUDIENCE_FLASHLIGHT_ON : @(self.recoderInfo.lighton)}
                                     }];
}

- (void)muteRecoder:(BOOL)mute
{
    [self.liveEncode setIsMute:mute];
    self.recoderInfo.mute = !self.recoderInfo.mute;
    BOOL currMute = self.recoderInfo.mute;
    [self.contacter boardCastEvent:CCLiveMuteStateChange withParams:@{CCLiveDidMuteKey: @(currMute)}];
}

#pragma mark - other
- (void)relogin
{
    [self liveViewControllerDismissComplete:^{
        if ( [self.delegate respondsToSelector:@selector(liveNeedToRelogin:)] )
        {
            [self.delegate liveNeedToRelogin:self];
        }
    }];
}

- (void)liveNeedToBindPhone
{
    [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"first_phone_attest") message:kE_GlobalZH(@"first_phone_attest_title") cancelButtonTitle:kCancel comfirmTitle:kE_GlobalZH(@"start_attest") WithComfirm:^{
        [self liveViewControllerDismissComplete:^{
            if ( [self.delegate respondsToSelector:@selector(liveNeedToBindPhone:)] )
            {
                [self.delegate liveNeedToBindPhone:self];
            }
        }];
    } cancel:^{
        [self liveViewControllerDismissComplete:nil];
    }];
}

- (void)videoChatCloseAction
{
    [self.liveEncode endLink];
}

#pragma mark - cycleMessage
- (void)liveViewControllerDismissComplete:(void(^)())complete
{
    [self dismissShareView];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ( complete )
        {
            complete();
        }
    }];
}

#pragma mark - private message
- (void)requestLiveStop
{
    [self.liveEncode endLink];
//    NSDictionary *commentFormat = [NSDictionary dictionaryWithObjectsAndKeys:@"1",EVMessageKeySt, nil];
//    NSMutableDictionary *commentJoin = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentFormat,EVMessageKeyLvst, nil];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commentJoin options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [[EVMessageManager shareManager] sendMessage:@"1" userData:jsonString toTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode) {
//        if (isSuccess) {
//            EVLog(@"sendmessagesuccess ------------");
//        }else{
//            
//            EVLog(@"errorCode ------------------");
//        }
//    }];
    if (self.isVideoTimer <= 120) {
        EVLog(@"remove---------------------------------");
        [((AppDelegate *)[UIApplication sharedApplication].delegate).liveEngine GETAppdevRemoveVideoWith:self.recoderInfo.vid start:nil fail:^(NSError *error) {
            
        } success:^{
            EVLog(@"deleteVideo------------ success");
        } sessionExpire:^{
            
        }];
    }
    

    self.bottomBtnContainerView.hidden = YES;
    [self.sendPacketView dismiss];
    [self.contacter boardCastEvent:CCLiveStop withParams:nil];
    __weak typeof(self) wself = self;
//    [self.engine ]
    [self.liveEndView show:^{
        [wself hiddenContentSubviews];
    }];
    [self successUpdateCount];
    [self.engine GETAppdevstopliveWithVid:self.recoderInfo.vid start:^{
    } fail:^(NSError *error) {
        [wself showLiveEndViewWithInfo:nil];
    } success:^(NSDictionary *videoInfo) {
        EVLog(@"videoremove-------------------------");
    } sessionExpire:^{
        [wself showLiveEndViewWithInfo:nil];
    }];
}


- (void)successUpdateCount
{
     self.liveEndView.riceCountLabel.text = [NSString stringWithFormat:@"%lld",self.growwatch_count];
    self.liveEndView.audienceCountLabel.text = [NSString stringWithFormat:@"%lld",self.growwatching_count];
    self.liveEndView.likeCountLabel.text = [NSString stringWithFormat:@"%lld",self.growHuoyanbi];
    if (self.isVideoTimer > 300) {
        self.liveEndView.tipLabel.text = @"已保存至我的直播";
    }
}
/**
 *  仅仅告诉服务器，直播结束，不做任何其他操作
 */
- (void)forceToRequestLiveStop
{
    [self.engine GETAppdevstopliveWithVid:self.recoderInfo.vid start:nil fail:nil success:nil sessionExpire:nil];
}

- (void)showLiveEndViewWithInfo:(NSDictionary *)videoInfo
{
    [self.view endEditing:YES];
  
//    EVLiveEndViewData *data = [[EVLiveEndViewData alloc] init];
//    if ( videoInfo )
//    {
//        self.recoderInfo.play_url = videoInfo[kPlay_url];
//        data.commentCount = [videoInfo[kComment_count] integerValue];
//        data.likeCount = self.like_count;
//        data.audienceCount = self.watch_count;
//        data.signature = self.recoderInfo.title;
//        data.playBackURLString = self.recoderInfo.play_url;
//    }
//    else
//    {
//        data.commentCount = self.recoderInfo.liveUserInfo.video_info.comment_count;
//        data.likeCount = self.recoderInfo.liveUserInfo.video_info.like_count;
//        data.audienceCount = self.recoderInfo.liveUserInfo.video_info.watch_count;
//        data.signature = self.recoderInfo.title;
//    }
//    data.riceCount = self.riceAmountView.lasttimeRiceCount;
//    self.recoderInfo.noCanSaveVideo = data.noCanKeepVideo;
//    self.liveEndView.liveViewData = data;
}

// 对焦
- (void)focusWithGesture:(UITapGestureRecognizer *)tap
{
    self.liveShareView.hidden = YES;
    if ( self.contentView.frame.origin.y < 0 )
    {
        [self.chatTextView emptyText];
    }
    else
    {
        CGPoint tapLocation = [tap locationInView:self.contentView];
        if ( tapLocation.y > self.riceAmountView.frame.size.height + self.riceAmountView.frame.origin.y && tapLocation.y < self.bottomBtnContainerView.frame.origin.y )
        {
            [self beginFocusWithPoint:tapLocation];
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    self.liveShareView.hidden = YES;
    self.giftAniView.hidden = NO;
    
}


// 对焦
- (void)beginFocusWithPoint:(CGPoint)point
{
    if ( self.recoderInfo.fontCamera || self.focusing )
    {
        return;
    }
    self.focusing = YES;
    self.cameraFocusButton.selected = NO;
    self.cameraFocusButton.hidden = NO;
    CGRect frame = self.cameraFocusButton.frame;
    frame.size = CGSizeMake(FOCUS_BUTTON_NORMAL_WH, FOCUS_BUTTON_NORMAL_WH);
    self.cameraFocusButton.frame = frame;
    self.cameraFocusButton.center = point;
    [self.contacter boardCastEvent:LIVE_CAMERA_FOCUS withParams:@{ LIVE_CAMERA_FOCUS : [NSValue valueWithCGPoint:point] }];
    
    frame = self.cameraFocusButton.frame;
    frame.size = CGSizeMake(FOCUS_BUTTON_FOCUS_WH, FOCUS_BUTTON_FOCUS_WH);
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:1.0 animations:^{
        wself.cameraFocusButton.frame = frame;
        wself.cameraFocusButton.selected = YES;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wself.cameraFocusButton.hidden = YES;
            wself.focusing = NO;
        });
    }];
}

- (void)updateMessageLinkDict:(NSDictionary *)dict comment:(NSString *)comment
{
}


- (void)updateLiveState:(BOOL)living
{
    // 直播状态
    if ( !living && !self.recoderInfo.forceRequest )
    {
        self.recoderInfo.forceRequest = YES;
        // 聊天服务器要求停止当前直播
        [self liveForeToStop:YES];
    }
}


#pragma mark - getters
- (EVLiveAnchorSendRedPacketView *)sendPacketView
{
    if ( !_sendPacketView )
    {
        EVLiveAnchorSendRedPacketView *sendPacketView = [[EVLiveAnchorSendRedPacketView alloc] init];
        sendPacketView.delegate = self;
        [self.view addSubview:sendPacketView];
        _sendPacketView = sendPacketView;
    }
    return _sendPacketView;
}

- (EVControllerItem *)controllerItem
{
    if ( _controllerItem == nil )
    {
        _controllerItem = [[EVControllerItem alloc] init];
        _controllerItem.delegate = self;
    }
    return _controllerItem;
}

#pragma EVEventContoller
- (EVEventController *)eventController
{
    if ( _eventController == nil )
    {
        _eventController = [[EVEventController alloc] init];
    }
    return _eventController;
}

- (EVRecoderInfo *)recoderInfo
{
    if ( _recoderInfo == nil )
    {
        _recoderInfo = [[EVRecoderInfo alloc] init];
        _recoderInfo.needToReconnect = NO;
        _recoderInfo.reconnectCount = 0;
    }
    return _recoderInfo;
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (EVMusicView *)musicView
{
    if (!_musicView) {
        _musicView = [[EVMusicView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 100)];
        _musicView.delegate = self;
        _musicView.hidden = YES;
        [self.view addSubview:_musicView];
        [self.view bringSubviewToFront:_musicView];
    }
    
    return _musicView;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

@end
