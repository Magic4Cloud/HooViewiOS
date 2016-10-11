//
//  EVWatchViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVWatchViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVAlertManager.h"
#import "EVWatchVideoInfo.h"
#import "EVNetWorkStateManger.h"
#import "EVShareManager.h"
#import "EVEventController.h"
#import "EVVideoPlayer.h"
#import "EVConnectingErrorView.h"
#import "AppDelegate.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"
#import "EVRecorderEndView.h"
#import "EVWatchLiveEndView.h"
#import "UIView+Extension.h"
#import "EVLoginInfo.h"
#import "EVYunBiViewController.h"
#import "EVUserAsset.h"
#import "EVManagerUserView.h"
#import "EVAudience.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVVideoFunctions.h"
#import "EVFantuanContributionListVC.h"
#import "EVMessageManager.h"
#import "EVSDKLiveEngineParams.h"
#import "EVRecordInfoView.h"
#import "EVLiveEvents.h"

#define  kDefaultConnectingTitle  kE_GlobalZH(@"living_ready_start")
static NSString *const kHasNotifyNotWifiKey    = @"hasNotifyNotWifi";

#define kEventStart @"kEventStart"

@interface EVWatchViewController () <CCControllerContacterProtocol, EVVideoPlayerDelegate, UIScrollViewDelegate, CCRecorderEndViewDelegate, CCWatchEndViewDelegate, CCVideoViewProtocol, CCWatchBottomItemViewDelegate, CCReportResonViewDelegate, CCRecordControlViewDelegate,TouchLoveCountDelegate,CCRecordInfoViewDelegate>
{
    // 录播使用的计时器
    dispatch_source_t _recordPlayTimer;
    dispatch_queue_t  _recordPlayTimerQueue;
}

/**
 *  UI视图
 */
@property (nonatomic, strong) EVBaseToolManager            *engine;            /**< 网络请求 */
@property (nonatomic, strong) EVControllerItem      *controllerItem;    /**< 观察对象 */
@property (nonatomic, strong) EVEventController     *eventController;
@property (nonatomic, strong) EVVideoPlayer         *evPlayer;          /**< 播放器 */
@property (nonatomic, weak  ) EVRecorderEndView     *recorderEndView;   /**< 录播结束页 */
@property (nonatomic, weak  ) EVWatchLiveEndView    *endWatchView;      /**< 直播观看结束页 */
@property (nonatomic, weak  ) EVConnectingErrorView *connectErrorView;  /**< 连接错误视图 */
/** 用来把父类的bottomBtnContainerView强转成CCWatchBottomItemView类型，方便使用 */
@property (nonatomic, weak  ) EVWatchBottomItemView *bottomItemViewTemp;
/** 把这个view放在这里是用来判断当这个view是非隐藏状态的时候，touch事件不触发观看端的点赞 */
@property (nonatomic, weak  ) EVRecordInfoView      *recordView;


@property (nonatomic, strong) UITapGestureRecognizer *loveTap;  /**< 点赞 */
@property (nonatomic, assign) NSInteger deep; /**< 当前播放页被压入的深度，即初始化播放器的个数（如果只初始化一个则为0） */

@property (nonatomic, assign) BOOL playerHasShutdown;
@property (nonatomic, assign) BOOL renderViewPrepared;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, assign) BOOL playerStateCompleted;    /**< 播放器是否加载完成 */
@property (nonatomic, assign) BOOL firstLoadVideoSuccess;   /**< 第一次加载视频成功 */
@property (nonatomic, assign) BOOL isWatchStartSuccess;     /**< watch start请求是否进入success回调，控制是否可以跳结束页 */
@property (nonatomic, assign) BOOL isEndLiving;
@property (nonatomic, assign) BOOL isLivingStatus;


@end

@implementation EVWatchViewController

#pragma mark - init method
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)prepare
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isEndLiving = NO;
    
    _running = YES;
    
    _playerStateCompleted = NO;
    
    [self getMyAssets];
    self.vid = self.watchVideoInfo.vid;
}


#pragma mark - life cycle
- (void)dealloc {
    _running = NO;
    [self.evPlayer shutdown];
    _evPlayer.delegate       = nil;
    _controllerItem.delegate = nil;
    [[EVManagerUserView shareSheet]hideActionWindow];
    [self streamPlayerShutDown];
    [_engine cancelAllOperation];
    [[EVMessageManager shareManager]close];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [CCNotificationCenter removeObserver:self];
    [CCNotificationCenter postNotificationName:CCWatchViewControllerWillDeLoad object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.renderViewPrepared = YES;
    [self popEvent:kEventStart];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self setUpNotification];
    [self configView];
    [self alertNotWifi];
    [self addWatchEnterAnimation];
    self.loveView.delegete = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - notification
- (void)setUpNotification
{
    [CCNotificationCenter postNotificationName:CCWatchViewControllerWillLoad object:nil];
    
    // fix by 高沛荣 去掉观看界面监听网络状态的通知
    [CCNotificationCenter addObserver:self selector:@selector(loginNeedToPause) name:CCLoginNeedToPauseWatchViewController object:nil];
    
    [CCNotificationCenter addObserver:self selector:@selector(longinViewDidDismiss) name:CCLoginPageDidDissmissNotification object:nil];
    
    [CCNotificationCenter addObserver:self selector:@selector(forceToClose) name:CCNeedToForceCloseLivePageOrWatchPage object:nil];
    
    [CCNotificationCenter addObserver:self selector:@selector(watchViewControllerWillLoad) name:CCWatchViewControllerWillLoad object:nil];
    
    [CCNotificationCenter addObserver:self selector:@selector(watchViewControllerWillDeLoad) name:CCWatchViewControllerWillDeLoad object:nil];
    // 监听网络变化
    [CCNotificationCenter addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
}

- (void)loginNeedToPause {
    [self.evPlayer pause];
}

- (void)longinViewDidDismiss {
    [self.evPlayer play];
}

- (void)watchViewControllerWillLoad {
    [self.evPlayer pause];
    self.deep += 1;
}

- (void)watchViewControllerWillDeLoad {
    self.deep -= 1;
    if (self.deep < 1){
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.evPlayer play];
        });
    }
}

