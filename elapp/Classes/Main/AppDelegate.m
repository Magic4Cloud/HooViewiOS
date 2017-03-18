//
//  AppDelegate.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "AppDelegate.h"
#import "EVHomeTabBarItem.h"
#import "EVLoginViewController.h"
#import "EVPushManager.h"
#import "EVNetWorkStateManger.h"
#import "EVPushBar.h"
#import "UIWindow+Extension.h"
#import "EVLiveViewController.h"
#import "EVOpenURLManager.h"
#import "NSString+Extension.h"
#import "EVAlertManager.h"
#import "EVNotifyConversationItem.h"
#import "EVLoginInfo.h"
#import "EVNotifyListViewController.h"
#import "EVCacheManager.h"
#import "EVBugly.h"
#import "EVNavigationController.h"
#import "EVPayManager.h"
#import "EVWatchVideoInfo.h"
#import "EVDetailWebViewController.h"
#import "EV3rdPartAPIManager.h"
#import "EVTimerTool.h"
#import "EVSDKInitManager.h"
#import "EVNotificationManager.h"
#import "EVAudioPlayer.h"
#import "EVMineViewController.h"
#import "EVMarketViewController.h"
#import "EVConsultViewController.h"
#import "EVLiveListViewController.h"
#import "EVHVWatchViewController.h"
#import "EVEaseMob.h"
#import "ZYLauchMovieViewController.h"

#import "EVConsultGuideView.h"


NSString * const kStatusBarTappedNotification = @"statusBarTappedNotification";

#define kIsFirstLauchApp @"kIsFirstLauchApp"

@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic,strong) EVTimerTool *timerTool;
@property (nonatomic, strong)EVConsultGuideView *guideView;

@end

@implementation AppDelegate

- (void)dealloc{
    [EVNotificationCenter removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[EVAppSetting shareInstance] createCacheAppFolder];
    application.applicationIconBadgeNumber = 0;
    UIWindow *win = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    win.backgroundColor = [UIColor whiteColor];
    self.window = win;
    [win makeKeyAndVisible];
    
    [EVBugly registerBugly];
    
    [self setUpNotification];
    [[EVPayManager sharedManager] checkWhetherAnyBuyedProductDoNotUploadToServerAndThenPushThem];
    [[EVPushManager sharePushManager] setUpWithOptions:launchOptions];
    [self appPrepareWithOptions:launchOptions];
    [self setUpAppHomeController];
    
//    [EVAudioPlayer  initialAudioPlayerBackgroundThread];
    
    // 清理资源
    [[EVCacheManager shareInstance] cleanDiskImageCaches];
    [self setUpTimer];
    
    [[EVPushManager sharePushManager] setDidReceiveNotificationResponseBlock:^(NSDictionary *userInfo) {
        [EVPushManager setCurrentBadge:[userInfo[@"aps"][@"badge"] integerValue]];
        [self handlelLocalNotificationWith:userInfo];
    }];
    
    [[EVPushManager sharePushManager] setWillPresentNotificationBlock:^(NSDictionary *userInfo) {
        [EVPushManager setCurrentBadge:0];
        [self handlelLocalNotificationWithOnActiveState:userInfo];
    }];
  
    
    return YES;
}


- (BOOL)isFirstLauchApp {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLauchApp];
}
- (void)setUpTimer
{
    _timerTool = [[EVTimerTool alloc] init];
    [_timerTool startCountTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location))
    {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction
{
    [EVNotificationCenter postNotificationName:kStatusBarTappedNotification object:nil];
}

- (EVBaseToolManager *)liveEngine
{
    if ( _liveEngine == nil )
    {
        _liveEngine = [[EVBaseToolManager alloc] init];
    }
    return _liveEngine;
}

- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(netWorkChange:) name:CCNetWorkChangeNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(onReLogin:) name:CCNeedToReLoginNotification object:nil];
}

- (void)onReLogin:(NSNotification *)notification
{
    [EVLoginInfo cleanLoginInfo];
    [EVBaseToolManager resetSession];

    if ( [notification.userInfo[FROM_WATCH_LIVING_CONTROLLER] boolValue] )
    {
        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"account_again_login") comfirmTitle:kOK WithComfirm:^{
            [EVNotificationCenter postNotificationName:CCNeedToForceCloseLivePageOrWatchPage object:nil userInfo:@{CCNeedToReLoginControllerNotificationKey: self}];
        }];
        return;
    }
    
    //UIViewController *controller =  notification.userInfo[CCNeedToReLoginControllerNotificationKey];
    
    
    if ([EVAppSetting shareInstance].isLogining)  return;
    
