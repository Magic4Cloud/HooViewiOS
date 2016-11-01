//
//  EVNotifyViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotifyViewController.h"
#import "EVNotifyViewCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVNotifyListViewController.h"
#import "EVNewFriendViewController.h"
#import "EVNotifyConversationItem.h"
#import <PureLayout.h>
#import "EVLoginInfo.h"
#import "EVAlertManager.h"
#import "AppDelegate.h"
#import "EVUserModel.h"
#import "EVMineViewController.h"
#import "EVChatViewController.h"
#import "EVNetWorkStateManger.h"
#import "UIScrollView+GifRefresh.h"
#import "EVLoadingView.h"
#import "NSObject+Extension.h"
#import "EVNavigationController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVBaseToolManager+EVMessageAPI.h"
#import "EVChooseGroupMemberViewController.h"
#import "EVMyGroupListViewController.h"
#import "EVGroupChatViewController.h"

// 一次从数据库请求的数据条数
#define kNotifyRequestCountOnce 30

#define kIMuserInfoMaxTryCount 5

const NSString *const notifyCellID = @"notifylist";

@interface EVNotifyViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,CCChatViewControllerDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;//所有消息列表
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, assign) NSInteger unread;
@property (nonatomic,weak) UIView *navigationBarRightView;
@property ( weak, nonatomic ) EVLoadingView *loadingView;
@property (weak, nonatomic) UIButton *personalButton;
@property ( strong, nonatomic ) UIBarButtonItem *leftBarButtonItem;
@property ( weak, nonatomic ) UIView *clearView;

@property (nonatomic, assign) NSInteger imuserInfoTryCount; /** 检查私信帐号最大尝试次数 = 5 */

@end

@implementation EVNotifyViewController

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    _messages = nil;
    [CCNotificationCenter removeObserver:self];
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUptable];
    [self setUpNotification];
    [self updateUnreadSecretaryAndNewFriends];
    [self reloadMessage];
    
    [self resolveOfflineMessages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 检查是否注册
    if ( [EVLoginInfo localObject].imuser == nil )
    {
        [self checkIMLoginInfo];
    }
//  每次进入页面重新计算未读消息数
    [self calculateUnread];
    [self.tableView reloadData];
    [self addLeftBarButtonItem];
}

#pragma mark - UI

- (UIView *)addHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 11.5)];
    
    UIView * topDiv = [UIView newAutoLayoutView];
    [headerView addSubview:topDiv];
    
    [topDiv autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView withOffset:0];
    [topDiv autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView withOffset:0];
    [topDiv autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView withOffset:0];
    
    [topDiv autoSetDimension:ALDimensionHeight toSize:0.7];
    
    UIView * bottomDiv = [UIView newAutoLayoutView];
    [headerView addSubview:bottomDiv];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [bottomDiv autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [bottomDiv autoSetDimension:ALDimensionHeight toSize:0.7];
    
    return headerView;
}
/**设置UI*/
-(void)setUptable
{
    self.title = kE_GlobalZH(@"message");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc] init];
    tableView.tableHeaderView = [self addHeaderView];
    tableView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:tableView];
    [tableView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //加载xib
    [tableView registerNib:[UINib nibWithNibName:@"EVNotifyViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)notifyCellID];
    
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"launch_group_chat") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
    [rightBarBtnItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15.0],UITextAttributeTextColor:[UIColor whiteColor]} forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

- (void) addLeftBarButtonItem
{
    if (self.leftBarButtonItem == nil)
    {
        UIButton *personalButton = [[UIButton alloc] init];
        personalButton.frame = CGRectMake(10.f, 10.f, 30.f, 30.f);
        [personalButton addTarget:self action:@selector(navLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.personalButton = personalButton;
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:personalButton];
        //
        personalButton.imageView.layer.cornerRadius = 30 * 0.5;
        personalButton.imageView.clipsToBounds = YES;
        CGFloat offset = 10;
        if ( ScreenWidth <= 375 )
        {
            offset = 6;
        }
        personalButton.contentEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
        self.leftBarButtonItem = leftBarButtonItem;
    }
    //修改  杨尚彬   以前的毛病换图片不会加载
    [self.personalButton cc_setImageURL:[EVLoginInfo localObject].logourl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_user_icon_placeholder"]];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
}

- (void)rightBarBtnClick
{
    CCLog(@"发起群聊");
    EVChooseGroupMemberViewController *chooseGroupVC = [[EVChooseGroupMemberViewController alloc]init];
    [chooseGroupVC setDismissCompletion:^(EMGroup *newGroup,NSArray *members) {
        
        EVGroupChatViewController *chatVC = [[EVGroupChatViewController alloc] init];
        chatVC.chatter = newGroup.groupId;
        CCLog(@"####-----%d,----%s-----%@-id = %@--####",__LINE__,__FUNCTION__,newGroup,newGroup.groupId);
//        chatVC.isGroup = YES;
        chatVC.members = members;
        [self.navigationController pushViewController:chatVC animated:YES];
    }];
    EVNavigationController *navi = [[EVNavigationController alloc] initWithRootViewController:chooseGroupVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)navLeftButtonAction
{
    EVMineViewController *mineVC = [[EVMineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}


- (void)findFriend
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    EVUserModel *user = [EVUserModel getUserInfoModelFromLoginInfo:loginInfo];
    
    if ( !user )
    {
        return;
    }

}

#pragma mark - 
#pragma mark - 注册通知和处理的方法
//  注册通知
- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(imHasLogin) name:CCIMAccountHasLoginNotifcation object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(conversationHasRead:) name:CCIMConversationHasReadNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveShouldUpdateUnread) name:CCShouldUpdateNotifyUnread object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveClean) name:CCSessionDidCleanFromLocalNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveNetWorkChange:) name:CCNetWorkChangeNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveRemarkChange:) name:kEditedRemarkNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(receiveUserInfoChange:) name:CCLoginPageDidDissmissNotification object:nil];
}