// 监听网络变化通知
- (void)applicationNetworkStatusChanged:(NSNotification *)notification {
    NSNumber *status = [notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    if ( [status integerValue] == AFNetworkReachabilityStatusReachableViaWWAN ) {
        [self.evPlayer pause];
        
        [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"network_warn") message:kE_GlobalZH(@"switch_mobile_network") cancelButtonTitle:kCancel comfirmTitle:kE_GlobalZH(@"i_konw") WithComfirm:^{
            [self.evPlayer play];
        } cancel:^{
        }];
    }
}


#pragma mark - event
- (void)pushEvent:(NSString *)eventString
{
    __weak typeof(self) wself = self;
    [self performBlockOnMainThread:^{
        EVEvent *event = [[EVEvent alloc] init];
        event.operation = ^{
            if ( wself == nil )
            {
                return ;
            }
        };
        [wself.eventController pushEvent:eventString withOperation:event];
    }];
}

- (void)popEvent:(NSString *)eventString
{
    __weak typeof(self) wself = self;
    [self performBlockOnMainThread:^{
        [wself.eventController popEvent:eventString];
    }];
    
}

- (void)tapLove
{
    if ( self.contentView.frame.origin.y < 0 )
    {
        [self.chatTextView.textView resignFirstResponder];
        self.chatTextView.heightContraint.constant = CCAudienceChatTextViewHeight;
        self.chatTextView.bottomView.hidden = NO;
        self.bottomBtnContainerView.hidden = NO;
    }
    else
    {
        [[EVMessageManager shareManager] addLikeCountNumber:1 inTopic:self.vid result:^(BOOL isSuccess, EVMessageErrorCode errorCode) {
            
        }];
        [self.loveView registAnimation];
    }
}

- (void)touchLoveCount:(NSInteger)count
{
   
    
}
- (void)updateVideoInfo:(NSDictionary *)videoInfo
{
    
}

// 给主播发私信
- (void)sendMessageToAnchor
{
    [self dismissPageComplete:^{
        [((AppDelegate *)[UIApplication sharedApplication].delegate).homeVC startChatWithName:self.watchVideoInfo.name];
    }];
}

/**< 播放器非正常结束，重连 */
- (void)resumePlayer
{
    // 销毁当前的播放器
    [self.evPlayer shutdown];
    self.evPlayer.delegate = nil;
    [self.evPlayer.presentview removeFromSuperview];
    [self.evPlayer shutdown];
    
    // 初始化新的播放器
    // 直播加速
    [self showLiveMessage:kE_GlobalZH(@"life_connect")];
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakself) strongSelf = weakself;
        [strongSelf configPlayer];
        [self.evPlayer.presentview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    });
}

/**< 强制关闭 */
- (void)forceToClose {
    [self streamPlayerShutDown];
    [self dismissPageComplete:nil];
}

// 更新资产信息
- (void)updateAssetWithInfo:(NSDictionary *)Info
{
    NSInteger barley = [Info[kBarley] integerValue];
    NSInteger ecoin = [Info[kEcoin] integerValue];
    self.magicEmojiView.barley = barley;
    self.magicEmojiView.ecoin = ecoin;
    
    // 存放到本地
    EVLoginInfo *info = [EVLoginInfo localObject];
    info.barley = barley;
    info.ecoin = ecoin;
    [info synchronized];
}

- (void)destroyStreamerPlayer
{
    if(_playerStateCompleted == NO
       || !_running
       || !self.isWatchStartSuccess )
        return;
    
    _running = NO;
    [self streamPlayerShutDown];
    [self.slidScrollView setContentOffset:CGPointZero];
    self.slidScrollView.scrollEnabled = NO;
    [self showWatchEndView];
}

- (void)streamPlayerShutDown {
    if (_playerHasShutdown) {
        return;
    }
    _playerHasShutdown = YES;
    [self stopRecordPlayTimer];
    [_evPlayer shutdown];
    _evPlayer = nil;
}

- (void)dismissPageComplete:(void(^)())complete
{
    [self streamPlayerShutDown];
    BOOL animate = NO;
    if ( IOS8_OR_LATER || !complete  )
    {
        animate = YES;
    }
    
    if ( self.navigationController.childViewControllers.count == 1 )
    {
        [self.navigationController dismissViewControllerAnimated:animate completion:complete];
    }
    else if ( self.navigationController.childViewControllers.count > 1 )
    {
        [self.navigationController popViewControllerAnimated:animate];
        if ( complete )
        {
            complete();
        }
    }
    else
    {
#ifdef CCDEBUG
        assert(0);
#endif
    }
    
}

#pragma mark - network
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

- (void)riceAmoutViewDidSelect
{
    EVFantuanContributionListVC *fantuanVC = [[EVFantuanContributionListVC alloc] init];
    fantuanVC.name = self.videoInfoView.item.name;
    fantuanVC.isAnchor = NO;
    [self.navigationController pushViewController:fantuanVC animated:YES];
}

// 观看直播过程中关注主播
- (void)livingWatchFollowAnchor
{
    if (self.watchVideoInfo.living)
    {
        [self.engine GETLivingFollowAnchorWithVid:self.watchVideoInfo.vid name:self.videoInfoView.item.name follow:!self.videoInfoView.item.followed];
    }
    else
    {
        [self.engine GETFollowUserWithName:self.watchVideoInfo.name followType:!self.videoInfoView.item.followed start:nil fail:nil success:nil essionExpire:nil];
    }
    self.videoInfoView.item.followed = !self.videoInfoView.item.followed;
    self.watchVideoInfo.followed = !self.watchVideoInfo.followed;
    
    if (self.videoInfoView.item.followed == 0 || self.watchVideoInfo.followed == 0)
    {
        self.AudienceViewConstraint.constant = 143;
    }
    else
    {
        self.AudienceViewConstraint.constant = 100;
    }
    [self.videoInfoView close];
}