//    UINavigationController *navCon = [EVLoginViewController loginViewControllerWithNavigationController];
//    [controller presentViewController:navCon animated:YES completion:nil];
}



- (void)netWorkChange:(NSNotification *)notification{
    EVNetworkStatus state = (EVNetworkStatus)[notification.userInfo[CCNetWorkStateKey] integerValue];
    if ( WithoutNetwork != state ) {
        [EVBaseToolManager checkSessionID];
    }
}

- (void)appPrepareWithOptions:(NSDictionary *)launchOptions
{
    // 环信注册
    [[EVEaseMob cc_shareInstance] registForAppWithOptions:launchOptions];
    [[EVNetWorkStateManger sharedManager] startMonitoring];
    // 全局数据库管理工具类
    [[EVDB shareInstance] prepare];
    [EVBaseToolManager checkSessionID];
    // 微信、微博、QQ空间
    [[EV3rdPartAPIManager sharedManager] registForAppWeiXinKey:WEIXIN_APP_KEY weiBoKey:WEIBO_APP_KEY QQkey:QQ_APP_ID];
    // GrowingIO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)setUpAppHomeController
{
//    [self setUpHomeController]; 
   
    if (![self isFirstLauchApp]) {
        ZYLauchMovieViewController *vc = [[ZYLauchMovieViewController alloc] init];
        self.window.rootViewController = vc;
        vc.mainBlock  = ^(){
             [self setUpHomeController];
            
        };
    }else {
         [self setUpHomeController]; 
    }
//    [self.window makeKeyAndVisible];
    NSLog(@"------ %@ ---- ",[EVLoginInfo localObject].name);
    [EVSDKInitManager initMessageSDKUserData:[EVLoginInfo localObject].name];
//    if ( [EVBaseToolManager userHasLoginLogin])
//    {
//        
//        //  下载备注列表
//    }
//    else
//    {
////        [self setUpHomeController];
//        [self setUpLoginController];
//    }
}

- (void)setUpLoginController
{
    self.window.rootViewController = [EVLoginViewController loginViewControllerWithNavigationController];
}

- (void)relogin
{
    [self.homeVC presentViewController:[EVLoginViewController loginViewControllerWithNavigationController] animated:YES completion:nil];
}

- (void)chatWithName:(NSString *)name
{
    [self.homeVC startChatWithName:name];
}

- (void)setUpHomeController
{
    if ( self.homeVC )
    {
        self.window.rootViewController = self.homeVC;
        return;
    }

    NSMutableArray *items = [NSMutableArray array];
    
    // 咨询
    EVConsultViewController *firstVC = [[EVConsultViewController alloc] init];
    EVNavigationController *firstNav = [EVNavigationController navigationWithWrapController:firstVC];
    EVHomeTabBarItem *firstItem = [EVHomeTabBarItem homeTabBarItemWithController:firstNav];
    [items addObject:firstItem];
    
    
    // 直播
    EVLiveListViewController *secondVC = [[EVLiveListViewController alloc] init];
    EVNavigationController *secondNav = [EVNavigationController navigationWithWrapController:secondVC];
    EVHomeTabBarItem *secondItem = [EVHomeTabBarItem homeTabBarItemWithController:secondNav];
    [items addObject:secondItem];
    
    
    // 行情
    EVMarketViewController *threeVC = [[EVMarketViewController alloc] init];
    EVNavigationController *threeNav = [EVNavigationController navigationWithWrapController:threeVC];
    EVHomeTabBarItem *threeItem = [EVHomeTabBarItem homeTabBarItemWithController:threeNav];
    [items addObject:threeItem];
    
    // 个人
    EVMineViewController *fourVC = [[EVMineViewController alloc] init];
    EVNavigationController *fourNav = [EVNavigationController navigationWithWrapController:fourVC];
    EVHomeTabBarItem *fourItem = [EVHomeTabBarItem homeTabBarItemWithController:fourNav];
    [items addObject:fourItem];
    
    
    EVHomeViewController *homeVC = [EVHomeViewController homeViewControllerWithItems:items];
    homeVC.selectedIndex = 0;
    
    self.window.rootViewController = homeVC;
    self.homeVC = homeVC;
    
#pragma mark -----------------------------------------------------
    if (![self isFirstLauchApp]) {
        NSArray *loginXib = [[NSBundle mainBundle] loadNibNamed:@"EVConsultGuideView" owner:nil options:nil];
        EVConsultGuideView *guideView = [loginXib firstObject];
        guideView.backgroundColor = [UIColor clearColor];
        guideView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.guideView = guideView;
        [homeVC.view addSubview:guideView];
        
        self.guideView.liveBackImage.hidden = YES;
        self.guideView.marketBackImage.hidden = YES;
        self.guideView.knowButton2.hidden = YES;
        self.guideView.knowButton3.hidden = YES;
        self.guideView.knowButton4.hidden = YES;
        self.guideView.knowButton5.hidden = YES;
        
        guideView._knowBlock  = ^(){
            self.homeVC.selectedIndex = 1;
        };
        guideView._knowBlockLive  = ^(){
            self.homeVC.selectedIndex = 2;
        };
        guideView._endGuideBlock  = ^(){
            self.homeVC.selectedIndex = 0;
            [self.guideView removeFromSuperview];
        };
    }
}

- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册应用的标志
    [application registerForRemoteNotifications];
}

