//
//  EVLiveViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

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
#import "EVCategoryViewController.h"
#import "EVAudioPlayer.h"

#define kDefaultErrorStateTitle             kNoNetworking
#define kLoadTitleNoNetWork                 kFailNetworking
#define kDismissAnimationTime               0.3
#define kMaxTitleLegth                      20
#define kCropImageSize                      CGSizeMake(640, 640)
#define FOCUS_BUTTON_NORMAL_WH 100
#define FOCUS_BUTTON_FOCUS_WH 60
#define kLiveUpdateStateTimeInterval        5

typedef NS_ENUM(NSInteger, CCLiveShareType)
{
    CCLiveShareSina,
    CCLiveShareQQ,
    CCLiveShareWeiXin,
    CCLiveShareFriendCircle
};

typedef NS_ENUM(NSInteger, CCToggleCameraType)
{
    CCToggleCameraPrepare,
    CCToggleCameraLiving
};

static inline long long getcurrsecond()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    long long seconds = tv.tv_sec;
    return seconds;
}

@interface EVLiveViewController () < UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,CCControllerContacterProtocol, UzysImageCropperDelegate, CCVideoViewProtocol, CCLiveBottomItemViewDelegate, EVLiveEndViewDelegate, CCLiveSliderDelegate, CCLiveAnchorSendRedPacketViewDelegate,CCLivePrePareViewDelegate,EVVideoCodingDelegate,CCLivePrePareViewDelegate,EVLimitViewControllerDelegate,EVCategoryViewControllerDelegate>


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

@property (assign, nonatomic) BOOL isPlayMp3;


@property (assign, nonatomic) BOOL isSharing; /**< 是否处于分享状态 */
@property (copy, nonatomic) NSString *getLiveUrl; /**< 二次获取直播url的请求地址 */
@property (assign, nonatomic) CCLiveState liveState; /**< 直播状态 */
@property (assign, nonatomic) BOOL isBadNetworkAlertingToClose; /**< 当前是否正在提示网络差到不能直播（控制提示只出现一次） */
@property (assign, nonatomic) long long lastNotitionTime; /**< 上次提示用户关闭的时间 */

@property (assign, nonatomic) long long anchorEcoinCount;

@property (nonatomic, strong) EVLiveEncode *liveEncode;


@property (nonatomic,strong) dispatch_queue_t countTimeQueue;

@property ( nonatomic, strong ) NSDateFormatter *formatter;

@property (nonatomic,strong) EVLimitViewController *limitVC;

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

#pragma CCControllerContacterProtocol
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
    [CCProgressHUD showError:fail];
}

#pragma mark - CCLiveSliderDelegate
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


#pragma mark - CCLiveShareViewDelegate
- (void)liveShareViewDidClickButton:(CCLiveShareButtonType)type
{
    NSLog(@"----- %@",[EVLoginInfo localObject].nickname);
    NSString *nickName = [EVLoginInfo localObject].nickname;
    NSString *videoTitle = self.recoderInfo.title;
    NSString *shareUrlString = self.recoderInfo.share_url;

    if ([EVLoginInfo localObject].logourl == nil) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self liveShareViewDidClickButton:type];
        });
    }
    
    self.isSharing = YES;
    ShareType shareType;
    if (self.isStartBtnClicked) {
        // 主播端直播
        shareType = ShareTypeLiveAnchor;
    } else {
        // 主播端开播分享
        shareType = ShareTypeAnchorBeginLive;
    }
    [UIImage gp_imageWithURlString:[EVLoginInfo localObject].logourl comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:nickName descriptionReplaceName:videoTitle descriptionReplaceId:nil URLString:shareUrlString image:image];
    }];
    
}