//  处理网络变化的通知
- (void)receiveNetWorkChange:(NSNotification *)notification
{
    NSNumber *statusNumber = [notification.userInfo objectForKey:CCNetWorkStateKey];
    CCNetworkStatus status = [statusNumber integerValue];
    if (status != WithoutNetwork) {
        //  注册环信消息管理者代理
        [EVEaseMob setChatManagerDelegate:self];
        [self updateUnreadSecretaryAndNewFriends];
    }
}

//  处理退出登录的通知
- (void)receiveClean
{
    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    self.messages = nil;
    if (!error && info) {
        CCLog(@"退出成功");
        //  将私信登录设置为未登录
        [EVBaseToolManager setIMAccountHasLogin:NO];
    }
}
//  处理未读消息数变化的通知
- (void)receiveShouldUpdateUnread
{
    [self updateUnreadSecretaryAndNewFriends];
}

// 处理备注改变的通知
- (void)receiveRemarkChange:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    NSString *name = [dic objectForKey:kNameKey];
    for (EVNotifyItem *item in self.messages) {
        if ( ![item isKindOfClass:[EVNotifyConversationItem class]] )
        {
            continue;
        }
        EVNotifyConversationItem *converItem = (EVNotifyConversationItem *)item;
        if ( ![name isEqualToString:converItem.userModel.name] )
        {
            continue;
        }
        [self fillWithConversationItem:converItem start:nil fail:nil complete:^{
            [self.tableView reloadData];
            
            //  缓存到本地
            [converItem updateToLocalCacheComplete:nil];
        }];
    }
}

//  处理会话消息被阅读的通知
- (void)conversationHasRead:(NSNotification *)notification
{
    EVNotifyConversationItem *item = notification.userInfo[CCIMConversationModelKey];
    if ( [item isKindOfClass:[EVNotifyConversationItem class]] )
    {
        NSInteger index  = 1;
        index = [self.messages indexOfObject:item];
        if ( index < 0 || index > (NSInteger)self.messages.count - 1 )
        {
            return;
        }
        
        item = self.messages[index];
        [item.conversation markAllMessagesAsRead:YES];
        item.unread = 0;
        [self.tableView reloadData];
    }
}
//  处理环信登录成功的通知
- (void)imHasLogin
{
    [self updateUnreadSecretaryAndNewFriends];
    [self reloadMessage];

}

- (void)receiveUserInfoChange:(NSNotification *)notification
{
//    [self checkIMLoginInfo];
    [self updateUnreadSecretaryAndNewFriends];
    NSString *logourl = [EVLoginInfo localObject].logourl;
    [self.personalButton cc_setImageURL:logourl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];

}

- (void)receiveChatGroupTotalUnreadChanged
{
//    self.groupItem.unread = [CCChatMessageManager shareInstance].groupUnreadCount;
    [self.tableView reloadData];
}