// 发送表情
- (void)sendMagicEmojiWithEmoji:(EVStartGoodModel *)magicEmoji num:(NSInteger)numOfEmoji
{
    self.isSelfBrush = YES;
    if ( magicEmoji.anitype != CCPresentAniTypeRedPacket )
    {
        [self.presentView stopRepeatAnimation];
    }
    if ( magicEmoji.anitype == CCPresentAniTypeZip )
    {
        NSString *aniDir = [self presentAniDirectoryWithPath:PRESENTFILEPATH(magicEmoji.ani)];
    }
    
    __weak typeof(self) wself = self;
    NSString *vid = (self.watchVideoInfo.vid == nil || [self.watchVideoInfo.vid isEqualToString:@""]) ?  self.watchVideoInfo.name : self.watchVideoInfo.vid;
    [self.engine GETBuyPresentWithGoodsID:[NSString stringWithFormat:@"%ld", (long)magicEmoji.ID] number:numOfEmoji vid:vid name:self.watchVideoInfo.name start:^{
        
    } fail:^(NSError *error) {
        // 就目前的网络底层，失败以后不能做重发操作，因为用户可能会继续发礼物，两个请求可能相同，\

        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_send_gift")];
        CCLog(@"errorStr = %@", errorStr);
        [CCProgressHUD showError:errorStr toView:wself.view];
    } success:^(NSDictionary *info) {
//        [wself updateAssetWithInfo:info];
    } sessionExpire:^{
        CCRelogin(wself);
    }];
}

/** 切换关注状态 */
- (void)togoleFocus
{
    FollowType followType = self.watchVideoInfo.followed ? unfollow :follow;
    __weak typeof(self) wself = self;
    EVWatchLiveEndData *data = self.endWatchView.watchEndData;
    [self.engine GETFollowUserWithName:self.watchVideoInfo.name followType:followType start:^{
        //        [CCProgressHUD showMessage:k_REQUST_LOADING toView:wself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:k_REQUST_FAIL toView:wself.view];
    } success:^{
        [CCProgressHUD hideHUDForView:wself.view];
        wself.watchVideoInfo.followed = followType;
        data.followed = followType;
        [wself.endWatchView setWatchEndData:data];
    } essionExpire:^{
        [CCProgressHUD hideHUDForView:wself.view];
        [wself sessionExpireAndRelogin];
    }];
}

// 关注/取消关注
- (void)focusAnchorWithState:(BOOL)focused
{
    [self.engine GETFollowUserWithName:self.watchVideoInfo.name followType:focused start:^{
        
    } fail:^(NSError *error) {
        
    } success:^{
        
    } essionExpire:^{
        
    }];
}

- (void)loadWatchStartData
{
    
    WEAK(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ( self.vid )
    {
        param[kVid] = self.vid;
    }
    
    if ( self.watchVideoInfo.password )
    {
        param[kPassword] = self.watchVideoInfo.password;
    }
    
    // 获取视频信息
    [self.engine GETUserstartwatchvideoWithParams:param Start:^{
        
    } fail:^(NSError *error) {
        CCLog(@"error = %@",error);
        [weakself failErrorLivingDataError:error];
    } success:^(NSDictionary *videoInfo) {
        
        [weakself successLivingDataVideoInfo:videoInfo];
        
    } sessionExpire:^{
        [weakself sessionExpireAndRelogin];
    }];
}

- (void)reportWithReason:(UIButton *)reason reportTitle:(NSString *)reportTitle
{
    if ([reportTitle isEqualToString:kE_GlobalZH(@"report_user")]) {
        if ( self.reportedUser )
        {
            [CCProgressHUD showSuccess:kE_GlobalZH(@"process_report") toView:self.view];
            [self.engine GETUserInformWithName:[self.reportedUser.name mutableCopy]
                                description:[reason.currentTitle mutableCopy]
                                      start:nil
                                    success:nil
                                       fail:nil
                                     expire:nil];
            self.reportedUser = nil;
            return;
        }
        
        
    }else if([reportTitle isEqualToString:kE_GlobalZH(@"report_video")]){
        [CCProgressHUD showSuccess:kE_GlobalZH(@"process_report_video") toView:self.view];
        [self.engine GETUserInformWithName:[self.reportedUser.name mutableCopy]
                               description:[reason.currentTitle mutableCopy]
                                     start:nil
                                   success:nil
                                      fail:nil
                                    expire:nil];
    }else{
        
        if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"e_gag")]) {
            if ([self.reportedUser.name isEqualToString:self.watchVideoInfo.name]) {
                [CCProgressHUD showError:kE_GlobalZH(@"not_limit")];
            }else {
                
                [self  shutupAudienceWithAudienceName:self.reportedUser.name shutupState:1];
            }
            
        }else if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"complete_gag")]) {
            
            
        }else if ([reason.currentTitle isEqualToString:kE_GlobalZH(@"e_report")]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reportUserTitle:kE_GlobalZH(@"report_user")];
            });
        }
    }
}

#pragma mark - CCControllerContacterProtocol
- (void)setUpContacterEvents
{
    [self.controllerItem.events addObjectsFromArray:@[CCLiveReconnectedStreamEnd, SCROLL_VIEW_ADJUST, CCPLAYER_CONTROL_EVENT, CCPLAYER_SHOULD_SEEK_TIME]];

    [self.contacter addListener:self.controllerItem];
}

- (void)receiveEvents:(NSString *)event withParams:(NSDictionary *)params
{
    if ( [event isEqualToString:CCLiveReconnectedStreamEnd] )
    {
        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"living_end") comfirmTitle:kOK WithComfirm:^{
             [self destroyStreamerPlayer];
        }];
    }
    else if ( [event isEqualToString:SCROLL_VIEW_ADJUST] )
    {
        if ( params[SCROLL_VIEW_SCROLL_ENABLE]  )
        {
            self.slidScrollView.scrollEnabled = [params[SCROLL_VIEW_SCROLL_ENABLE] boolValue];
        }
        else if ( params[LOVE_VIEW_TAB_ENABLE] )
        {
            
        }
    }
    else if ( [event isEqualToString:CCPLAYER_CONTROL_EVENT] )
    {
        // 录播暂停和继续
        if ( [params[CCPLAYER_CONTROL_EVENT_PAUSE] boolValue] )
        {
            
            [_evPlayer pause];
            
        }
        else
        {
           
            [_evPlayer againPlay];
            
        }
    }
    else if ( [event isEqualToString:CCPLAYER_SHOULD_SEEK_TIME] )
    {
        if ( params[CCPLAYER_SHOULD_SEEK_TIME] )
        {
            _evPlayer.currentPlaybackTime = [params[CCPLAYER_SHOULD_SEEK_TIME] doubleValue];
        }
    }
}

