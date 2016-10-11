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
#import "EVEaseMob.h"
#import "AppDelegate.h"
#import "EVChatViewController.h"
#import "EVNotifyConversationItem.h"
#import "EVStreamer.h"
#import "UIViewController+Extension.h"
#import "EVHomeTabbar.h"
#import "EVStreamer+Extension.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVBaseToolManager+EVMessageAPI.h"


#define kPushHotController  @"pushHotController"

@interface EVHomeViewController () <CCHomeTabbarDelegate ,CCLiveViewControllerDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) NSArray *items;

@property (nonatomic,weak) UIImageView *indexImageView;
@property (nonatomic, assign) BOOL showIndexImageView;

@property (strong, nonatomic) EVBaseToolManager *engine;

@property (nonatomic, assign) BOOL viewHasAppear;

@property (nonatomic,weak) CCHomeTabbarContainer *homeTabbar;

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
    CCLog(@"CCHomeViewController dealloc");
    [CCNotificationCenter removeObserver:self];
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

    [self configView];
    [self setUpNotification];
    [self setUpIM];
    [self getStartResourceTool];
}

- (void)getStartResourceTool
{
    // 下载点赞图片
    [[EVStartResourceTool shareInstance] loadData];
}

- (void)setUpIM
{
    [EVEaseMob setChatManagerDelegate:self];
}


#pragma mark - EMChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [EVEaseMob checkApplicationStateWithMessage:message];
    [self.allMessages addObject:message];
    // 判断是否需要显示小红点
    if ( self.allMessages.count > 0 )
    {
        self.homeTabbar.showRedPoint = YES;
    }
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        [self.allMessages addObject:message];
    }
    // 判断是否需要显示小红点
    if ( self.allMessages.count > 0 )
    {
        self.homeTabbar.showRedPoint = YES;
    }
}

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
    [CCNotificationCenter addObserver:self selector:@selector(shouldShowRedPointOnTabBar:) name:CCScretLetterRedPointShowNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveTimeUpdate:) name:CCUpdateForecastTime object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
 
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

- (void)receiveTimeUpdate:(NSNotification *)notification
{
    if ( !self.viewHasAppear && !_foreground )
    {
        return;
    }
    static int i = 0;
    static NSInteger lastUnread = 0;
    i ++;
    //  每三十秒处理一次
    if (i % 30 == 0) {
        [self.engine GETMessageunreadcountStart:0 start:^{
            
        } fail:^(NSError *error) {
            
        } success:^(id messageData) {
// fix by 杨尚彬 id 类型不明确
            NSDictionary *dic = nil;
            if ([messageData isKindOfClass:[NSDictionary class]]) {
                dic = (NSDictionary *)messageData;
            }
            NSInteger unread = [[dic objectForKey:@"unread"] integerValue];
            
            self.homeTabbar.showRedPoint = unread != 0;
            
            // 当此次未读数跟上次未读数不一样时,发送刷新列表的通知
            if ( unread != lastUnread ) {

                [CCNotificationCenter postNotificationName:CCShouldUpdateNotifyUnread object:nil];
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
        [CCProgressHUD showMessage:kLChatRoom toView:wself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:kFailNetworking toView:wself.view];
    } success:^(NSDictionary *modelDict) {
        [CCProgressHUD hideHUDForView:wself.view];
        [wself startChatWithUserModel:[EVUserModel objectWithDictionary:modelDict]];
    } sessionExpire:^{
        [CCProgressHUD hideHUDForView:wself.view];
        CCRelogin(wself);
    }];
}

- (void)startChatWithUserModel:(EVUserModel *)userModel
{
    if ( userModel.imuser == nil )
    {
        [CCProgressHUD showError:kFailChat];
        return;
    }
    EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
    conversationItem.userModel = userModel;
    conversationItem.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userModel.imuser conversationType:eConversationTypeChat];
    EVChatViewController *chatVC = [[EVChatViewController alloc] init];
    chatVC.conversationItem = conversationItem;
    UINavigationController *nav = self.selectedViewController;
    [nav pushViewController:chatVC animated:YES];
}

- (void)configView
{
    CCHomeTabbarContainer *containerView = [[CCHomeTabbarContainer alloc] init];
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
- (void)homeTabbarDidClicked:(CCHomeTabbarButtonType)btn
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
        if ([CCAppSetting shareInstance].isLogining)  return;
        
        UINavigationController *navCon = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navCon animated:YES completion:nil];
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
    CGFloat height = tabBarRealHeight;
    CGRect frame = self.tabBar.frame;
    frame.size.height = height;
    frame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewHasAppear = YES;
    [CCAppSetting shareInstance].appstate = CCEasyvaasAppStateDefault;
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
    CCRelogin(self);
}

- (void)liveDidStart:(EVLiveViewController *)liveVC info:(NSDictionary *)info
{
    [CCNotificationCenter postNotificationName:CCRequestStartLiveFinishNotification object:nil userInfo:info];
}

- (void)didLoginFromOtherDevice
{
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kAccountOtherDeviceLogin cancelButtonTitle:kCancel comfirmTitle:kAgainLogin WithComfirm:^{
        [EVLoginInfo cleanLoginInfo];
        [EVBaseToolManager resetSession];
        [self reLogin];
    } cancel:^{
        [EVLoginInfo cleanLoginInfo];
        [EVBaseToolManager resetSession];
    }];
}

- (void)reLogin
{
    __weak typeof(self) wself = self;
    [EVBaseToolManager checkSession:^{
        [CCProgressHUD showMessage:@"" toView:wself.view];
    } completet:^(BOOL expire) {
        [CCProgressHUD hideHUDForView:wself.view];
        if ( expire )
        {
            CCRelogin(wself);
        }
        else
        {
            [wself reloginIm];
        }
        [EVBaseToolManager resetSession];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:kNoNetworking toView:wself.view];
    }];
}

- (void)reloginIm
{
    __weak typeof(self) wself = self;
    [EVEaseMob checkAndAutoReloginWithLoginInfo:nil imHasLogin:^(EVLoginInfo *loginInfo) {
    } loginSuccess:^(EVLoginInfo *login) {
    } loginFail:^(EMError *error) {
        [CCProgressHUD showError:[NSString stringWithFormat:@"%@%ld",kNoNetworking, error.errorCode] toView:wself.view];
    } sessionExpire:^{
        [CCProgressHUD showError:kNoNetworking toView:wself.view];
    } needRegistIM:^{
        [CCProgressHUD showError:kNoNetworking toView:wself.view];
    }];
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