- (void)                                application:(UIApplication *)application
   didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if ( deviceToken )
    {
        [[EVPushManager sharePushManager] bindWithDeviceToken:deviceToken];
//        [[EVEaseMob cc_shareInstance] registerForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    [[EVEaseMob cc_shareInstance] remoteRegistDidFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    // 注册用户数据
 
    [[EVPushManager sharePushManager] handleWithUserInfo:userInfo];
    if ( application.applicationState == UIApplicationStateActive ) {
        [self handlelLocalNotificationWithOnActiveState:userInfo];
        return;
    }
    [self handleRemoteNotification:userInfo];

}


#pragma mark - 用于处理远程推送过来的数据
- (void)handleRemoteNotification:(NSDictionary *)userInfo{
    NSString *alertBody = userInfo[@"alert"];
    EVLocalNotification *noti = [EVLocalNotification localNotificationWithAlertBody:alertBody AlertAction:kE_GlobalZH(@"have_living_watch")];
    noti.alertAction = @"test";
    noti.userInfo = userInfo;
    [[EVNotificationManager  shareNotificationManager] performLocalNotification:noti];
}

#pragma mark - 处理本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [self handlelLocalNotificationWith:notification.userInfo];
}

#pragma mark - 跳转
- (void)switchToPredictControllerWithUserInfo:(NSDictionary *)userInfo
{
    
}

- (void)handlelLocalNotificationWith:(NSDictionary *)userInfo{
    
     [self handlelLiveNotificationWith:userInfo];
    
    if ( userInfo[@"f"] )   // 环信推送
    {
        [self handleIMNoticationWith:userInfo];
        return;
    }
}

- (void)handlelNotifyNotificationWith:(NSDictionary *)dict
{
    EVNotifyListViewController *notifyListVC = [[EVNotifyListViewController alloc] init];
    EVNotifyItem *item = [[EVNotifyItem alloc] init];
    item.groupid = dict[@"groupid"];
    notifyListVC.notiItem = item;

//    [self setUpHomeController];
    self.homeVC.selectedIndex = 2;
    
    EVNavigationController *notifyNavVC = self.homeVC.viewControllers[2];
    [notifyNavVC pushViewController:notifyListVC animated:YES];
}

#pragma mark - 环信推送
- (void)handleIMNoticationWith:(NSDictionary *)dict
{   
//    [self setUpHomeController];
    self.homeVC.selectedIndex = 3;
}


#pragma mark - 直播推送
- (void)handlelLiveNotificationWith:(NSDictionary *)dict
{
    NSString *vid = dict[kVid];
    
    if ( ![vid isKindOfClass:[NSString class]] ||
        [NSString isBlankString:vid] )
    {
        return;
    }
//    EVWatchViewController *watchVC = [[EVWatchViewController alloc] init];
//    EVWatchVideoInfo *watchVideoInfo = [[EVWatchVideoInfo alloc] init];
//    watchVideoInfo.vid = vid;
//    watchVC.watchVideoInfo = watchVideoInfo;
//    
//    __block UIViewController *presenetVC = [self.window visibleViewController];
//    
//    if ( [presenetVC isKindOfClass:[EVWatchViewController class]] )
//    {
//        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"is_end_play") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
//            EVHVWatchViewController *currWatchVC = (EVHVWatchViewController *)presenetVC;
//            UIViewController *vc = [self.window visibleViewController];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:currWatchVC];
//            [self presentViewController:nav animated:YES completion:nil];
////            [currWatchVC foreceToPopCurrentWatchPage:^{
////
////                UINavigationController *nav = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
////                [nav pushViewController:watchVC animated:YES];
////            }];
//        } cancel:nil];
//        return;
//    }
    
//    if ( [presenetVC isKindOfClass:[EVLiveViewController class]] )
//    {
//         [EVProgressHUD showMessageInAFlashWithMessage:kE_GlobalZH(@"self_living_not_push")];
//        return;
//    }
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchVC];
//    [self.homeVC presentViewController:nav animated:NO completion:nil];
    
}