// @主播
- (void)atAnchor
{
    self.sendComment = YES;
    EVComment *comment = [[EVComment alloc] init];
    comment.name = self.videoInfoView.item.name;
    comment.reply_name = self.watchVideoInfo.name;
    comment.reply_nickname = self.watchVideoInfo.nickname;
    NSString *replyNickNameString = [NSString stringWithFormat:@"@%@ ",self.videoInfoView.item.userModel.nickname];
    comment.replyNickNameString = replyNickNameString;
    [self.chatTextView setReplyString:replyNickNameString];
    [self.chatTextView beginEdit];
}


// 更新云币数
- (void)updateEcoinAfterGrabRedEnvelop:(NSInteger)ecoin
{
    EVLoginInfo *info = [EVLoginInfo localObject];
    ecoin = info.ecoin + ecoin;
    info.ecoin = ecoin;
    self.magicEmojiView.ecoin = ecoin;
    [info synchronized];
}

- (void)watchBottomViewBtnClick:(UIButton *)button
{
    switch ( button.tag )
    {
        case CCWatchBottomItemChat:
            if ( !self.watchVideoInfo.living )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"playback_not_send_comment") toView:self.view];
            }
            else
            {
                self.sendComment = YES;
                [self.chatTextView beginEdit];
            }
            break;
        case CCWatchBottomItemTimeLine:
        {
            [self enableScrollView:NO];
            self.commentTableView.hidden = YES;
            __weak typeof(self) wself = self;
            [self.bottomBtnContainerView scaleBoundceAnimationHiddenComplete:^{
                [wself.recordView showComplete:nil];
            }];
            
            break;
        }
        case CCWatchBottomItemShare:
        {
            self.recordControlView.hidden = YES;
            [self showShareView];
            break;
        }
        case CCWatchBottomItemGif:
        {
            self.bottomBtnContainerView.hidden = YES;
            self.recordControlView.hidden = YES;
            if ( [[EVStartResourceTool shareInstance] prensentEnable] || [[EVStartResourceTool shareInstance] emojiPresentEnable] )
            {
                [self.magicEmojiView show];
                self.loveTap.enabled = NO;
                self.commentTableView.hidden = YES;
            }
            else
            {    // 如果 表情 和 礼物都没有直接提示用户
                 self.bottomBtnContainerView.hidden = NO;
                 self.recordControlView.hidden = NO;
                self.commentTableView.hidden = NO;
                [CCProgressHUD showError:kE_GlobalZH(@"gift_not_use") toView:self.view];
            }
            break;
        }
        case CCWatchBottomItemLike:
        {
            [self tapLove];
        }
          
            break;
        
    }
}


#pragma mark - CCRecordInfoViewDelegate
- (void)recordInfoViewDidAutoHidden:(EVRecordInfoView *)recordInfoView
{
    [self.contacter boardCastEvent:SCROLL_VIEW_ADJUST withParams:@{LOVE_VIEW_TAB_ENABLE: @(YES),
                                                                   SCROLL_VIEW_SCROLL_ENABLE: @(YES)}];
    
    self.commentTableView.hidden = NO;
    [self.bottomBtnContainerView scaleBoundceAnimationShowComplete:nil];
}

- (void)recordInfoView:(EVRecordInfoView *)recordInfoView
        didClickButton:(UIButton *)btn
{
    switch ( btn.tag )
    {
        case RECORD_BTN_PALY_OR_PAUSE:
        {
            BOOL pause = recordInfoView.pause;
            [self.contacter boardCastEvent:CCPLAYER_CONTROL_EVENT withParams:@{CCPLAYER_CONTROL_EVENT_PAUSE : @(!pause)}];
            recordInfoView.pause = !pause;
        }
            break;
        default:
            break;
    }
}

- (void)recordInfoViewDidBeginDrag:(EVRecordInfoView *)recordInfoView
{
    recordInfoView.pause = YES;
    [self.contacter boardCastEvent:CCPLAYER_CONTROL_EVENT withParams:@{CCPLAYER_CONTROL_EVENT_PAUSE : @YES}];
}

- (void)recordInfoViewDidDragToNewProgress:(double)progress
{
    [self.contacter boardCastEvent:CCPLAYER_SHOULD_SEEK_TIME withParams:@{CCPLAYER_SHOULD_SEEK_TIME: @(progress)}];
    
    [self.contacter boardCastEvent:CCPLAYER_CONTROL_EVENT withParams:@{CCPLAYER_CONTROL_EVENT_PAUSE : @NO}];
    self.recordView.pause = NO;
    self.recordControlView.pause = NO;

}

#pragma mark - CCAudienceViewControllerProtocol
- (void)audienceDidClicked:(CCAudienceInfoViewButtonType)btn
{
    [super audienceDidClicked:btn];
    //    [self.videoInfoView closeNoAnimation];
    switch ( btn )
    {
        case CCAudienceInfoCancel:
//            self.counting = NO;
            [self.evPlayer shutdown];
            self.evPlayer = nil;
            [self forceToClose];
            
            break;
        case CCAudienceInfoSessionExpire:
//            self.counting = NO;
            [self sessionExpireAndRelogin];
            break;
        case CCAudienceInfoReport:
        {
            [self reportUserTitle:kE_GlobalZH(@"report_video")];
            break;
        }
        default:
            break;
    }
}

- (void)enableScrollView:(BOOL)enable
{
    [self.contacter boardCastEvent:SCROLL_VIEW_ADJUST withParams:@{LOVE_VIEW_TAB_ENABLE: @(enable),
                                                                   SCROLL_VIEW_SCROLL_ENABLE: @(enable)}];
}

#pragma mark - 聊天服务器的消息
// 当session过期，需要强制退出当前观看页
- (void)foreceToPopCurrentWatchPage:(void (^)())complete
{
    [self dismissPageComplete:complete];
}


- (void)setLivingStatus:(BOOL)livingStatus
{
    if (!livingStatus) {
        self.watchVideoInfo.living = NO;
        NSLog(@"congzhebuxingma ----");
        [self destroyStreamerPlayer];
    }
}

#pragma mark - CCMagicEmojiViewDelegate