#pragma mark - ***********      Networks 🌐       ***********
//用户资产信息得到云币
- (void)getMyAssets
{
    __weak typeof(self) wself = self;
    [self.engine GETUserAssetsWithStart:^{
        
    } fail:^(NSError *error) {
        CCLog(@"get asset fail");
    } success:^(NSDictionary *videoInfo) {
        CCLog(@"get asset success");
        [wself updateAssetWithInfo:videoInfo];
    } sessionExpire:^{
        CCRelogin(wself);
    }];
}
#pragma mark - ***********     Life Cycle ♻️      ***********
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    _isBeautyOn = YES;
    
    [self initContacterListener];
    self.liveEncode = [[EVLiveEncode alloc]init];
    self.liveEncode.delegate = self;
    [self.liveEncode initWithLiveEncodeView:self.livingView];
    [self.liveEncode enableFaceBeauty:self.isBeautyOn];
    [self setUpNotification];
    [self getMyAssets];
    
    [self updateAnchorInfo];
    self.videoInfoView.item.mode = CCAudienceInfoItemLiving;
    
    self.countTimeQueue = dispatch_queue_create("live count queue", DISPATCH_QUEUE_SERIAL);
    [self setUpAudioPlayer];
}

- (void)setUpAudioPlayer
{
    NSString *pathFile = [[NSBundle mainBundle]pathForResource:@"殷承宗 - 苏三起解.mp3" ofType:nil];
    
    [[EVAudioPlayer sharePlayer]setFilePath:pathFile];

    [[EVAudioPlayer sharePlayer] setSupportLoop:YES];
    
}

- (void)dealloc
{
    CCLog(@"CCLiveViewController is dealloc");
    _recoderInfo.needToReconnect = NO;
    [self removeObserver];
    [CCNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.liveEncode shutDownEncoding];
    _controllerItem.delegate = nil;
    _observerKeyPaths = nil;
}

- (void)riceAmoutViewDidSelect
{
    EVFantuanContributionListVC *fantuanVC = [[EVFantuanContributionListVC alloc] init];
    fantuanVC.name = self.videoInfoView.item.name;
    fantuanVC.isAnchor = YES;
    [self.navigationController pushViewController:fantuanVC animated:YES];
}


- (void)updateAnchorInfo
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    self.videoInfoView.item.nickname = loginInfo.nickname;
    self.videoInfoView.item.gender = loginInfo.gender;
    self.videoInfoView.item.watchSide = YES;
    self.videoInfoView.item.location = loginInfo.location;
    self.videoInfoView.item.name = loginInfo.name;
    self.anchorName = loginInfo.name;
}

// 更新资产信息
- (void)updateAssetWithInfo:(NSDictionary *)Info
{
    //主播的总云币
   self.anchorEcoinCount = [Info[kEcoin] longLongValue];
}

