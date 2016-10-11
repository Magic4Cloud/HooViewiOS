//
//  EVMyGroupListViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMyGroupListViewController.h"
#import <PureLayout.h>
#import "EVNotifyItem.h"
#import "EVNotifyViewCell.h"
#import "EVEaseMob.h"
#import "EVChooseGroupMemberViewController.h"
#import "EVChatMessageManager.h"
#import "UIBarButtonItem+CCNavigationRight.h"
#import "EVNavigationController.h"
#import "EVFriendItem.h"
#import "MBProgressHUD.h"
#import "EVGroupChatViewController.h"

#define kNSDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@interface EVMyGroupListViewController ()<UITableViewDataSource,UITableViewDelegate,EVChatViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property ( strong, nonatomic ) NSMutableArray *groupsArray;


@end

@implementation EVMyGroupListViewController

- (void)dealloc
{
    [[EVChatMessageManager shareInstance] clearGroupItems];
    [CCNotificationCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setupNotification];
    WEAK(self)
    // 如果上次初始化结束但是没有成功就重新初始化
//    if ( [CCChatMessageManager shareInstance].sucssedGetGroupItems == NO && [CCChatMessageManager shareInstance].finishGetGroupItems == YES)
//    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[EVChatMessageManager shareInstance] initialGroupItemsLatest:YES completion:^{
            [weakself.groupsArray removeAllObjects];
            weakself.groupsArray = [[EVChatMessageManager shareInstance].allGroupItems mutableCopy];
            [hud hide:YES];
            [self.tableView reloadData];
        }];
//    }else{
//        [weakself.groupsArray removeAllObjects];
//        weakself.groupsArray = [[CCChatMessageManager shareInstance].allGroupItems mutableCopy];
//        [self.tableView reloadData];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self fetchGroupList];
}

- (void)setupNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(reloadData) name:CCShouldUpdateChatGroupMessageNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(reloadData) name:CCDidUpdateChatGroupNameNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(didAcceptInvitation) name:CCChatGroupDidAcceptInvitationNotification object:nil];
}

- (void)fetchGroupList {
    WEAK(self);
    dispatch_queue_t fetchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[EVEaseMob sharedInstance] chatManager] asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            if (groups.count > 0) {
                weakself.groupsArray = [NSMutableArray arrayWithArray:[EVGroupItem groupItemsWithGroups:groups]];
                [weakself.tableView reloadData];
            }
        });
    } onQueue:fetchQueue];
}

- (void)didAcceptInvitation
{

}

- (void)reloadData
{
    [self.groupsArray removeAllObjects];
    self.groupsArray = [[EVChatMessageManager shareInstance].allGroupItems mutableCopy];
    [self.tableView reloadData];
}

- (void)setUpUI
{
    self.title = @"我的群组";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = CCBackgroundColor;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView autoPinEdgesToSuperviewEdges];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
    
    // 发起群聊按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightBarButtonItemWithTitle:@"建群" textColor:nil target:self action:@selector(clickRightBarButtonItem:)];

}

- (NSMutableArray *)groupsArray
{
    if ( _groupsArray == nil )
    {
        _groupsArray = [NSMutableArray array];
    }
    return _groupsArray;
}

- (void)clickRightBarButtonItem:(id)sender
{
    [self createGroup];
}

- (void)createGroup
{
    WEAK(self)
    EVChooseGroupMemberViewController *chooseVC = [[EVChooseGroupMemberViewController alloc] init];
    [chooseVC setDismissCompletion:^(EMGroup *newGroup,NSArray *members) {
        
        EVGroupChatViewController *chatVC = [[EVGroupChatViewController alloc] init];
        chatVC.chatter = newGroup.groupId;
        CCLog(@"####-----%d,----%s-----%@-id = %@--####",__LINE__,__FUNCTION__,newGroup,newGroup.groupId);
        chatVC.members = members;
        chatVC.delegate = self;
        [self.navigationController pushViewController:chatVC animated:YES];
        
        NSString * namesString = @"";
        for (EVFriendItem * item in members) {
            if (![namesString isEqualToString:@""]) {
                namesString = [namesString stringByAppendingString:@"，"];
            }
            namesString = [namesString stringByAppendingString:item.nickname];
        }
        [[EVChatMessageManager shareInstance] insertMessageWithText:[NSString stringWithFormat:@"邀请%@加入了群聊",namesString] toGroup:newGroup];
    }];
    
    [chooseVC setDisMissVC:^(EVGroupItem *groupItem) {
        EVGroupChatViewController *chatVC = [[EVGroupChatViewController alloc] init];
//        chatVC.chatter = groupItem.ID;
//        chatVC.isGroup = YES;
//        chatVC.delegate = self;
//        chatVC.members = groupItem.members;
//        chatVC.hasAt = groupItem.isAtMessage;
//        chatVC.unread = groupItem.unread;
        [self.navigationController pushViewController:chatVC animated:YES];
//        groupItem.unread = 0;
    }];
    EVNavigationController *navi = [[EVNavigationController alloc] initWithRootViewController:chooseVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - table view delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNotifyViewCell *cell = [EVNotifyViewCell notifyViewCell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ( [self.groupsArray count] > indexPath.row )
    {
        EVGroupItem *item = [self.groupsArray objectAtIndex:indexPath.row];
        cell.groupItem = item;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 当前群组
    EVGroupItem *item = self.groupsArray[indexPath.row];
    EVGroupChatViewController *chatVC = [[EVGroupChatViewController alloc] init];
    chatVC.chatter = item.ID;
//    chatVC.isGroup = YES;
    chatVC.delegate = self;
    chatVC.members = item.members;
    chatVC.hasAt = item.isAtMessage;
    chatVC.unread = item.unread;
    [self.navigationController pushViewController:chatVC animated:YES];
    item.unread = 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = CCBackgroundColor;
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 当前群组
        NSInteger num = indexPath.row;
        EVGroupItem *item = self.groupsArray[num];
        EMConversation * conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:item.ID conversationType:eConversationTypeGroupChat];
        [conversation removeAllMessages];
//        item.time = nil;
        [[EVChatMessageManager shareInstance].allGroupItems removeObjectAtIndex:num];
        //获取完整路径
        [[EVChatMessageManager shareInstance] addPlistFileGroupsArrayID:item.ID];
        [self.groupsArray removeObjectAtIndex:num];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

#pragma mark - 聊天页代理方法

- (void)chatViewController:(EVGroupChatViewController *)chatVC didDeleteLastMessage:(EMMessage *)lastMessage
{
    NSArray *groupItems = [EVChatMessageManager shareInstance].allGroupItems;
    for (int i = 0; i < groupItems.count; i ++)
    {
        EVGroupItem *targetItem = groupItems[i];
        if ( [chatVC.chatter isEqualToString:targetItem.ID])
        {
            if ( lastMessage == nil )
            {
                targetItem.lastMessage = nil;
                targetItem.time = nil;
            }
            else
            {
                [targetItem updateWithMessage:lastMessage];
            }
            break;
        }
    }
    [self reloadData];
}

@end