// 云币不足
- (void)yibiNotEnough
{
    [self gotoRechargeYiBi];
}

- (void)magicEmojiSend
{
    [self showWatchBottomLeftBtn];
}

- (void)magicEmojiViewHidden
{
    [self showBottomContainerView];
    self.loveTap.enabled = YES;
}


// 连刷时发送个数改变
- (void)changeSendAmountOfPresentsWithNumber:(NSInteger)number
                                     present:(EVStartGoodModel *)present
{
    if ( present.anitype == CCPresentAniTypeZip )
    {
//        return;
    }
    [self.presentView performRepeatAnimateWithNumber:number present:present];
}

// 充值
- (void)rechargeYibi
{
    [self gotoRechargeYiBi];
}

// 去充值界面
- (void)gotoRechargeYiBi
{
    EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
    EVUserAsset *asset = [[EVUserAsset alloc] init];
    asset.ecoin = self.magicEmojiView.ecoin;
    yibiVC.asset = asset;
    if (self.navigationController)
    {
        [self.navigationController pushViewController:yibiVC animated:YES];
    }
}

#pragma mark - CCWatchEndViewDelegate
- (void)watchEndView:(EVWatchLiveEndView *)watch
    didClickedButton:(CCWatchEndViewButtonType)type
{
    switch ( type )
    {
        case CCWatchEndViewFocusButton:
            [self togoleFocus];
            break;
            
        case CCWatchEndViewCancelButton:
            [self audienceDidClicked:CCAudienceInfoCancel];
            break;
            
        case CCWatchEndViewHomeButton:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case CCWatchEndViewSendPrivateLetter:
            [self logoutVideoAndChatWithName:self.watchVideoInfo.name];
            break;
        default:
            break;
    }
}

#pragma mark - CCLiveShareViewDelegate
- (void)liveShareViewDidClickButton:(CCLiveShareButtonType)type
{
    if ( self.watchVideoInfo.share_url == nil )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"living_url_ready") toView:self.view];
        return;
    }
    
    NSString *nickName = self.watchVideoInfo.nickname;
    NSString *videoTitle = self.watchVideoInfo.title;
    NSString *shareUrlString = self.watchVideoInfo.share_url;

    BOOL isLive = self.watchVideoInfo.living;
    
    ShareType shareType;
    if (isLive) {
        // 观看直播
        shareType = ShareTypeLiveWatch;
    } else {
        // 观看录播
        shareType = ShareTypeVideoWatch;
    }
    [UIImage gp_imageWithURlString:self.watchVideoInfo.share_thumb_url comolete:^(UIImage *image) {
        UIImage *shareImg = _watchVideoInfo.thumbImage ? : image;
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:nickName descriptionReplaceName:videoTitle descriptionReplaceId:nil URLString:shareUrlString image:shareImg];
    }];
}

- (void)showWatchBottomLeftBtn
{
    self.commentTableView.hidden = NO;
    self.bottomBtnContainerView.hidden = YES;
    [self.bottomItemViewTemp hiddenLeftBtn:YES];
}

- (void)showBottomContainerView
{
    self.recordControlView.hidden = NO;
    self.commentTableView.hidden = NO;
    self.bottomBtnContainerView.hidden = NO;
    [self.bottomItemViewTemp hiddenLeftBtn:NO];
}


- (UIImage *)getAudioOnlyBGImageComplete:(void(^)(UIImage *image))complete
{
    __weak typeof(self) wself = self;
    [UIImage gp_downloadWithURLString:self.watchVideoInfo.bgpic complete:^(NSData *data) {
        if ( data && complete )
        {
            UIImage *img = [[UIImage alloc] initWithData:data];
            wself.watchVideoInfo.audioOnlyBGItem.image = img;
            complete(img);
        }
    }];
    
    return self.watchVideoInfo.audioOnlyBGItem.image;
}

#pragma mark - CCRecorderEndViewDelegate
- (void)recorderEndView:(EVRecorderEndView *)watchOver didClickedButton:(CCRecorderEndViewButtonType)type
{
    switch (type)
    {
        case CCRecorderEndViewFocusButton:
            [self focusAnchorWithState:1];
            break;
        case CCRecorderEndViewCancelButton:
            [self dismissPageComplete:nil];
            break;
        case CCRecorderEndViewSendPrivateLetter:
            [self sendMessageToAnchor];
            break;
        case CCRecorderEndViewPlaybackButton:
            [self loadWatchStartData];
            self.recordView.currProgress = 0;
            self.recordControlView.currProgress = 0;
            self.recorderEndView.hidden = YES;
            break;
    }
}


#pragma mark - video view protocol

- (void)updateRecorderProgressWithInfo:(NSDictionary *)info
{
    double maxProgress = [info[CCPLAYER_TIME_WHOLE_TIME] doubleValue];
    double currProgress = [info[CCPLAYER_TIME_CURR_TIME] doubleValue];
    double bufferTime = [info[CCPLAYER_TIME_BUFFER_TIME] doubleValue];
    
    if ( maxProgress > 0 )
    {
        self.recordView.maxProgress = maxProgress;
        self.recordControlView.maxProgress = maxProgress;
    }
    if ( currProgress )
    {
        self.recordView.currProgress = currProgress;
        self.recordControlView.currProgress = currProgress;
    }
    if ( bufferTime )
    {
        self.recordView.bufferProgress = bufferTime;
        self.recordControlView.bufferProgress = bufferTime;
    }
    
    if ( currProgress  )
    {
       
    }
}

#pragma mark - livingPlayer
- (void)initVideoPlayer
{
    [self configPlayer];
    [self showLiveMessage:kDefaultConnectingTitle];
    [self pushEvent:kEventStart];
    if ( self.renderViewPrepared )
    {
        [self popEvent:kEventStart];
    }
}

- (void)configPlayer
{
    // 直播加速
    NSString *play_url = [self.watchVideoInfo.uri mutableCopy];
    self.evPlayer = [[EVVideoPlayer alloc] initWithContentURL:play_url];
    CCLog(@"---------init player---------- %@",play_url);
    self.evPlayer.vid = self.watchVideoInfo.vid;
    self.evPlayer.delegate = self;
    self.evPlayer.scalingMode = MPMovieScalingModeFill;
    UIView *playView = [[UIView alloc]init];
    playView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:playView];
    self.evPlayer.presentview = playView;
    [self.view bringSubviewToFront:self.slidScrollView];
    [self.evPlayer play];
    if ( self.watchVideoInfo.mode == 1 )
    {
        __weak typeof(self) wself = self;
        self.evPlayer.audioThumbImage = [self getAudioOnlyBGImageComplete:^(UIImage *image) {
            wself.evPlayer.audioThumbImage = image;
        }];
        
    }
}