- (void)forceToShutDown:(void (^)())complete
{
    // 如果还在直播设置页 就直接关掉
    if ( self.prepareView )
    {
        [self finishLivePage];
    }
    else
    {
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
                [self liveViewControllerDismissComplete:nil];
            }];
        }
            break;
            
        case EVEncodedStateConnecting:
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"connection_server")];
            break;
            
        case EVEncodedStateConnected:
        {
            self.liveState = CCLiveStateLiving;
            [self.tipsLabel hiddenWithAnimation];
        }
            break;
            
        case EVEncodedStateReconnecting:
            [self.tipsLabel showWithAnimationText:kE_GlobalZH(@"again_connection")];
            break;
            
        case EVEncodedStateStreamOptimizComplete:
            self.liveState = CCLiveStateLiving;
            [self.tipsLabel hiddenWithAnimation];
            break;
            
        case EVEncodedStateStreamOptimizing:
            self.liveState = CCLiveStateNetworkBad;
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
            self.liveState = CCLiveStatePhoneCallComeIn;
        }
            break;
            
        case EVEncodedStateLivingIsInterruptedByOther:
        {
            self.liveState = CCLiveStateHoldUp;
            CCLog(@"-----interrupt-------recorder");
       
            
            __weak typeof(self) wself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"living_end_again") comfirmTitle:kOK WithComfirm:^{
                wself.recoderInfo.userRequestStop = YES;
                [wself requestLiveStop];
                wself.liveState = CCLiveStateEnd;
            }];
        }
            break;
            
        case EVEncodedStateNetWorkStateUnSuitForStreaming_lv1:
        {
            self.liveState = CCLiveStateNetworkWorse;
            if ( self.isBadNetworkAlertingToClose )
                return;
            
            long long interval = getcurrsecond() - self.lastNotitionTime;
            if ( interval < kLiveUpdateStateTimeInterval )
                return;
            self.isBadNetworkAlertingToClose = YES;
            __weak typeof(self) wself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"network_very_weak_change") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
                [[EVMessageManager shareManager]close];
                [wself forceToRequestLiveStop];
                [CCNotificationCenter removeObserver:self name:CCUpdateForecastTime object:nil];
                [wself liveViewControllerDismissComplete:nil];
            } cancel:^{
                wself.lastNotitionTime = getcurrsecond();
                wself.isBadNetworkAlertingToClose = NO;
            }];
        }
            break;
            
        case EVEncodedStateNetWorkStateUnSuitForStreaming_lv2:
        {
            self.liveState = CCLiveStateNetworkWorst;
            if ( self.isBadNetworkAlertingToClose )
                return;
            self.recoderInfo.userRequestStop = YES;
            [self forceToRequestLiveStop];
            self.isBadNetworkAlertingToClose = YES;
            [_liveEncode shutDwonStream];
            [_liveEncode shutDwonStream];
            __weak typeof(self) wself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"network_not_living") comfirmTitle:kOK WithComfirm:^{
                [wself liveViewControllerDismissComplete:nil];
            }];
        }
            break;
            
        default:
            break;
    }

}

- (void)EVRecordAudioBufferList:(AudioBufferList *)audioBufferList
{
     [[EVAudioPlayer sharePlayer] mixWithRecordedBuffer:audioBufferList];
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
            [CCProgressHUD showError:kE_GlobalZH(@"zoom_fail") toView:wself.view];
        }];
    }
}

#pragma mark - ***********    Notifications 📢    ***********
#pragma mark - 直播的检测网络 和 直播准备
- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(netWorkChange:) name:CCNetWorkChangeNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(forceToClose) name:CCNeedToForceCloseLivePageOrWatchPage object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(heartBeatToUpdateLiveStatus) name:CCUpdateForecastTime object:nil];
    CCNetworkStatus state = [EVNetWorkStateManger sharedManager].currNetWorkState;
    NSDictionary *userInfo = @{ CCNetWorkStateKey : @(state) };
    NSNotification *notification = [NSNotification notificationWithName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
    
    [self netWorkChange:notification];
}

// 检测网络状态的改变
- (void)netWorkChange:(NSNotification *)notification
{
    CCNetworkStatus status = [notification.userInfo[CCNetWorkStateKey] integerValue];
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

//定时上传直播视频状态
- (void)heartBeatToUpdateLiveStatus
{
    if ( !self.isStartBtnClicked )
        return;
    
    static long int time = 0;
    time += 1;
    if ( time % kLiveUpdateStateTimeInterval != 1 )
        return;
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
    if ( self.recoderInfo.title )
    {
        params[AUDIENCE_UPDATE_TITLE] = self.recoderInfo.title;
    }
    
    [self updateVideoInfo:params];
    
}

- (void)prepareToLiveWithInfo:(NSDictionary *)info
{
    self.recoderInfo.vid = info[kVid];
    self.vid =  self.recoderInfo.vid;
    self.recoderInfo.live_url = info[@"uri"];
    self.recoderInfo.share_url = info[kShare_url];
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
        [CCProgressHUD showError:kE_GlobalZH(@"vid_nil")];
    }
    
    [self liveBottomView];
    self.bottomBtnContainerView.hidden = NO;
    self.recoderInfo.thumb = YES;
    __weak typeof(self) wself = self;
  
    self.liveEncode.startLiving = YES;
    self.bottomBtnContainerView.hidden = NO;
    wself.recoderInfo.startCountTime = YES;
    [wself boardCastLiveInfo];

}

