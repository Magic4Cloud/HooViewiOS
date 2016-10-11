//
//  EVGroupInfoViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVGroupInfoViewController.h"
#import "EVEaseMob.h"
#import <PureLayout.h>
#import "EVGroupInfoDetailCell.h"
#import "EVGroupInfoIconCell.h"
#import "EVGroupInfoMemberCell.h"
#import "EVGroupInfoSwitchCell.h"
#import "EVGroupInfoModel.h"
#import "EVChatMessageManager.h"
#import "EVLoadingView.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVFriendItem.h"
#import "EVEditChatGroupNameViewController.h"
#import "EVChooseGroupMemberViewController.h"
#import "EVInformImGroupViewController.h"
#import "EVOtherPersonViewController.h"
#import "EVNavigationController.h"
#import "EVChatGroupFileManager.h"
#import "EVAlertManager.h"

#define kChatGroupIdTitle               @"群号"
#define kChatGroupNameTitle             @"群名"
#define kChatGroupNoticeTitle           @"群公告"
#define kChatGroupOwnerTitle            @"群主"
#define kChatGroupMembersTitle          @"群成员"
#define kChatGroupDisturbTitle          @"屏蔽群消息"
#define kChatGroupClearTitle            @"清空聊天记录"
#define kChatGroupApplyTitle            @"群申请设置"
#define kChatGroupInformTitle           @"举报该群组"

#define kChatGroupApplyDetailApply      @"加群需申请"
#define kChatGroupApplyDetailNonApply   @"加群免申请"

#define kChatGroupBottomTitleOwner      @"解散该群"
#define kChatGroupBottomTitleNotOwner   @"退出该群"

#define kChatGroupMembersCellHeight     87.f
#define kChatGroupCommonCellHeight      55.f
#define kChatGroupFooterHeight          1.f
#define kChatGroupHeaderHeight          10.f

@interface EVGroupInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CCGroupInfoMemberCellDelegate,UIActionSheetDelegate,EVChooseGroupMemberViewControllerDelegate,UIAlertViewDelegate>

@property ( weak, nonatomic ) UITableView *tableView;
@property ( strong, nonatomic ) NSArray *dataArray;
@property ( strong, nonatomic ) EMGroup *group;
@property ( weak, nonatomic ) EVLoadingView *loadingView;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property ( strong, nonatomic ) EVGroupInfoModel *masterModel;
@property ( strong, nonatomic ) EVGroupInfoModel *memberModel;
@property ( strong, nonatomic ) EVGroupInfoModel *nameModel;
@property ( strong, nonatomic ) EVGroupInfoModel *applyModel;

@property ( weak, nonatomic ) UIButton *bottomButton;
@property (copy, nonatomic) void(^clearMessage)(); // 清空聊天记录成功回调


@property (assign, nonatomic) BOOL isOwner;


@end

@implementation EVGroupInfoViewController