#pragma mark - 刷新消息
//  刷新私信消息
- (void)reloadMessage
{
    //  注册环信消息管理者代理
    [EVEaseMob setChatManagerDelegate:self];
    [self loadMessageListFromLocalStart:0 count:kNotifyRequestCountOnce];
    
    //  添加上拉加载更多
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        [weakSelf loadMessageListFromLocalStart:(NSInteger)weakSelf.messages.count -4 count:kNotifyRequestCountOnce];
    }];

    if ([EVBaseToolManager imAccountHasLogin] == NO)
    {
        [self checkIMLoginInfo];
    }
}
//  更新小秘书和新朋友的未读消息数
- (void)updateUnreadSecretaryAndNewFriends
{
    //发送请求
    __weak typeof(self) weakSelf = self;
    [self.engine GETMessagegrouplistStart:^{
    } fail:^(NSError *error) {
        if ( error.userInfo[kCustomErrorKey] ){
        } else {
            CCLog(@"更新未读信息失败");
        }
        [weakSelf calculateUnread];
        [weakSelf.tableView reloadData];
    } success:^(NSDictionary *messageData) {
        id groups = messageData[@"groups"];
        if ( [groups isKindOfClass:[NSArray class]] )
        {
            NSArray *messageGroupsTemp = (NSArray *)groups;
            NSArray *messageGroups = [EVNotifyItem objectWithDictionaryArray:messageGroupsTemp];
            for (int i = 0; i < 2; i++) {
                EVNotifyItem *item = messageGroups[i];
                if (i == 1) {
                    [weakSelf.messages replaceObjectAtIndex:0 withObject:item];
                }else {
                     [weakSelf.messages replaceObjectAtIndex:1 withObject:item];
                }
                [weakSelf calculateUnread];
                [weakSelf.tableView reloadData];
            }
          
            
        }
    } sessionExpired:^{
        CCRelogin(weakSelf);
    } ];
}

//  从服务器获取私信列表
- (void)loadMessageList
{
    //  获取会话列表
    __weak typeof(self) wself = self;
    NSArray *conversationsArray = [EVEaseMob allSortedConversationsUsingCompare:^NSComparisonResult(EMConversation *conver1, EMConversation *conver2) {
        EMMessage *msg1 = conver1.latestMessage;
        EMMessage *msg2 = conver2.latestMessage;
        long long time1 = msg1.timestamp;
        long long time2 = msg2.timestamp;
        NSNumber *t1 = [NSNumber numberWithLongLong:time1];
        NSNumber *t2 = [NSNumber numberWithLongLong:time2];
        return [t2 compare:t1];
    }];
    for (EMConversation *conversation in conversationsArray) {
        if ( [[conversation.latestMessage.messageBodies lastObject] messageBodyType] < 1 )
        {
            continue;
        }
        EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
        conversationItem.conversation = conversation;
        if ( ![wself.messages containsObject:conversationItem] )
        {
            [wself.messages addObject:conversationItem];
            [wself fillWithConversationItem:conversationItem start:nil fail:nil complete:^{
                [wself.tableView reloadData];
                //  缓存到本地
                [conversationItem updateToLocalCacheComplete:nil];
            }];
        }
        else
        {
            //  如果有替换成最新的
            NSInteger index = [wself.messages indexOfObject:conversationItem];
            EVNotifyConversationItem *item = [wself.messages objectAtIndex:index];
            item.conversation = conversation;
        }
    }
    [self.tableView reloadData];
}