- (void)startCountTime
{
    self.recoderInfo.currSecond = 0;
     [CCNotificationCenter addObserver:self selector:@selector(modifyTime) name:CCUpdateForecastTime object:nil];
}

- (void)modifyTime
{
    self.recoderInfo.currSecond++;
    double currSecond = self.recoderInfo.currSecond;
    
    NSString *time = [self stringFormattedTimeFromSeconds:&currSecond];
 
    [self updateVideoInfo:@{AUDIENCE_UPDATE_PLAY_TIME: time}];

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
    if ( self.recoderInfo.title )
    {
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
    if ( self.foreCapture )
    {
        if ( self.recoderInfo.thumbImage == nil )
        {
            __weak typeof(self) wself =  self;
            [wself notifyDelegateWithImage:nil];
        }
        else
        {
            [self notifyDelegateWithImage:self.recoderInfo.thumbImage];
        }
    }
}

- (void)notifyDelegateWithImage:(UIImage *)image
{
    if ( [self.delegate respondsToSelector:@selector(liveDidStart:info:)] )
    {
        if ( self.recoderInfo.vid )
        {
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            if ( self.recoderInfo.vid )
            {
                info[kVid] = self.recoderInfo.vid;
                if ( image )
                {
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
    // 手势引导
//    [self addGestureGuideCoverviewWithImageNamed:@"cue_living_setting"];
    [self addBottomToolBar];
    
    UIView *livingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:livingView];
    livingView.backgroundColor = [UIColor clearColor];
    self.livingView = livingView;
    [livingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view sendSubviewToBack:livingView];
   
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
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
    
    self.floatView.isMng = NO;
}
- (void)addFocusTapView
{
    UIView *focusView = [[UIView alloc] init];
    [self.contentView addSubview:focusView];
    [focusView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.riceAmountView];
    [focusView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTableView];
    focusView.backgroundColor = [UIColor clearColor];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [focusView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusWithGesture:)];
    [focusView addGestureRecognizer:focusTap];
}

// 直播状态提醒
- (void)addLiveStatusAlertView
{
    EVLiveTipsLabel *tipsLabel = [[EVLiveTipsLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
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

/** 添加下面的工具栏 */
- (void)addBottomToolBar
{
    EVLiveBottomItemView *bottomC = [[EVLiveBottomItemView alloc] init];
    bottomC.delegate = self;
    self.muteItem = bottomC.muteButton;
    [self.view addSubview:bottomC];
    bottomC.hidden = YES;
    [bottomC autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [bottomC autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [bottomC autoSetDimension:ALDimensionWidth toSize:2 * self.view.bounds.size.width];
    self.bottomBtnContainerView = bottomC;
    [self.loveView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bottomC];
    [self.loveView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bottomC];
}

- (void)liveBottomItemViewButtonClick:(UIButton *)button
{
    switch ( button.tag )
    {
            
        case CCLiveBottomMuteItem:  // 静音
        {
            static BOOL selected = NO;
            self.muteItem.selected = !selected;
            [self.contacter boardCastEvent:CCLiveMuteButtonDidClicked withParams:@{CCLiveMuteButtonDidClicked: @(!selected)}];
            selected = !selected;
            break;
        }
        case CCLiveBottomFlashItem:
        {
            [self toggleLight];
        }
            break;
        case CCLivebottomCameraItem:
        {
             [self toggleCameraWithType:CCToggleCameraLiving];
        }
            break;
        case CCLiveBottomChatItem:  // 发送评论
            self.sendComment = YES;
            [self.chatTextView beginEdit];
            break;
            
        case CCLiveBottomShareItem:  // 分享
            [self showShareView];
            break;
        
        case CCLiveBottomSendRedPacketItem: // 主播发红包
            self.sendPacketView.anchorEcoinCount = self.anchorEcoinCount;
            [self.sendPacketView show];
            break;
            
        case CCLivebottomFaceItem:
        {
            self.isBeautyOn = !self.isBeautyOn;
            [self.liveEncode enableFaceBeauty:self.isBeautyOn];
        }
            break;
        case CCLiveBottomPlayerItem:
        {
            if (self.isPlayMp3 == NO) {
                 [[EVAudioPlayer sharePlayer] play];
            }else {
                [[EVAudioPlayer sharePlayer] stop];
            }
            
            self.isPlayMp3 = !self.isPlayMp3;
            
           
        }
            break;
    }
}



- (void)prepareForeView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    EVLivePrePareView *prepareView = [[EVLivePrePareView alloc] init];
    [self.view addSubview:prepareView];
    prepareView.frame = self.view.bounds;

    prepareView.delegate = self;
    self.prepareView = prepareView;
    
    
    NSString *title = self.recoderInfo.title;
    // 设置默认标题
    if ( title != nil && self.recoderInfo.isDefaultTitle == NO )
    {
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
    if ( fromServer )
    {
        [title appendString:@"."];
    }
    [self forceToStopWithTitle:title];
}

- (void)forceToStopWithTitle:(NSString *)title
{
    __weak typeof(self) wself = self;
    // TODO: Delete
    self.recoderInfo.userRequestStop = YES;
    [self.liveEncode shutDwonStream];
    [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"living_end") message:title comfirmTitle:kOK WithComfirm:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [wself.contacter boardCastEvent:EVLiveRequestLiveStop withParams:nil];
    }];
    
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
            [self.prepareView startCaptureImage];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - CCLiveEditTitleViewDelegate
- (void)liveEditTitleViewHidden
{
    self.bottomBtnContainerView.hidden = NO;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    if ( image == nil )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"checking_image_save_photo")];
        return;
    }
    
    image = [[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.5)];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self cropperImage:image originImage:NO];
    }];
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
    }];
    self.prepareView.captureSuccess = YES;
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CCAudienceViewControllerProtocol