//视频才需要实现该委托的两个方法
#pragma mark - evplayer 录播
- (void)startRecordPlayTimer
{
    _recordPlayTimerQueue = dispatch_queue_create("cloudfocus.recordplay", DISPATCH_QUEUE_SERIAL);
    
    _recordPlayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _recordPlayTimerQueue);
    dispatch_source_set_timer(_recordPlayTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(_recordPlayTimer, ^{
        [wself recordTimerUpdate];
    });
    dispatch_resume(_recordPlayTimer);
}

- (void)stopRecordPlayTimer
{
    if ( _recordPlayTimer )
    {
        dispatch_source_cancel(_recordPlayTimer);
        _recordPlayTimer = nil;
    }
}

- (void)recordTimerUpdate
{
    [self performBlockOnMainThread:^{
        [self _recordTimerUpdate];
    }];
}

- (void)_recordTimerUpdate
{
        NSTimeInterval duration = _evPlayer.duration;
        NSInteger intDuration = duration + 0.5;
        NSInteger intBuffering = _evPlayer.playableDuration;
        NSTimeInterval position = _evPlayer.currentPlaybackTime;
        double intPosition = position + 0.5;
        [self updateRecorderProgressWithInfo:@{CCPLAYER_TIME_WHOLE_TIME: @(intDuration), CCPLAYER_TIME_CURR_TIME: @(intPosition), CCPLAYER_TIME_BUFFER_TIME: @(intBuffering)}];
        [self updateVideoInfo:@{AUDIENCE_UPDATE_PLAY_TIME: [NSString stringFormattedTimeFromSeconds:&intPosition]}];
        self.watchVideoInfo.currSecond = intPosition;
}

#pragma mark - EVVideoPlayerDelegate
- (void)evVideoPlayer:(EVVideoPlayer *)player didChangedState:(EVPlayerState)state {
    switch (state) {
        case EVPlayerStateBuffering: {
            CCLog(@"EVPlayerStateBuffering");
            _playerStateCompleted = YES;
            if ( !self.shareView.hidden )
            {
                self.shareView.hidden = YES;
            }
            [self showLiveMessage:kE_GlobalZH(@"buffer_wait")];
            break;
        }
        case EVPlayerStatePlaying: {
            [self hiddenConnectErrorView];
        
            self.watchVideoInfo.bufferCount++;
            if ( self.watchVideoInfo.bufferCount >= 2 )
            {
                self.watchVideoInfo.playing = YES;
            }
            _playerStateCompleted = YES;
            self.commentTableView.hidden = NO;
            break;
        }
        case EVPlayerStateUnknown: {
            break;
        }
        case EVPlayerStateConnectFailed:
            CCLog(@"---------evplayer connect failed----------");
        case EVPlayerStateComplete: {
            CCLog(@"--msw--evlive video over----");
            _playerStateCompleted = YES;
            if ( self.watchVideoInfo.living )
            {
              
                // 视频播放器外部重连（即销毁老的播放器，重新初始化播放器）
                [self resumePlayer];
              
            }
            else
            {
                [self destroyStreamerPlayer];
            }
            break;
        }
    }
}
- (void)evVideoPlayer:(EVVideoPlayer *)player updateBuffer:(int)percent position:(int)position {
    self.connectErrorView.percent = percent;
}


#pragma mark - floating view delegate
//这块在修改 添加管理员
- (void)floatingView:(EVFloatingView *)floatingView clickButton:(UIButton *)button
{
    
    NSString *vid = self.vid;
    if ( vid == nil )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"living_data_loading") toView:self.view];
        return;
    }
    NSInteger tag = button.tag;
    __block EVUserModel *userModel = floatingView.userModel;
    
    switch (tag) {
        case CCFloatingViewReport:
        {
            if ( userModel.name.length == 0 )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"user_data_loading") toView:self.view];
                return;
            }
            [floatingView dismiss];
            self.reportedUser = userModel;
            if ([button.titleLabel.text isEqualToString:kE_GlobalZH(@"e_manager")]) {
                NSArray *arrayCon = [self isManagerUserAndShutup:floatingView];
                [[EVManagerUserView shareSheet]showAnimationViewArray:arrayCon reportTitle:kE_GlobalZH(@"e_manager") delegate:self];
            }else{
                [self reportUserTitle:kE_GlobalZH(@"report_user")];
            }
        }
            break;
        case CCFloatingViewAtTa:   // 回复评论
        {
            self.sendComment = YES;
            EVComment *comment = [[EVComment alloc] init];
            comment.name = userModel.name;
            comment.reply_nickname = userModel.nickname;
            comment.reply_name = userModel.name;
            if ( [EVLoginInfo checkCurrUserByName:comment.name] )
            {
                [CCProgressHUD showError:kE_GlobalZH(@"not_give_me_send_comment") toView:self.view];
                return;
            }
            [self.floatView dismiss];
            NSString *replyNickNameString = [NSString stringWithFormat:@"@%@ ",userModel.nickname];
            comment.replyNickNameString = replyNickNameString;
            [self.chatTextView setReplyString:replyNickNameString];
            [self.chatTextView beginEdit];
        }
            break;
            
        case CCFloatingViewFocucs:         // 关注
        {
            [self focusAudienceWithUserModel:userModel];
        }
            break;
            
        case CCFloatingViewHomePage:
            // 主页
            [self showUserCenterWithName:userModel.name fromLivingRoom:NO];
            break;
            
        case CCFloatingViewMessage:      // 私信
            [self gotoLetterPageWithUserModel:userModel];
            break;
            
            
        default:
            break;
    }
}