//  从本地缓存中获取私信列表
- (void)loadMessageListFromLocalStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) weakSelf = self;
    [EVNotifyConversationItem getConversationArrayFromDBStart:start count:count complete:^(NSArray *result) {
        // 停止刷新
        [weakSelf.tableView endFooterRefreshing];
        
        if ( result.count < count )
        {
            [weakSelf.tableView setFooterState:CCRefreshStateNoMoreData];
        }
        else
        {
            [weakSelf.tableView setFooterState:CCRefreshStateIdle];
        }
        NSInteger index = 0;
        for (EVNotifyConversationItem *item in result)
        {
            index ++;
            if ( ![weakSelf.messages containsObject:item] ) {
                
                if ( item.name == nil )
                {
                    [weakSelf fillWithConversationItem:item start:nil fail:nil complete:^{
                        [weakSelf.messages addObject:item];
                        if ( index == result.count )
                        {
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
                else
                {
                    [weakSelf.messages addObject:item];
                }
            }
        }
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 计算未读消息数

- (void)calculateUnread
{
    NSInteger unread = 0;
    for (EVNotifyItem *item in self.messages) {
        unread += item.unread;
    }
    [self setUnread:unread];
}

- (void)setUnread:(NSInteger)unread
{
    if (unread < 0) {
        unread = 0;
    }
    if ((BOOL)_unread != (BOOL)unread)
    {
        [CCNotificationCenter postNotificationName:CCScretLetterRedPointShowNotification object:nil userInfo:@{CCShowRedPoint : @((BOOL)unread)}];
    }
    _unread = unread;
}

#pragma mark - getter

- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray array];
        //  易视云小秘书
        EVNotifyItem *secretaryItem = [[EVNotifyItem alloc] init];
        secretaryItem.title = kE_GlobalZH(@"easyvaas_secretary");
        secretaryItem.icon = @"message_my_secretary";
        [_messages addObject:secretaryItem];
        //  新朋友
        EVNotifyItem *friendItem = [[EVNotifyItem alloc] init];
        friendItem.icon = @"message_my_new";
        friendItem.title = kE_GlobalZH(@"new_Friend");
        friendItem.content = kE_GlobalZH(@"many_friend_follow");
//        friendItem.groupid = @"1";
        [_messages addObject:friendItem];
        
        //  群组
        EVNotifyItem *groupItem = [[EVNotifyItem alloc] init];
        groupItem.icon = @"message_my_group";
        groupItem.title = kE_GlobalZH(@"el_my_group");
//        groupItem.content = kE_GlobalZH(@"many_friend_follow");
//        groupItem.groupid = @"1";
        [_messages addObject:groupItem];
        
    }
    return _messages;
}


- (EVBaseToolManager *)engine {
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (EVLoadingView *)loadingView
{
    if ( _loadingView == nil )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] init];
        [self.view addSubview:loadingView];
        [loadingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.loadingView = loadingView;
    }
    return _loadingView;
}


#pragma mark - table view delegate & data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 75;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //  从数据库中删除当前会话
        EVNotifyConversationItem *item = [self.messages objectAtIndex:indexPath.row];
        NSString *chatter = item.conversation.chatter;
        [[EVEaseMob cc_shareInstance].chatManager removeConversationByChatter:chatter deleteMessages:NO append2Chat:YES];
        [item deleteFromLocalCacheComplete:nil];
        if ( [self.messages containsObject:item] )
        {
            [self.messages removeObject:item];
            [self calculateUnread];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNotifyViewCell *cell = [EVNotifyViewCell notifyViewCell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ( self.messages.count > indexPath.row )
    {
        EVNotifyItem *model = self.messages[indexPath.row];
        cell.cellItem = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNotifyItem *item = [self.messages objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        //  小秘书
        EVNotifyListViewController *notiflast = [[EVNotifyListViewController alloc]init];
        notiflast.hidesBottomBarWhenPushed = YES;
        notiflast.notiItem = item;
        [self.navigationController pushViewController:notiflast animated:YES];
        item.unread = 0;
    }else if (indexPath.row == 1)
    {
        //  新朋友
        EVNewFriendViewController *friendVC = [[EVNewFriendViewController alloc] init];
        friendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendVC animated:YES];
        friendVC.notiItem = item;
        item.unread = 0;
    }
    else if (indexPath.row == 2)
    {
        EVMyGroupListViewController *myGroupList = [[EVMyGroupListViewController alloc]init];
        [self.navigationController pushViewController:myGroupList animated:NO];
    }
    else
    {
        //  私信
        if ([item isKindOfClass:[EVNotifyConversationItem class]])
        {
            EVNotifyConversationItem *conversationItem = (EVNotifyConversationItem *)item;
            if ( conversationItem.imuser == nil )
            {
                [CCProgressHUD showError:kFailChat];
                return;
            }
            EVChatViewController *chatVC = [[EVChatViewController alloc] init];
            chatVC.conversationItem = conversationItem;
            chatVC.delegate = self;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }
}

#pragma mark - 环信 delegate
// fix by 杨尚彬 测试线程同步问题
//  收到消息
- (void)didReceiveMessage:(EMMessage *)message
{
    [self handleMessage:message currMessage:self.messages];
}
//  收到离线消息
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        [self handleMessage:message currMessage:self.messages];
    }
}
//  消息已发送
- (void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self handleMessage:message currMessage:self.messages];
}

#pragma mark - 聊天页的代理方法

- (void)chatViewController:(EVChatViewController *)chatVC didDeleteLastMessage:(EMMessage *)lastMessage
{
    if ( lastMessage )
    {
        [chatVC.conversationItem setLastMessage:lastMessage];
    }
}

#pragma mark - 处理在CCHomeViewController没有处理的离线消息
- (void)resolveOfflineMessages
{
    if ( [self.tabBarController isKindOfClass:[EVHomeViewController class]] )
    {
        if ( 3 == self.messages.count )
        {
            [self.loadingView showLoadingView];
        }
        __weak typeof(self) weakSelf = self;
        EVHomeViewController *homeVC = (EVHomeViewController *)self.tabBarController;
        if ( ![homeVC isKindOfClass:[EVHomeViewController class]] )
        {
            return;
        }

        NSArray *messages = [NSArray arrayWithArray:self.messages];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (EMMessage *message in [homeVC.allMessages copy]) {
                [weakSelf handleMessage:message currMessage:messages];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loadingView destroy];
                [weakSelf.tableView reloadData];
            });
        });
    }
}