- (void)audienceDidClicked:(CCAudienceInfoViewButtonType)btn
{
    
    switch ( btn )
    {
        case CCAudienceInfoCancel:
        {
            __weak typeof(self) weakself = self;
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"is_stop_living") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
                weakself.recoderInfo.userRequestStop = YES;
                [weakself requestLiveStop];
                [[EVAudioPlayer sharePlayer]stop];
            } cancel:nil];
        }
            break;
        
        case CCAudienceInfoCamera:
            [self toggleCameraWithType:CCToggleCameraPrepare];
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
       
        self.bottomBtnContainerView.hidden = NO;
        self.recoderInfo.startCountTime = YES;
        [self boardCastLiveInfo];
    }
}

#pragma mark - liveShare
- (void)liveShareWithType:(CCLiveShareType)type
{
    CCLiveShareButtonType shareType = 0;
    switch (type)
    {
        case CCLiveShareSina:
            shareType = CCLiveShareSinaWeiBoButton;
            break;
        case CCLiveShareQQ:
            shareType = CCLiveShareQQButton;
            break;
        case CCLiveShareWeiXin:
            shareType = CCLiveShareWeiXinButton;
            break;
        case CCLiveShareFriendCircle:
            shareType = CCLiveShareFriendCircleButton;
            break;
        default:
            break;
    }
    [self liveShareViewDidClickButton:shareType];
}


