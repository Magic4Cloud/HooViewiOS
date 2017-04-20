//
//  EVHomeViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeViewController.h"
#import "EVHomeTabBarItem.h"
#import "EVLiveViewController.h"
#import "EVAlertManager.h"
#import "EVLoginViewController.h"
#import "EVAccountPhoneBindViewController.h"
#import "AppDelegate.h"
#import "EVNotifyConversationItem.h"
#import "EVStreamer.h"
#import "UIViewController+Extension.h"
#import "EVHomeTabbar.h"
#import "EVStreamer+Extension.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVBaseToolManager+EVMessageAPI.h"
#import "AppDelegate.h"
#import "EVEaseMob.h"
#import "EVSDKInitManager.h"

#define kPushHotController  @"pushHotController"

@interface EVHomeViewController () <EVHomeTabbarDelegate ,CCLiveViewControllerDelegate, EMClientDelegate>

@property (nonatomic, strong) NSArray *items;

@property (nonatomic,weak) UIImageView *indexImageView;
@property (nonatomic, assign) BOOL showIndexImageView;

@property (strong, nonatomic) EVBaseToolManager *engine;

@property (nonatomic, assign) BOOL viewHasAppear;

@property (nonatomic,weak) EVHomeTabbarContainer *homeTabbar;

@property (nonatomic, assign) BOOL foreground;

@end
@implementation EVHomeViewController

//lock vertical
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    EVLog(@"CCHomeViewController dealloc");
    [EVNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
}

+ (instancetype)homeViewControllerWithItems:(NSArray *)items
{
    EVHomeViewController *controller = [[EVHomeViewController alloc] init];
    controller.items = items;
    for (EVHomeTabBarItem *item in items) {
        [controller addChildViewController:item.controller];
    }
    return controller;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;//关键语句，必须有
    
    [self configView];
    [self setUpNotification];
    [self setUpIM];
    [self getStartResourceTool];
}

- (void)getStartResourceTool
{
    [[EVStartResourceTool shareInstance] loadData];
}

- (void)setUpIM
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//    [EVEaseMob setChatManagerDelegate:self];
}

- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    EVLog(@"EMConnectionState %ld", (NSUInteger)aConnectionState);
}

- (void)userAccountDidLoginFromOtherDevice {
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kAccountOtherDeviceLogin cancelButtonTitle:kCancel comfirmTitle:kAgainLogin WithComfirm:^{
        [self handleLogoutAction];
        
        if (![EVLoginInfo hasLogged]) {
            
            if ( self.navigationController.childViewControllers.count > 1 )
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ( self.navigationController.childViewControllers.count == 1 )
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ( self.navigationController.childViewControllers.count == 0 )
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate relogin];
            
//            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//            [self presentViewController:navighaVC animated:YES completion:nil];
        }
    } cancel:^{
        [self handleLogoutAction];
    }];
}

- (void)handleLogoutAction {
    [EVNotificationCenter postNotificationName:@"userLogoutSuccess" object:nil];
    [_engine cancelAllOperation];
    [_engine GETLogoutWithFail:^(NSError *error) {
    } success:^{
        EVLog(@"logout success");
    } essionExpire:^{
        
    }];
    [EVEaseMob logoutIMLoginFail:^(EMError *error) {
        EVLog(@"EMlogouterror-----  %@",error);
    }];
    [EVLoginInfo cleanLoginInfo];
    [EVBaseToolManager resetSession];
    [EVSDKInitManager initMessageSDKUserData:nil];
    [EVNotificationCenter postNotificationName:NotifyOfLogout object:nil];
}

#pragma mark - EMChatManagerDelegate
//- (void)didReceiveMessage:(EMMessage *)message
//{
//    [EVEaseMob checkApplicationStateWithMessage:message];
//    [self.allMessages addObject:message];
//    // 判断是否需要显示小红点
//    if ( self.allMessages.count > 0 )
//    {
//        self.homeTabbar.showRedPoint = YES;
//    }
//}

//- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
//{
//    for (EMMessage *message in offlineMessages) {
//        [self.allMessages addObject:message];
//    }
//    // 判断是否需要显示小红点
//    if ( self.allMessages.count > 0 )
//    {
//        self.homeTabbar.showRedPoint = YES;
//    }
//}

- (NSMutableArray *)allMessages
{
    if ( _allMessages == nil )
    {
        _allMessages = [NSMutableArray array];
    }
    return _allMessages;
}

- (void)setUpNotification
{
    _foreground = NO;
    [EVNotificationCenter addObserver:self selector:@selector(shouldShowRedPointOnTabBar:) name:CCScretLetterRedPointShowNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(receiveTimeUpdate:) name:EVUpdateTime object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [EVNotificationCenter addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
 
}

- (void)BackToControllor:(NSNotification *)notification
{
    self.selectedIndex = 0;
}

- (void)enterForeground
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    _foreground = YES;
}

- (void)enterBackground
{
    _foreground = NO;
}

- (void)shouldShowRedPointOnTabBar:(NSNotification *)notification
{
    BOOL showRedPoint = [notification.userInfo[CCShowRedPoint] boolValue];
    self.homeTabbar.showRedPoint = showRedPoint;
    // TODO : 小红点
}

- (void)startLiveFromNotification:(NSNotification *)notification
{
//    EVLivePermission permission = [notification.userInfo[EVLivePermissionKey] integerValue];
    [self requestNormalLivingPageForceImage:YES allowList:nil];
}

static int i = 0;
static NSInteger lastUnread = 0;

- (void)receiveTimeUpdate:(NSNotification *)notification
{
    if ( !self.viewHasAppear && !_foreground )
    {
        return;
    }
    
    i ++;
//      每三十秒处理一次
    if (i % 30 == 0) {
        [self.engine GETMessageunreadcountStart:0 start:^{
            
        } fail:^(NSError *error) {
            
        } success:^(id messageData) {
            NSDictionary *dic = nil;
            if ([messageData isKindOfClass:[NSDictionary class]]) {
                dic = (NSDictionary *)messageData;
            }
            NSInteger unread = [[dic objectForKey:@"unread"] integerValue];
            
            NSString *unreadStr = [NSString stringWithFormat:@"%ld",unread];
            // 当此次未读数跟上次未读数不一样时,发送刷新列表的通知
            if ( unread != lastUnread ) {

                [EVNotificationCenter postNotificationName:EVShouldUpdateNotifyUnread object:unreadStr];
            }
            lastUnread = unread;
        }];
    }
}

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (void)startChatWithName:(NSString *)name
{
    __weak typeof(self) wself = self;
    [self.engine GETBaseUserInfoWithUname:name orImuser:nil start:^{
        [EVProgressHUD showMessage:kLChatRoom toView:wself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showError:kFailNetworking toView:wself.view];
    } success:^(NSDictionary *modelDict) {
        [EVProgressHUD hideHUDForView:wself.view];
//        [wself startChatWithUserModel:[EVUserModel objectWithDictionary:modelDict]];
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:wself.view];
        EVRelogin(wself);
    }];
}

//- (void)startChatWithUserModel:(EVUserModel *)userModel
//{
//    if ( userModel.imuser == nil )
//    {
//        [EVProgressHUD showError:kFailChat];
//        return;
//    }
//    EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
//    conversationItem.userModel = userModel;
//    conversationItem.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userModel.imuser conversationType:eConversationTypeChat];
//    EVChatViewController *chatVC = [[EVChatViewController alloc] init];
//    chatVC.conversationItem = conversationItem;
//    UINavigationController *nav = self.selectedViewController;
//    [nav pushViewController:chatVC animated:YES];
//}

- (void)configView
{
    EVHomeTabbarContainer *containerView = [[EVHomeTabbarContainer alloc] init];
    [self setValue:containerView forKey:@"tabBar"];
    containerView.tabbar.delegate = self;
    self.homeTabbar = containerView;
    
    self.view.backgroundColor = [UIColor evBackgroundColor];
}