#pragma mark - 处理收到或发出的消息

- (void)handleMessage:(EMMessage *)message
          currMessage:(NSArray *)currMessage
{
    
    if ( [message.from isEqualToString:message.to] )
    {
        return;
    }
    
    if ( message.messageType != eMessageTypeChat )
    {
        return;
    }
    
    //  获取当前的用户名
    NSString *currentIMUser = [EVLoginInfo localObject].imuser;
    if ( currentIMUser == nil )
    {
        currentIMUser = [[EVEaseMob cc_shareInstance] currentUserName];
    }
    
    if ( currentIMUser == nil )
    {
        
        return;
    }
    
    //  如果是发送出去的消息,将会话chatter设置成to,否则设置成from,这里设置错误会引起自己跟自己聊天
    NSString *chatter = [currentIMUser isEqualToString:message.from] ? message.to : message.from;
    EMConversation *conversation = [[EVEaseMob cc_shareInstance].chatManager conversationForChatter:chatter
                                                                                   conversationType:eConversationTypeChat];
    
    NSMutableArray *newMessage = [NSMutableArray arrayWithArray:currMessage];
    
    NSInteger i = 0;
    for (; i < currMessage.count ; i++)
    {
        EVNotifyItem *item = [currMessage objectAtIndex:i];
        if ([item isKindOfClass:[EVNotifyConversationItem class]])
        {
            EVNotifyConversationItem *conversationItem = (EVNotifyConversationItem *)item;
            if (![conversation.chatter isEqualToString:conversationItem.conversation.chatter])
            {
                continue;
            }
            
            //  将当前会话信息设置成最新的
            conversationItem.conversation = conversation;
            
            //  将新消息排到第三位
            [newMessage removeObject:conversationItem];
            [newMessage insertObject:conversationItem atIndex:3];
            [conversationItem updateToLocalCacheComplete:nil];
            break;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self performBlockOnMainThread:^{
        weakSelf.messages = newMessage;
        [weakSelf.tableView reloadData];
    }];
    
    //  如果没有该会话 添加到会话列表
    if ( i == currMessage.count )
    {
        EVNotifyConversationItem *conversationItem = [[EVNotifyConversationItem alloc] init];
        conversationItem.conversation = conversation;
        
        //  将新来的消息排到第四位
        [newMessage insertObject:conversationItem atIndex:3];
        
        //  第一次需要获取userModel 否则头像和名字可能为空
        
        [self fillWithConversationItem:conversationItem
                                 start:nil
                                  fail:^
         {
             CCLog(@"获取用户消息失败");
             [weakSelf.tableView reloadData];
         }
                              complete:^
         {
             weakSelf.messages = newMessage;
             [weakSelf.tableView reloadData];
             [conversationItem updateToLocalCacheComplete:nil];
             
         }];
    }
    
    //  计算未读消息数
    [self performBlockOnMainThread:^{
        [weakSelf calculateUnread];
        
        if ( message.from != currentIMUser )
        {
            //  下载消息附件
            [weakSelf downloadMessageAttachments:message];
        }
    }];
    
    // 删除主页的数组
    EVHomeViewController *homeVC = (EVHomeViewController *)self.tabBarController;
    if ( [homeVC isKindOfClass:[EVHomeViewController class]] )
    {
        [homeVC.allMessages removeAllObjects];
    }
}

// 下载消息附件
- (void)downloadMessageAttachments:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ( [messageBody conformsToProtocol:@protocol(IEMFileMessageBody)] )
    {
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
    }
}