#pragma mark - CCLivePrePareViewDelegate
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
            [self toggleCameraWithType:CCToggleCameraLiving];
            itemView.cameraButton.selected = !itemView.cameraButton.selected;
            itemView.flashButton.highlighted = itemView.cameraButton.selected;
            itemView.flashButton.userInteractionEnabled = !itemView.cameraButton.selected;
            
            CCLog(@"user interaction enable = %d", itemView.flashButton.userInteractionEnabled);
            break;
            
        case EVLivePrePareViewButtonCancel:
            [self finishLivePage];
            
            break;
        case EVLivePrePareViewButtonLiveStart:
        {
            CCLog(@"开始直播按钮");

            [self startLiving];
        }
            break;
        case EVLivePrePareViewButtonCover:
            [self startToPickCover];
            break;
        
            
        case EVLivePrePareViewButtonBeauty:
        {
            self.isBeautyOn = !self.isBeautyOn;
            ((EVLiveBottomItemView *)self.bottomBtnContainerView).faceButton.selected = self.isBeautyOn;
            [self.liveEncode enableFaceBeauty:self.isBeautyOn];
        }
            break;
            
        case EVLivePrePareViewButtonPermission:
        {
            [self gotoAthorityPage];
        }
            break;
        case EVLivePrePareViewButtonCategory:
        {
            EVCategoryViewController *categotyVC = [[EVCategoryViewController alloc]init];
            categotyVC.nowItem = self.recoderInfo.topic;
            categotyVC.delegate = self;
            [self.navigationController pushViewController:categotyVC animated:NO];
            
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
    if ( liveTitle && liveTitle.length ) {
        self.videoInfoView.item.title = [NSString stringWithFormat:@"%@%@",[EVLoginInfo localObject].nickname,liveTitle];
        self.recoderInfo.title = liveTitle;
    }else {
        
        self.videoInfoView.item.title = [NSString stringWithFormat:@"%@%@",[EVLoginInfo localObject].nickname,kE_GlobalZH(@"living_enter_watch")];
    }
    
    
    WEAK(self)
    NSMutableDictionary *params = [self.recoderInfo liveStartParams];
    
    [self.engine GETLivePreStartParams:params Start:^{
        [CCProgressHUD showSuccess:@"请等待" toView:self.view];
    } fail:^(NSError *error) {
        NSString *customError = error.userInfo[kCustomErrorKey];
        if ( [customError isEqualToString:@"E_USER_PHONE_NOT_EXISTS"] )
        {
            [weakself liveNeedToBindPhone];
        }
        else if ( customError )
        {
            [weakself.prepareView setLoadingInfo:customError canStart:NO];
        }
        else
        {
            [weakself.prepareView setLoadingInfo:kDefaultErrorStateTitle canStart:NO];
        }
    } success:^(NSDictionary *info) {
        self.topicVid = info[@"vid"];
        [CCProgressHUD hideHUDForView:self.view];
        [self upLoadThumbWithVid:self.topicVid];
        [self prepareToLiveWithInfo:info];
        self.recoderInfo.startCountTime = YES;
        [self startCountTime];
        [self.liveEncode startEncoding];
       
        self.bottomBtnContainerView.hidden = NO;
        self.contentView.hidden = NO;
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
        [self initialLiveViewDataView];
    } sessionExpire:^{
        CCRelogin(self);
    }];

}