#pragma mark - 私信推送
- (void)handlelMessageNotificationWith:(NSDictionary *)dict
{
    
}

#pragma mark - 关注推送
- (void)handlelFocusNotificationWith:(NSDictionary *)dict
{
    UIViewController *presenetVC = [self.window visibleViewController];
    
    UINavigationController *presentNav = presenetVC.navigationController;
    
    self.window.rootViewController = self.homeVC;
    if ( 3 == self.homeVC.selectedIndex )
    {
        [presentNav popToRootViewControllerAnimated:YES];
    }
    else
    {
        self.homeVC.selectedIndex = 3;
    }
}

#pragma mark - 活动推送

- (void)handleActivityNotificationWith:(NSDictionary *)dict
{
    NSString *h5_url = dict[kH5_url];
    NSString *activity_id = dict[kActivity_id];
    NSString *title = dict[kTitle];
    
    UIViewController *presenetVC = [self.window visibleViewController];
    UIViewController *vc = nil;
    if ( ![NSString isBlankString:h5_url] )
    {
        EVDetailWebViewController *h5WebVC = [EVDetailWebViewController activityDetailWebViewControllerWithURL:h5_url];
        h5WebVC.activityTitle = [title mutableCopy];
        h5WebVC.activityId = [activity_id mutableCopy];
        vc = h5WebVC;
    }
    EVNavigationController *nav = [[EVNavigationController alloc] initWithRootViewController:vc];
    [presenetVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 处理本地通知
- (void)handlelLocalNotificationWithOnActiveState:(NSDictionary *)userInfo{
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    EVPushBar *pushBar = [EVPushBar pushBarWithTitle:userInfo[@"aps"][@"alert"]];
    [pushBar addTarget:self action:@selector(notificationButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [keyWin addSubview:pushBar];
    pushBar.userInfo = userInfo;
    pushBar.alpha = 0;
    __block CGRect frame = pushBar.frame;
    frame.origin.y = -frame.size.height;
    pushBar.frame = frame;
    [UIView animateWithDuration:0.8 animations:^{
        pushBar.alpha = 1.0;
        frame.origin.y = 0;
        pushBar.frame = frame;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( pushBar.isPushBarRemove ) {
                return ;
            }
            pushBar.isPushBarRemove = YES;
            [UIView animateWithDuration:0.8 animations:^{
                pushBar.alpha = 0;
                frame.origin.y = -frame.size.height;
                pushBar.frame = frame;
            } completion:^(BOOL finished) {
                [pushBar removeFromSuperview];
            }];
        });
    }];
}

- (void)notificationButtonDidClick:(EVPushBar *)pushButton{
    [self handlelLocalNotificationWith:pushButton.userInfo];
    pushButton.hidden = YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[EVOpenURLManager shareInstance] openUrl:url])
    {
        return YES;
    }
    return [self handleThirdPartOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    return [self handleThirdPartOpenURL:url];
}

- (BOOL)handleThirdPartOpenURL:(NSURL *)url
{
    
    if ( [EV3rdPartAPIManager sharedManager].authType == EVShareManagerAuthNone ) {
        return NO;
    }
    return [[EV3rdPartAPIManager sharedManager] handleURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[CCContactsManager shareInstance] unRegistToApp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清除所有内存缓存
    [[EVCacheManager shareInstance] clearMemoryImageCashes];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[EVPushManager sharePushManager]resetJpushBadge];
} 

- (void)applicationWillResignActive:(UIApplication*)application{
    /*添加你自己的挂起前准备代码*/
    [[EVPushManager sharePushManager]resetJpushBadge];
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window

{
    if (_allowRotation == YES) {
        
        return UIInterfaceOrientationMaskLandscapeLeft;
        
    }else{
        
        return (UIInterfaceOrientationMaskPortrait);
        
    }
    
}
@end