//  匹配环信号和云播号

- (void)fillWithConversationItem:(EVNotifyConversationItem *)item
                           start:(void(^)())start
                            fail:(void(^)())fail
                        complete:(void(^)())complete
{
    if ( start )
    {
        start();
    }
    __weak typeof(self) weakSelf = self;

    [EVUserModel getUserInfoModelWithIMUser:item.conversation.chatter
                                   complete:^(EVUserModel *model)
     {
        if ( model )
        {
            item.userModel = model;
            [weakSelf.tableView reloadData];
            if ( complete )
            {
                complete();
            }
        }
        else
        {
            __weak typeof(self) wself = self;
            [weakSelf.engine GETBaseUserInfoWithUname:nil
                                  orImuser:item.conversation.chatter
                                     start:nil
                                      fail:^(NSError *error)
            {
                if ( fail )
                {
                    fail();
                }
            }
                                   success:^(NSDictionary *modelDict)
            {
                EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
                [model updateToLocalCacheComplete:nil];
                item.userModel = model;
                if ( complete )
                {
                    complete();
                }
            } sessionExpire:^{
                CCRelogin(wself);
            }];
        }
    }];
}

#pragma mark - 其他(或许没什么卵用)

- (void)didLoginFromOtherDevice
{
    __weak typeof(self) weakSelf = self;
    [CCUserDefault setObject:nil forKey:SESSION_ID_STR];
    [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kAccountOtherDeviceLogin cancelButtonTitle:kCancel comfirmTitle:kAgainLogin WithComfirm:^{
        [EVLoginInfo cleanLoginInfo];
        [EVBaseToolManager resetSession];
        [weakSelf reLogin];
    } cancel:nil];
}
- (void)checkIMLoginInfo
{
    if ( [EVLoginInfo localObject].imuser == nil )
    {
        __weak typeof(self) weakSelf = self;
//        [self.engine GETUseriminfoStart:nil fail:^(NSError *error) {
//            
//        } success:^(NSDictionary *imInfo) {
//            CCLoginIMInfo *imloginInfo = [CCLoginIMInfo objectWithDictionary:imInfo];
//            EVLoginInfo *info = [EVLoginInfo localObject];
//            info.imuser = imloginInfo.username;
//            info.impwd = imloginInfo.password;
//            [info synchronized];
//            [weakSelf checkWithInfo:info];
//            
//        } sessionExpire:^{
//            
//        }];
    }
    else
    {
        [self checkWithInfo:nil];
    }
}

- (void)checkWithInfo:(EVLoginInfo *)info
{
    __weak typeof(self) wself = self;
    [EVEaseMob checkAndAutoReloginWithLoginInfo:info imHasLogin:^(EVLoginInfo *loginInfo) {
        
    } loginSuccess:^(EVLoginInfo *login) {
        [wself imHasLogin];
    } loginFail:^(EMError *error) {
        
    } sessionExpire:^{
        CCRelogin(wself);
    } needRegistIM:^{
        if ( wself.imuserInfoTryCount < kIMuserInfoMaxTryCount )
        {
            [wself notityRegistIM];
        }
        
    }];
}

- (void)notityRegistIM
{
    _imuserInfoTryCount++;
    __weak typeof(self) wself = self;
    EVLoginInfo *login = [EVLoginInfo localObject];
//    [self.engine GETUseriminfoStart:^{
//    } fail:^(NSError *error) {
//        [CCProgressHUD showError:kFailNetworking toView:wself.view];
//    } success:^(NSDictionary *imInfo) {
//        NSString *imuser = imInfo[kImuser];
//        NSString *impwd = imInfo[kImpwd];
//        if ( ![imuser isKindOfClass:[NSNull class]]
//            && ![impwd isKindOfClass:[NSNull class]] )
//        {
//            login.imuser = imInfo[kImuser];
//            login.impwd = imInfo[kImpwd];
//            [login synchronized];
//        }
//    } sessionExpire:^{
//        CCRelogin(wself);
//    }];
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
        [CCUserDefault setObject:nil forKey:SESSION_ID_STR];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
//        [CCProgressHUD showError:kNoNetworking toView:wself.view];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