- (UIButton *)getmenuButtonWithIconImage:(NSString *)iconImage
{
    UIButton *titleEditButton = [[UIButton alloc] init];
    [titleEditButton setImage:[UIImage imageNamed:iconImage] forState:UIControlStateNormal];
    return titleEditButton;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    self.homeTabbar.selectedIndex = selectedIndex;
}

#pragma mark - CCHomeTabbarDelegate
- (void)homeTabbarDidClicked:(EVHomeTabbarButtonType)btn
{
    self.selectedIndex = btn;
}

- (void)homeTabbarDidClickedLiveButton
{
    [self startLive];
}

- (void)startLive
{
    [EVStreamer    checkAndRequestMicPhoneAndCameraUserAuthed:^{
        [self _homeTabBarLiveButtonDidClicked:nil];
    } userDeny:nil];
}

//点击直播按钮,不检查授权
- (void)_homeTabBarLiveButtonDidClicked:(UIView *)tabBar
{
    if ( ![EVBaseToolManager userHasLoginLogin] )
    {
        if ([EVAppSetting shareInstance].isLogining)  return;
        
        EVLoginViewController *loginVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }

    [self requestNormalLivingPageForceImage:NO allowList:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    CGFloat height = 50;
//    CGRect frame = self.tabBar.frame;
//    frame.size.height = height;
//    frame.origin.y = self.view.frame.size.height - height;
//    self.tabBar.frame = frame;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewHasAppear = YES;
    [EVAppSetting shareInstance].appstate = EVEasyvaasAppStateDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewHasAppear = NO;
}

#pragma mark - 开始普通直播
- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
{
 
    [self requestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:NO];

}

- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
                                audioOnly:(BOOL)audioOnly
{
    
    [self requestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:audioOnly delegate:self];
}

// 直播需要绑定手机, 请监听改回调
- (void)liveNeedToBindPhone:(EVLiveViewController *)liveVC
{
    EVAccountPhoneBindViewController *phoneBindVC = [EVAccountPhoneBindViewController accountPhoneBindViewController];
    EVRelationWith3rdAccoutModel *model = [[EVRelationWith3rdAccoutModel alloc] init];
    model.type = @"phone";
    [self presentViewController:phoneBindVC animated:YES completion:nil];
}

- (void)liveNeedToRelogin:(EVLiveViewController *)liveVC
{
    EVRelogin(self);
}

- (void)liveDidStart:(EVLiveViewController *)liveVC info:(NSDictionary *)info
{
    
}


- (void)reLogin
{
    __weak typeof(self) wself = self;
    [CCUserDefault removeObjectForKey:SESSION_ID_STR];
    [EVBaseToolManager checkSession:^{
        [EVProgressHUD showMessage:@"" toView:wself.view];
    } completet:^(BOOL expire) {
        [EVProgressHUD hideHUDForView:wself.view];
        if ( expire )
        {
            EVRelogin(wself);
        }
        else
        {
            [wself reloginIm];
        }
        [EVBaseToolManager resetSession];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showError:kNoNetworking toView:wself.view];
    }];
}

- (void)reloginIm
{
 //   __weak typeof(self) wself = self;
//    [EVEaseMob checkAndAutoReloginWithLoginInfo:nil imHasLogin:^(EVLoginInfo *loginInfo) {
//    } loginSuccess:^(EVLoginInfo *login) {
//    } loginFail:^(EMError *error) {
//        [EVProgressHUD showError:[NSString stringWithFormat:@"%@%ld",kNoNetworking, error.errorCode] toView:wself.view];
//    } sessionExpire:^{
//        [EVProgressHUD showError:kNoNetworking toView:wself.view];
//    } needRegistIM:^{
//        [EVProgressHUD showError:kNoNetworking toView:wself.view];
//    }];
}

- (void)showHomeTabbarWithAnimation
{
    [self.homeTabbar showTabbarWithAnimation];
}

- (void)hideHomeTabbarWithAnimation
{
    [self.homeTabbar hideTabbarWithAnimation];
}

@end