- (void)dealloc
{
    [_engine cancelAllOperation];
    [CCNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组资料";
    [self setUpUI];
    
    EMGroup *group = [EMGroup groupWithId:self.groupID];
    if ( group.owner && group.members.count > 0 )
    {
        self.isOwner = [self.group.owner isEqualToString:[EVEaseMob cc_shareInstance].currentUserName];
        [self setData];
        [self.tableView reloadData];
    }
    else
    {
        [self.loadingView showLoadingView];
        [[EVEaseMob sharedInstance].chatManager asyncFetchGroupInfo:self.groupID completion:^(EMGroup *group, EMError *error) {
            self.isOwner = [self.group.owner isEqualToString:[EVEaseMob cc_shareInstance].currentUserName];
            [self.loadingView destroy];
            self.group = group;
            [self setData];
            [self.tableView reloadData];
        } onQueue:nil];
    }
    
    // 添加通知
    [CCNotificationCenter addObserver:self selector:@selector(didUpdateGroupName:) name:CCDidUpdateChatGroupNameNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(didUpdateCurrentFriend) name:CCShouldUpdateCurrentFriendMessageNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(didUpdateGroupMembers:) name:CCChatGroupDidUpdateMembersNotification object:nil];
}

// 处理群成员变化的通知
- (void)didUpdateGroupMembers:(NSNotification *)notification
{
    // 刷新group的详细信息
    self.group = [notification.userInfo objectForKey:CCChatGroupDidUpdateGroupKey];
    [self setData];
    [self.tableView reloadData];
}

- (void)didUpdateGroupName:(NSNotification *)notification
{
    NSString *ID = [notification.userInfo objectForKey:CCDidUpdateChatGroupNameNotificationIDKey];
    NSString *subject = [notification.userInfo objectForKey:CCDidUpdateChatGroupNameNotificationSubjectKey];
    if ( [ID isEqualToString:self.groupID] )
    {
        self.title = subject;
        self.nameModel.infoText = subject;
        [self.tableView reloadData];
    }
}
- (void)didUpdateCurrentFriend
{
    NSInteger memberCount = MAX(0, self.group.groupOccupantsCount - 1) ;
    self.memberModel.detailText = [NSString stringWithFormat:@"%zd人",memberCount];
    [self.tableView reloadData];
}

#pragma mark - setter & getter

- (void)setIsOwner:(BOOL)isOwner
{
    _isOwner = isOwner;
    NSString *bottomTitle = _isOwner ? kChatGroupBottomTitleOwner:kChatGroupBottomTitleNotOwner;
    [self.bottomButton setTitle:bottomTitle forState:UIControlStateNormal];
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

- (EVBaseToolManager  *)engine {
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (EMGroup *)group
{
    if ( _group == nil )
    {
        _group = [EMGroup groupWithId:self.groupID];
    }
    return _group;
}

#pragma  mark - UI
- (void)setUpUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.backgroundColor = CCBackgroundColor;
    [self.view addSubview: tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView autoPinEdgesToSuperviewEdges];
    tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 退出按钮
    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    self.tableView.tableFooterView = tableFooter;
    // 退出按钮
    CGFloat height = 44.f;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableFooter addSubview:button];
    [button autoCenterInSuperview];
    [button autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 40];
    [button autoSetDimension:ALDimensionHeight toSize:height];
    
    button.backgroundColor = CCAppMainColor;
    button.layer.cornerRadius = height * 0.5;
    button.layer.masksToBounds = YES;
    NSString *bottomTitle = _isOwner ? kChatGroupBottomTitleOwner:kChatGroupBottomTitleNotOwner;
    [button setTitle:bottomTitle forState:UIControlStateNormal];
    button.titleLabel.font = CCNormalFont(15);
    [button addTarget:self action:@selector(didClickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton = button;
}

// 点击确定按钮
- (void)didClickBottomButton:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ( [title isEqualToString:kChatGroupBottomTitleOwner] )
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"是否解散该群?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else if ([title isEqualToString:kChatGroupBottomTitleNotOwner] )
    {
        [[EVChatMessageManager shareInstance] leaveGroupWithId:self.groupID completion:^(EMError *error) {
            if (!error) {
                NSInteger count = self.navigationController.viewControllers.count;
                UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(count - 3)];
                [self.navigationController popToViewController:viewController animated:YES];
                [CCProgressHUD showSuccess:@"退出成功"];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EVChatMessageManager shareInstance] destroyGroupWithId:self.groupID completion:^(EMError *error) {
            if ( !error )
            {
                [CCProgressHUD showSuccess:@"解散成功"];
                NSInteger count = self.navigationController.viewControllers.count;
                UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(count - 3)];
                [self.navigationController popToViewController:viewController animated:YES];
                
            }
        }];
    }
}

#pragma mark - 数据

- (void)setData
{
    // 群号
    EVGroupInfoModel *idModel = [EVGroupInfoModel modelWithTitle:kChatGroupIdTitle infoText:self.groupID icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoCell class])];
    // 群名
    EVGroupInfoModel *nameModel = [EVGroupInfoModel modelWithTitle:kChatGroupNameTitle infoText:self.group.groupSubject icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoCell class])];
    self.nameModel = nameModel;
    nameModel.clazz = self.isOwner ? NSStringFromClass([EVGroupInfoDetailCell class]) : NSStringFromClass([EVGroupInfoCell class]);
    // 群公告
    EVGroupInfoModel *noticeModel = [EVGroupInfoModel modelWithTitle:kChatGroupNoticeTitle infoText:self.group.groupDescription icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoDetailCell class])];
    if ( self.group.groupDescription == nil || self.group.groupDescription.length == 0 )
    {
        noticeModel.detailText = @"未设置";
    }
    NSArray *array1 = @[idModel,nameModel,noticeModel];
    // 群主
    EVGroupInfoModel *masterModel = [EVGroupInfoModel modelWithTitle:kChatGroupOwnerTitle infoText:nil icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoIconCell class])];
    self.masterModel = masterModel;
    NSInteger memberCount = MAX(0, self.group.groupOccupantsCount - 1) ;
    NSString *detailText = [NSString stringWithFormat:@"%zd人",memberCount];
    // 群成员
    EVGroupInfoModel *memberModel = [EVGroupInfoModel modelWithTitle:kChatGroupMembersTitle infoText:nil icon:nil detailText:detailText clazz:NSStringFromClass([EVGroupInfoMemberCell class])];
    memberModel.isOwner = self.isOwner;
    self.memberModel = memberModel;
    NSArray *array2 = @[masterModel,memberModel];
    // 免打扰
    EVGroupInfoModel *disturbModel = [EVGroupInfoModel modelWithTitle:kChatGroupDisturbTitle infoText:nil icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoSwitchCell class])];
    disturbModel.isOwner = _isOwner;
    disturbModel.isBlock = self.group.isBlocked;
    // 举报
    EVGroupInfoModel *reportModel = [EVGroupInfoModel modelWithTitle:kChatGroupInformTitle infoText:nil icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoDetailCell class])];
    // 申请
    NSString *applyDetail = self.group.groupSetting.groupStyle == eGroupStyle_PrivateMemberCanInvite ? kChatGroupApplyDetailNonApply : kChatGroupApplyDetailApply;
    EVGroupInfoModel *applyModel = [EVGroupInfoModel modelWithTitle:kChatGroupApplyTitle infoText:nil icon:nil detailText:applyDetail clazz:NSStringFromClass([EVGroupInfoDetailCell class])];
    self.applyModel = applyModel;
    // 清理聊天记录
    EVGroupInfoModel *clearModel = [EVGroupInfoModel modelWithTitle:kChatGroupClearTitle infoText:nil icon:nil detailText:nil clazz:NSStringFromClass([EVGroupInfoDetailCell class])];

    NSArray *array3 = nil;
    if ( self.isOwner == YES )
    {
        array3 = @[clearModel];
    }
    else
    {
        array3 = @[disturbModel,clearModel];
    }
    NSArray *array4 = @[reportModel];
    self.dataArray = @[array1,array2,array3,array4];
    // 加载群员和群主信息
    [self loadGroupMasterInfo];
    [self loadGroupMemberInfo];
}