- (void)upLoadThumbWithVid:(NSString *)vid
{
    if ( vid == nil || self.recoderInfo.thumbImage == nil )
    {
        return;
    }
        NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
        NSString *fileName = [NSString stringWithFormat:@"file"];
        postParams[kFile] = fileName;
   [self.engine upLoadVideoThumbWithiImage:self.recoderInfo.thumbImage vid:vid fileparams:postParams sessionExpire:^{
       
   }];
}
- (void)gotoAthorityPage
{
    EVLimitViewController *limitVC = self.limitVC;
    if ( limitVC == nil )
    {
        limitVC = [[EVLimitViewController alloc] init];
        limitVC.delegate = self;
        self.limitVC = limitVC;
    }
    else
    {
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
    CCLiveShareButtonType type = 0;
    switch ( self.prepareView.currShareTye )
    {
        case EVLivePrePareViewShareSina:
        {
            type = CCLiveShareSinaWeiBoButton;
        }
            break;
            
        case EVLivePrePareViewShareWeixin:
            type = CCLiveShareWeiXinButton;
            break;
            
        case EVLivePrePareViewShareFriendCircle:
            type = CCLiveShareFriendCircleButton;
            break;
            
        case EVLivePrePareViewShareQQ:
            type = CCLiveShareQQButton;
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


#pragma mark - CCLiveAnchorSendRedPacketViewDelegate
- (void)liveAnchorSendPacketViewView:(EVLiveAnchorSendRedPacketView *)sendPacketView packets:(NSInteger)packets ecoins:(NSInteger)ecoins greetings:(NSString *)greetings
{
    CCLog(@"%zd --- %zd --- %@", packets, ecoins, greetings);
    [self.engine GETLiveSendRedPacketWithVid:self.vid ecoin:ecoins count:packets greeting:greetings start:^{
        
    } fail:^(NSError *error) {
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"send_red_fail")];
        [CCProgressHUD showError:errorStr];
    } success:^{
        self.anchorEcoinCount = self.anchorEcoinCount - ecoins;
        CCLog(@"send red packet success");
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
        CCLog(@"!!!!!!!!appdev remove fail...");
    } success:^{
        [wself dismissViewControllerAnimated:NO completion:nil];
        CCLog(@"---------------appdev remove success...");
    } sessionExpire:^{
        [wself dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.contacter boardCastEvent:CCLiveReadingDestroy withParams:nil];
}


#pragma mark - liveOperatiion
- (void)toggleCameraWithType:(CCToggleCameraType)type
{
    __weak typeof(self) wself = self;
    if ( self.recoderInfo.totogling )
    {
        return;
    }
    self.recoderInfo.totogling = YES;
    [_liveEncode switchCamera:!self.recoderInfo.fontCamera complete:^(BOOL success, NSError *error) {
        if( success )
        {
            [wself recoderInfo].fontCamera = !wself.recoderInfo.fontCamera;
            if ( type == CCToggleCameraPrepare )
            {
                [wself.videoInfoView buttonDidClicked:wself.videoInfoView.cameraButton];
            }
        }
        BOOL font = [wself recoderInfo].fontCamera;
        wself.recoderInfo.totogling = NO;
        [wself.contacter boardCastEvent:CCLiveInfoUpdate
                             withParams:@{
                                          CCLiveInfoKey : @{AUDIENCE_FONT_CARERA : @(font)}
                                          }];
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
        BOOL success = [flashLight lockForConfiguration:NULL];
        if ( success )
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

#pragma mark - cycleMessage
- (void)liveViewControllerDismissComplete:(void(^)())complete
{
    CCLog(@"####-----%d,----%s-----%@--%@-####",__LINE__,__FUNCTION__,self.navigationController,self.navigationController.viewControllers);
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
    self.bottomBtnContainerView.hidden = YES;
    [self.sendPacketView dismiss];
    [self.contacter boardCastEvent:CCLiveStop withParams:nil];
    __weak typeof(self) wself = self;
    [self.liveEndView show:^{
        [wself hiddenContentSubviews];
    }];
    [self.engine GETAppdevstopliveWithVid:self.recoderInfo.vid start:^{
    } fail:^(NSError *error) {
        [wself showLiveEndViewWithInfo:nil];
    } success:^(NSDictionary *videoInfo) {
        [wself showLiveEndViewWithInfo:videoInfo];
    } sessionExpire:^{
        [wself showLiveEndViewWithInfo:nil];
    }];
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
    EVLiveEndViewData *data = [[EVLiveEndViewData alloc] init];
    if ( videoInfo )
    {
        self.recoderInfo.play_url = videoInfo[kPlay_url];
        data.commentCount = [videoInfo[kComment_count] integerValue];
        data.likeCount = self.like_count;
        data.audienceCount = self.watch_count;
        data.signature = self.recoderInfo.title;
        data.playBackURLString = self.recoderInfo.play_url;
    }
    else
    {
        data.commentCount = self.recoderInfo.liveUserInfo.video_info.comment_count;
        data.likeCount = self.recoderInfo.liveUserInfo.video_info.like_count;
        data.audienceCount = self.recoderInfo.liveUserInfo.video_info.watch_count;
        data.signature = self.recoderInfo.title;
    }
    data.riceCount = self.riceAmountView.lasttimeRiceCount;
    self.recoderInfo.noCanSaveVideo = data.noCanKeepVideo;
    self.liveEndView.liveViewData = data;
}

// 对焦
- (void)focusWithGesture:(UITapGestureRecognizer *)tap
{
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

#pragma CCEventContoller
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

@end