- (NSArray *)isManagerUserAndShutup:(EVFloatingView *)floatingView
{
    NSArray *array = [NSArray array];
    if (self.shutupUsers.count == 0) {
        
        array = @[kE_GlobalZH(@"e_gag"),kE_GlobalZH(@"e_report")];
        
    } else {
        for (NSString *shutupStr in self.shutupUsers) {
            if ([shutupStr isEqualToString:floatingView.userModel.name]) {
                array = @[kE_GlobalZH(@"complete_gag"),kE_GlobalZH(@"e_report")];
            } else {
                array = @[kE_GlobalZH(@"e_gag"),kE_GlobalZH(@"e_report")];
            }
        }
    }
    
    return array;
    
}

- (void)audienceShutedupDenied
{
    [CCProgressHUD showError:kE_GlobalZH(@"not_limit") toView:self.view];
}

- (void)audienceShutedupSuccess
{
    [self.shutupUsers  addObject:self.reportedUser.name];
    [CCProgressHUD showSuccess:kE_GlobalZH(@"success_gag") toView:self.view];
}


#pragma mark - 加速直播
- (void)setUpPlayer
{
    if ( self.watchVideoInfo.uri == nil )
    {
        return;
    }

    [self initVideoPlayer];
}


- (void)failErrorLivingDataError:(NSError *)error
{
    NSString *customError = nil;
    if ( error.code == kBaseToolErrorCode )
    {
        customError = [error errorInfoWithPlacehold:CCAPP_GLOBAL_PLACEHOLDER];
    }
    else if ( error.code == 2 )     // timeout, 尝试重试
    {
        [self loadWatchStartData];
        return ;
    }
    else
    {
        NSError *underlyingError = (NSError *)((error.userInfo)[@"NSUnderlyingError"]);
        if ( underlyingError
            && [underlyingError isKindOfClass:[NSError class]]
            && underlyingError.code == 2)   // error.code=1, 并且判断为断网, 不重试
        {
            NSError *err = [NSError cc_errorWithDictionary:nil];
            customError = [err errorInfoWithPlacehold:k_NETWORK_BAD_NOTE];
        }
        else if ( underlyingError
                 && [underlyingError isKindOfClass:[NSError class]]
                 && underlyingError.code == 60)     // error.code=1, operation timeout, 重试
        {
            [self loadWatchStartData];
            return ;
        }
        else    // 其他错误，暂时不尝试（是否跟断网或者timeout合并根据需求确定）
        {
            NSError *err = [NSError cc_errorWithDictionary:nil];
            customError = [err errorInfoWithPlacehold:k_NETWORK_BAD_NOTE];
        }
    }
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:customError comfirmTitle:kOK WithComfirm:^{
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self dismissPageComplete:nil];
    }];
}

- (void)successLivingDataVideoInfo:(NSDictionary *)videoInfo
{
    EVWatchVideoInfo *watchVideoInfo = [EVWatchVideoInfo objectWithDictionary:videoInfo];
    self.isWatchStartSuccess = YES;
    self.vid = videoInfo[kVid];
    self.topicVid = videoInfo[kVid];
    self.anchorName = videoInfo[kNameKey];
    self.videoInfoView.item.name = videoInfo[kNameKey];
    self.videoInfoView.item.nickname = videoInfo[kNickName];
    self.videoInfoView.item.title = videoInfo[kTitle];
    self.videoInfoView.item.fansCount = [videoInfo[@"like"] integerValue];
    self.videoInfoView.item.focusCount = [videoInfo[kFollow] integerValue];
    self.videoInfoView.item.iconURLString = videoInfo[kThumb];
  
    if ([self.anchorName isEqualToString:[EVLoginInfo localObject].name] ) {
        self.videoInfoView.item.followed = YES;
    }
    if (self.videoInfoView.item.focusCount == 0) {
       self.AudienceViewConstraint.constant = 143;
    }else {
         self.AudienceViewConstraint.constant = 100;
    }
    self.endWatchView.tipLabel.text = watchVideoInfo.living ?  kE_GlobalZH(@"living_end"):kE_GlobalZH(@"playback_end");
   
    [self livingAndEndLivingWatchVideoInfo:watchVideoInfo videoInfo:videoInfo];
}