// 获取群主信息
- (void)loadGroupMasterInfo
{
    if ( nil == self.group.owner )
    {
        return;
    }
    [[EVChatGroupFileManager shareInstance] friendsFromLocalForIMUsers:@[self.group.owner] completion:^(NSArray *friends) {
        if ( friends.count > 0 )
        {
            EVFriendItem *item = friends[0];
            self.masterModel.name = item.name;
            self.masterModel.icon = item.logourl;
            [self.tableView reloadData];
        }
    }];
}

// 获取群成员信息
- (void)loadGroupMemberInfo
{
    // 群员头像 不必显示全部 由于最多显示5个头像 所以只取前5个
    NSArray *subMembers = nil;
    if ( self.group.members.count > 5 )
    {
        subMembers  = [self.group.members subarrayWithRange:NSMakeRange(0, 5)];
    }
    else
    {
        subMembers = self.group.members;
    }
    CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,subMembers);

    [[EVChatGroupFileManager shareInstance] friendsFromLocalForIMUsers:subMembers completion:^(NSArray *friends) {
        self.memberModel.members = friends;
        [self.tableView reloadData];
    }];
}

#pragma mark - table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVGroupInfoModel *model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    
    EVGroupInfoCell *infoCell = [EVGroupInfoCell cellForTabelView:tableView clazz:model.clazz];
    infoCell.cellItem = model;
    if ( [infoCell isKindOfClass:[EVGroupInfoMemberCell class]] )
    {
        EVGroupInfoMemberCell *cell = (EVGroupInfoMemberCell *)infoCell;
        cell.delegate = self;
    }
    __weak typeof(self) weakSelf = self;
    infoCell.action = ^(UIView *view)
    {
        [weakSelf handleActionWith:model view:view];
    };
    return infoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVGroupInfoModel *model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    // 群成员一行的高度
    if ( [model.title isEqualToString:kChatGroupMembersTitle] )
    {
        return kChatGroupMembersCellHeight;
    }
    return kChatGroupCommonCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kChatGroupFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kChatGroupHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = CCBackgroundColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取当前行模型对象
    EVGroupInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    EVGroupInfoModel *model = cell.cellItem;
    
    // 群名
    if ( [model.title isEqualToString:kChatGroupNameTitle] && self.isOwner )
    {
        // 编辑群名称
        EVEditChatGroupNameViewController *editVC = [[EVEditChatGroupNameViewController alloc] init];
        editVC.group = self.group;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    // 举报
    else if ( [model.title isEqualToString:kChatGroupInformTitle] )
    {
        EVInformImGroupViewController *informVC = [[EVInformImGroupViewController alloc] init];
        informVC.groupId = self.groupID;
        [self.navigationController pushViewController:informVC animated:YES];
    }
    // 群主
    else if ([model.title isEqualToString:kChatGroupOwnerTitle])
    {
        EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] initWithName:model.name];
        otherVC.fromLivingRoom = NO;
        [self.navigationController pushViewController:otherVC animated:YES];
    }
    // 群成员
    else if ([model.title isEqualToString:kChatGroupMembersTitle])
    {
        [self showChooseGroupMemberViewControllerWithType:CCChooseGroupMemberViewControllerTypeShowMembers];
    }
    // 群申请设置
    else if ([model.title isEqualToString:kChatGroupApplyTitle])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:kChatGroupApplyDetailApply,kChatGroupApplyDetailNonApply, nil];
        [sheet showInView:self.view];

    }
    // 清空聊天记录
    else if ([model.title isEqualToString:kChatGroupClearTitle])
    {
        [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"确定要删除聊天记录吗?" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
            EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.groupID conversationType:eConversationTypeGroupChat];
            BOOL succeed = [conversation removeAllMessages];
            if ( succeed )
            {
                model.detailText = @"";
                [self.tableView reloadData];
                if ( self.clearMessage )
                {
                    self.clearMessage();
                }
            }
            
        } cancel:nil];
    }
    // 群公告
    else if ([model.title isEqualToString:kChatGroupNoticeTitle])
    {
        // 如果没有群描述,并且不是群主直接返回
        if ( (self.group.groupDescription == nil || self.group.groupDescription.length == 0) && self.isOwner == NO )
        {
            [CCProgressHUD showMessageInAFlashWithMessage:@"只有群主才可以发布群公告"];
            return;
        }
        EVEditChatGroupNameViewController *editVC = [[EVEditChatGroupNameViewController alloc] init];
        editVC.group = self.group;
        editVC.type = CCEditChatGroupNameViewControllerTypeNotice;
        editVC.isOwner = self.isOwner;
        [editVC setChangeSucceed:^(NSString *description) {
            [self setData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            self.group.groupSetting.groupStyle = eGroupStyle_PublicOpenJoin;
            self.applyModel.detailText = kChatGroupApplyDetailApply;
        }
            break;
        case 1:
        {
            self.group.groupSetting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
            self.applyModel.detailText = kChatGroupApplyDetailNonApply;
        }
            break;
    }
    [self.tableView reloadData];
}

#pragma mark -
// 处理cell的action
- (void)handleActionWith:(EVGroupInfoModel *)model view:(UIView *)view
{
    // 屏蔽群消息
    if ( [view isKindOfClass:[UISwitch class]] && [model.title isEqualToString:kChatGroupDisturbTitle])
    {
        UISwitch *aSwitch = (UISwitch *)view;
        aSwitch.enabled = NO;
        if ( aSwitch.on )
        {
            [[EaseMob sharedInstance].chatManager asyncBlockGroup:self.groupID completion:^(EMGroup *group, EMError *error) {
                aSwitch.on = error == nil;
                if ( error == nil )
                {
                    model.isBlock = YES;
                }
                else
                {
                    [CCProgressHUD showError:error.description];
                }
                aSwitch.enabled = YES;
            } onQueue:nil];
        }
        else
        {
            [[EaseMob sharedInstance].chatManager asyncUnblockGroup:self.groupID completion:^(EMGroup *group, EMError *error) {
                aSwitch.on = error != nil;
                if ( !error )
                {
                    model.isBlock = NO;
                }
                else
                {
                    [CCProgressHUD showError:error.description];
                }
                aSwitch.enabled = YES;
            } onQueue:nil];
        }
    }
    
}


// 加号按钮
-(void)groupInfoMemberCell:(EVGroupInfoMemberCell *)cell didClickAddButton:(UIButton *)button
{
    [self showChooseGroupMemberViewControllerWithType:CCChooseGroupMemberViewControllerTypeAddMember];
}

// 减号按钮
-(void)groupInfoMemberCell:(EVGroupInfoMemberCell *)cell didClickRemoveButton:(UIButton *)button
{
    [self showChooseGroupMemberViewControllerWithType:CCChooseGroupMemberViewControllerTypeRemoveMember];
}

- (void)showChooseGroupMemberViewControllerWithType:(CCChooseGroupMemberViewControllerType)type
{
    EVChooseGroupMemberViewController *chooseVC = [[EVChooseGroupMemberViewController alloc] init];
    chooseVC.type = type;
    chooseVC.group = self.group;
    chooseVC.delegate = self;
    // 结束选择页回来后的回调
    [chooseVC setDismissCompletion:^(EMGroup *newGroup, NSArray *friends) {
        if ( type != CCChooseGroupMemberViewControllerTypeShowMembers )
        {
            [self loadGroupMemberInfo];
            [self.tableView reloadData];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    EVNavigationController *navi = [[EVNavigationController alloc] initWithRootViewController:chooseVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)groupDestroyed
{
    UIViewController * viewController = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:viewController animated:YES];
}

- (void)setClearMessageSucceed:(void (^)())clear
{
    if ( clear )
    {
        self.clearMessage = clear;
    }
}

@end