- (void)livingAndEndLivingWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo videoInfo:(NSDictionary *)videoInfo
{

    self.watchVideoInfo = watchVideoInfo;
    [self setUpPlayer];
    // 正在直播
    if ( self.watchVideoInfo.living)
    {
        self.floatView.isAnchor = YES;
        self.videoInfoView.item.time = @"1";
        self.videoInfoView.item.mode = CCAudienceInfoItemWatchLive;
        self.bottomItemViewTemp.chatButton.hidden = NO;
        self.watchVideoInfo = watchVideoInfo;
        [self.recordControlView removeFromSuperview];
        
        [self showLiveMessage:kDefaultConnectingTitle];
                // 初始化播放器
        CCLog(@"---------watch start----------");
    }
    else    // 录播
    {
        self.floatView.isAnchor = NO;
        self.magicEmojiView.noRedPacket = YES;
        self.videoInfoView.item.mode = CCAudienceInfoItemReplay;
        self.bottomItemViewTemp.chatButton.hidden = YES;
        self.bottomItemViewTemp.timeLineConstraint.constant = -30;
        self.recordControlView.hidden = NO;
        self.commentAndUserJoinContainerViewConstraint.constant = -82;
        [self.commentTableView removeConstraint:self.commentTableBottomConstraint];
        [self.commentTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.recordControlView setUp];
        [self.chatTextView removeFromSuperview];
        [self.loveView removeFromSuperview];
        [self addLoveView];
        [self.loveView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [self.loveView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.loveView addGestureRecognizer:self.loveTap];
                
        // 点击触发赞的view，不是显示赞的view
        UIView *loveView = [[UIView alloc] init];
        [self.contentView addSubview:loveView];
        [loveView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [loveView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [loveView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.recordControlView];
        [loveView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.riceAmountView];
        [self.contentView sendSubviewToBack:loveView];
        [self.contentView insertSubview:loveView aboveSubview:self.presentAnimatingView];
        [loveView addGestureRecognizer:self.loveTap];
                
        CCLog(@"---------watch start----------");
        [self startRecordPlayTimer];
    }
    
    
    NSString *extra = @"NULL";
    if ( videoInfo[kExtra] )
    {
        extra = videoInfo[kExtra];
    }
    // 发送直播观看的初始数据
    [self.contacter boardCastEvent:CCWatchInfoPrepare withParams:@{CCWatchInfoPrepare: watchVideoInfo}];
    self.vid = watchVideoInfo.vid;
    self.anchorName = watchVideoInfo.name;
}


#pragma mark - 提示信息
- (void)alertNotWifi
{
    WEAK(self);
    // 如果是移动网络 提醒流量
    // 本地记录
    BOOL hasNotify = [[CCUserDefault objectForKey:kHasNotifyNotWifiKey] boolValue];
    if ( [EVNetWorkStateManger sharedManager].reachableViaWWAN == YES && hasNotify == NO )
    {
        [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"network_warn") message:kE_GlobalZH(@"mobile_network_money") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
            [weakself loadWatchStartData];
            [weakself setUpPlayer];
            [weakself setUpContacterEvents];
        } cancel:^{
            [weakself forceToClose];
        }];
        [CCUserDefault setBool:YES forKey:kHasNotifyNotWifiKey];
    }
    else
    {
        [self loadWatchStartData];
        // 预加载
        CCLog(@"---------预加载----------");
        [self setUpPlayer];
        [self setUpContacterEvents];
    }
}

- (void)showLiveMessage:(NSString *)message
{
//    [self showConnectErrorWithTitle:message];
}


- (void)hiddenConnectErrorView
{
    [self.connectErrorView stopAnimation];
//    [self addGestureGuideCoverviewWithImageNamed:@"cue_watching"];
    /** 只有此一次加载成功的时候才展示主播信息菜单 */
    if ( !self.firstLoadVideoSuccess )
    {
        self.firstLoadVideoSuccess = YES;
    }
}


#pragma mark - config Views
- (void)configView
{
    self.view.backgroundColor = [UIColor clearColor];
    
    // 添加模糊背景图
    [self.view addSubview:[EVVideoFunctions blurBackgroundImageView:self.watchVideoInfo.thumb]];
    [self.view bringSubviewToFront:self.slidScrollView];
    

    
    /** 最下面的toolbar */
    [self addToolBarToBottomView];
    
    /** 新的录播控制视图 */
    [self addMediaControlView];
    
    // 点击触发赞的view，不是显示赞的view
    UIView *loveView = [[UIView alloc] init];
    [self.contentView addSubview:loveView];
    [loveView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [loveView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [loveView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chatTextView];
    [loveView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.riceAmountView];
    [self.contentView sendSubviewToBack:loveView];
    [self.contentView insertSubview:loveView aboveSubview:self.presentAnimatingView];
    
    UITapGestureRecognizer *loveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLove)];
    self.loveTap = loveTap;
    [loveView addGestureRecognizer:loveTap];
}



/** 添加按钮 */
- (void)addToolBarToBottomView
{
    EVWatchBottomItemView *bottomBtnView = [[EVWatchBottomItemView alloc] init];
    bottomBtnView.delegate = self;
    bottomBtnView.chatButton.hidden = YES;
    bottomBtnView.timeLineButton.hidden = YES;

    [self.contentView addSubview:bottomBtnView];
    self.bottomBtnContainerView = bottomBtnView;
    self.bottomItemViewTemp = bottomBtnView;
    [bottomBtnView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 10, 10) excludingEdge:ALEdgeTop];
    [self.loveView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bottomBtnView];
    [self.loveView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bottomBtnView];
    self.chatTextView.bottomView = bottomBtnView;
}

- (void)addMediaControlView
{
    EVRecordControlView *recordControlView = [[EVRecordControlView alloc] init];
    recordControlView.delegate = self;
    recordControlView.hidden = YES;
    [self.contentView addSubview:recordControlView];
    self.recordControlView = recordControlView;
    [recordControlView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) excludingEdge:ALEdgeTop];
    [recordControlView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.commentTableView withOffset:0];
}

- (void)showWatchEndView
{
    NSLog(@"不是直接受到的纸币结束,咋那么慢");
    NSLog(@"--------------------------henmanhenaman");
    EVWatchLiveEndData *data = [[EVWatchLiveEndData alloc] init];
    data.audienceCount = self.watch_count;
    data.likeCount = self.like_count;
  
    data.followed = self.watchVideoInfo.followed;
    data.riceCount = self.riceAmountView.lasttimeRiceCount;
    data.isOneself = [[EVLoginInfo localObject].name isEqualToString:self.watchVideoInfo.name];
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.endWatchView];
    self.endWatchView.watchEndData = data;
    self.endWatchView.hidden = NO;
    [self hiddenContentSubviews];
    self.isEndLiving = YES;
    [self.videoInfoView closeNoAnimation];
}

/**< 进场动画 */
- (void)addWatchEnterAnimation
{
    EVLoginInfo *loginfo = [EVLoginInfo localObject];
    EVAudience *audoence = [[EVAudience alloc]init];
    audoence.nickname = loginfo.nickname;
    audoence.vip_level = loginfo.vip_level;
    NSArray *array = [NSArray arrayWithObject:audoence];
    [self.enterAnimationView enterAnimation:array];
}


#pragma mark - Lazy load
- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
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

- (EVRecorderEndView *)recorderEndView
{
    if ( !_recorderEndView )
    {
        EVRecorderEndView *recorderEndView = [[EVRecorderEndView alloc] initWithFrame:self.view.bounds];
        recorderEndView.hidden = YES;
        recorderEndView.delegate = self;
        [self.view addSubview:recorderEndView];
        _recorderEndView = recorderEndView;
    }
    return _recorderEndView;
}

- (EVWatchLiveEndView *)endWatchView
{
    if ( !_endWatchView )
    {
        EVWatchLiveEndView *endWatchView = [[EVWatchLiveEndView alloc] initWithFrame:self.view.bounds];
        endWatchView.hidden = YES;
        endWatchView.delegate = self;
        [self.view addSubview:endWatchView];
        _endWatchView = endWatchView;
    }
    return _endWatchView;
}

- (EVRecordInfoView *)recordView
{
    if ( _recordView == nil )
    {
        _recordView = [EVRecordInfoView recordInfoViewToSuperView:self.contentView height:115];
        _recordView.hidden = YES;
        _recordView.delegate = self;
    }
    return _recordView;
}


@end
