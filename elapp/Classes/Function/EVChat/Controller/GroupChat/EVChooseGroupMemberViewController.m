//
//  EVChooseGroupMemberViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChooseGroupMemberViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVGroupAPI.h"
#import "EVFriendItem.h"
#import "EVChooseFriendsCell.h"
#import "EVEaseMob.h"
#import "EVLoginInfo.h"
#import "EVChatMessageManager.h"
#import "EVLimitSearchCell.h"
#import "NSString+Extension.h"
#import "EVInterestingGuyTableViewCell.h"
#import "EVFanOrFollowerModel.h"
#import "UIBarButtonItem+CCNavigationRight.h"
#import "EVLoadingView.h"
#import "EVOtherPersonViewController.h"
#import "NSArray+Group.h"
#import "EVNavigationController.h"

#define kSectionHeaderHeight 30.f
#define kHeaderHeight         65.f

@interface EVChooseFriendsSectionHeader : UITableViewHeaderFooterView

@property (copy, nonatomic) NSString *title;
@property ( weak, nonatomic ) UILabel *titleLabel;



@end

@implementation EVChooseFriendsSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if ( self )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth, kSectionHeaderHeight)];
        [self.contentView addSubview:label];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        label.textColor = CCTextBlackColor;
        label.font = CCNormalFont(15);
        self.titleLabel = label;
    }
    return self;
}

+ (instancetype)headerViewForTableView:(UITableView *)tableView
{
    static NSString *identifier = @"header";
    EVChooseFriendsSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if ( headerView == nil )
    {
        headerView = [[EVChooseFriendsSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    return headerView;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

@end



@interface EVChooseGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource, EVChooseFriendsCellDelegate, CCLimitSearchCellDelegate>

@property ( strong, nonatomic ) EVBaseToolManager *engine;
@property (nonatomic, weak) UITableView *tableView;
@property ( strong, nonatomic ) NSArray *friends;
@property ( strong, nonatomic ) NSMutableArray *selectedMembers;
@property (copy, nonatomic) NSString *confirmTitle;
@property ( strong, nonatomic ) UIButton *confirmButton;
@property (weak, nonatomic) EVLimitSearchCell *searchHeader;  /**< 搜索头 */
@property (strong, nonatomic) NSMutableArray *filterFriends; /**< 过滤后的朋友 */
@property (assign, nonatomic) BOOL isFiltering; /**< 是否处于搜索结果状态 */
@property ( strong, nonatomic ) NSArray *fansOrFollowsArray;
@property (copy, nonatomic) DismissCompletion completion;
@property ( strong, nonatomic ) NSArray *members;
@property ( weak, nonatomic ) EVLoadingView *loadingView;
@property ( strong, nonatomic ) NSArray *dataSource;    // 列表的数据源
@property ( strong, nonatomic ) NSArray *groupNames;    // 列表的分组名
@property (assign, nonatomic) BOOL isOwner;

@property (nonatomic, copy) DisMissVC disMissVC;


@end

@implementation EVChooseGroupMemberViewController

#pragma mark - life circle

- (instancetype)init {
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpData];
    [CCNotificationCenter addObserver:self selector:@selector(didLeaveGroupNotifycation:) name:CCChatGrroupDidLeaveNotification object:nil];
}

- (void)didLeaveGroupNotifycation:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSString *groupId = [info objectForKey:CCChatGrroupDidLeaveGroupIdKey];
    EMGroupLeaveReason reason = [[info objectForKey:CCChatGrroupDidLeaveReasonKey] integerValue];
    if ( [groupId isEqualToString:self.group.groupId] )
    {
        if ( reason == eGroupLeaveReason_BeRemoved )
        {
            [CCProgressHUD showMessageInAFlashWithMessage:@"你已经被移除该群"];
        }
        else if (reason == eGroupLeaveReason_Destroyed && self.view.window)
        {
            [CCProgressHUD showMessageInAFlashWithMessage:@"该群已解散"];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [_engine cancelAllOperation];
    _engine = nil;
    for (EVFriendItem *item in _members) {
        item.selected = NO;
    }
}

- (void)setDismissCompletion:(DismissCompletion)completion
{
    if ( completion )
    {
        _completion = completion;
    }
}

#pragma mark - table view delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isFiltering ? 1 : self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isFiltering ? self.filterFriends.count : [self.dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.type == CCChooseGroupMemberViewControllerTypeShowMembers )
    {
        EVInterestingGuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestingGuyCellId"];
        NSArray *friends = self.isFiltering ? self.filterFriends : self.dataSource[indexPath.section];
        if ( indexPath.row >= [friends count] )
        {
            return cell;
        }
        if ( friends.count > indexPath.row )
        {
            cell.model = friends[indexPath.row];
            cell.changeStateBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;
            cell.avatarClickBlock = ^(EVFanOrFollowerModel *model){
                EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] init];
                otherVC.name = model.name;
                otherVC.fromLivingRoom = NO;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
            };
        }
        return cell;
    }
    
    EVChooseFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:[EVChooseFriendsCell cellID]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *friends = self.isFiltering ? self.filterFriends : self.dataSource[indexPath.section];
    if ( friends.count > indexPath.row )
    {
        EVFriendItem *item = friends[indexPath.row];
        cell.cellItem = item;
        cell.delegate = self;        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ( self.type == CCChooseGroupMemberViewControllerTypeShowMembers )
    {
        return nil;
    }
    return self.groupNames;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EVChooseFriendsSectionHeader *headerView = [EVChooseFriendsSectionHeader headerViewForTableView:tableView];
    if (!(self.groupNames.count == 0)) {
       headerView.title = self.groupNames[section];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.type != CCChooseGroupMemberViewControllerTypeShowMembers )
    {
        EVChooseFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ( cell.cellItem.disable == YES )
        {
            return;
        }
        [self chooseCell:cell didSelected:nil];
    }
    else
    {
        EVInterestingGuyTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        EVOtherPersonViewController *otherVC = [[EVOtherPersonViewController alloc] init];
        otherVC.name = cell.model.name;
        otherVC.fromLivingRoom = NO;
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.isOwner ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [CCProgressHUD showMessage:@"请稍候..." toView:self.view];
        NSArray *friends = self.isFiltering ? self.filterFriends : self.dataSource[indexPath.section];
        EVFanOrFollowerModel * model = friends[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [[EVChatMessageManager shareInstance] removeFriends:@[model] toGroup:self.group.groupId completion:^(EMError *error) {
            if ( error == nil )
            {
                if (self.group.groupOccupantsCount <= 1)
                {
                    [[EVChatMessageManager shareInstance] destroyGroupWithId:self.group.groupId completion:^(EMError *error) {
                        if ( !error )
                        {
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"群成员小于1群自动解散" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                            [alert show];
                            [self dismissViewControllerAnimated:YES completion:^{
                                [self.delegate groupDestroyed];
                            }];
                        }
                    }];
                }
                else
                {
                    [self setUpData];
                    [self.loadingView destroy];
                    [CCNotificationCenter postNotificationName:CCChatGroupDidUpdateMembersNotification object:nil userInfo:@{CCChatGroupDidUpdateGroupKey:self.group}];
                }
            }
            else
            {
                [CCProgressHUD hideHUDForView:weakSelf.view];
                [CCProgressHUD showError:error.description];
            }
        }];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchHeader endEditing];
}


#pragma mark - CCChooseFriendsCellDelegate

- (void)chooseCell:(EVChooseFriendsCell *)cell didSelected:(UIButton *)button
{
    cell.cellItem.selected = !cell.cellItem.selected;
    EVFriendItem *model = cell.cellItem;
    [self changeSelectedStateForFriendItem:model isAllSelected:NO];
    [self.tableView reloadData];
}

// 改变选中状态
- (void)changeSelectedStateForFriendItem:(EVFriendItem *)item isAllSelected:(BOOL)isAllSelected {
    if (item.selected == YES) {
        if ([self.selectedMembers indexOfObject:item] == NSNotFound) {
            [self.selectedMembers addObject:item];
            [self.searchHeader selectFriendItem:item];
        }
    } else {
        [self.selectedMembers removeObject:item];
        [self.searchHeader deSelectFriendItem:item];
    }
    
    [self refreshRightNavigationBarItem];
    
    if (isAllSelected == NO) {
        BOOL allSelected = YES;
        for (NSArray *items in self.dataSource) {
            for (EVFriendItem *item in items) {
                if (item.selected == NO) {
                    allSelected = NO;
                }
            }
        }
        self.confirmButton.selected = allSelected;
    }
}


#pragma mark - CCLimitSearchCellDelegate

- (void)limitCellDidBeginEdit:(EVLimitSearchCell *)cell
{
    
}

- (void)limitCell:(EVLimitSearchCell *)cell textChange:(NSString *)text
{
    [self filterFriendWithText:text];
}

- (void)limitCellDeleteLastItem:(EVLimitSearchCell *)cell
{
    [self.selectedMembers removeLastObject];
    [self.tableView reloadData];
    [self refreshRightNavigationBarItem];
}

- (void)limitCellDidCancelItem:(CCFriendItem *)item
{
    self.isFiltering = NO;
    [self.selectedMembers removeObject:item];
    [self.tableView reloadData];
    [self refreshRightNavigationBarItem];
}


#pragma mark - private methods

- (void)refreshRightNavigationBarItem
{
    NSString *title = @"";
    switch ( self.type )
    {
        case CCChooseGroupMemberViewControllerTypeCreateGroup:
        case CCChooseGroupMemberViewControllerTypeAddMember:
        case CCChooseGroupMemberViewControllerTypeAtMembers:
        {
            title = @"确定";
        }
            break;
            
        case CCChooseGroupMemberViewControllerTypeRemoveMember:
        {
            title = @"删除";
        }
            break;
        case CCChooseGroupMemberViewControllerTypeShowMembers: {
        }
        case CCChooseGroupMemberViewControllerTypeLiveFilter: {
            title = @"全选";
        }
    }
    self.confirmTitle = self.selectedMembers.count > 0 ? [NSString stringWithFormat:@"%@(%zd)",title,self.selectedMembers.count]:title;
    if (self.type != CCChooseGroupMemberViewControllerTypeLiveFilter) {
        self.confirmButton.enabled = self.selectedMembers.count > 0;
    } else {
        self.confirmButton.enabled = YES;
    }
}

- (void)filterFriendWithText:(NSString *)text
{
    [self.filterFriends removeAllObjects];
    if ( text.length == 0 )
    {
        self.isFiltering = NO;
        [self.tableView reloadData];
        return;
    }
    else
    {
        self.isFiltering = YES;
        if ( self.type != CCChooseGroupMemberViewControllerTypeShowMembers )
        {
            for ( EVFriendItem *item in self.friends )
            {
                if ( [item.pinyin cc_containString:text] || [item.nickname cc_containString:text] || [item.remarks cc_containString:text] || [item.name cc_containString:text] )
                {
                    [self.filterFriends addObject:item];
                }
            }
        }
        else
        {
            for ( EVFanOrFollowerModel *item in self.fansOrFollowsArray )
            {
                if ( [item.pinyin cc_containString:text] || [item.nickname cc_containString:text] || [item.remarks cc_containString:text] || [item.name cc_containString:text] )
                {
                    [self.filterFriends addObject:item];
                }
            }
 
        }
        
        [self.tableView reloadData];
    }
}

- (void)setUpUI
{
   
    
    EVLimitSearchCell *searchHeader = [[EVLimitSearchCell alloc] initWithFrame:CGRectZero];
    searchHeader.placeHolder = @"搜索";
    searchHeader.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchHeader];
    searchHeader.delegate = self;
    [searchHeader autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [searchHeader autoSetDimension:ALDimensionHeight toSize:60.0f];
    self.searchHeader = searchHeader;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchHeader];
    tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];

    [tableView registerClass:[EVLimitSearchCell class] forCellReuseIdentifier:[EVLimitSearchCell cellID]];
    [tableView registerClass:[EVChooseFriendsCell class] forCellReuseIdentifier:[EVChooseFriendsCell cellID]];
    [tableView registerClass:[EVInterestingGuyTableViewCell class] forCellReuseIdentifier:@"interestingGuyCellId"];
    tableView.backgroundColor = CCBackgroundColor;
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = CCTextBlackColor;
    
    UIView *tableHeaderView = [[UIView alloc]init];
    tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, kHeaderHeight);
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIButton *headerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    headerButton.frame = CGRectMake(15, 0, ScreenWidth, kHeaderHeight);
    headerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [tableHeaderView addSubview:headerButton];
    [headerButton setTitle:@"选择一个群" forState:(UIControlStateNormal)];
    [headerButton setTitleColor:[UIColor colorWithHexString:@"#5D5854"] forState:(UIControlStateNormal)];
    headerButton.titleLabel.font = [UIFont systemFontOfSize:15.];
    [headerButton addTarget:self action:@selector(headerClick) forControlEvents:UIControlEventTouchDown];
    
    UIView *lineView = [[UIView alloc] init];
    [tableHeaderView addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    lineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 左侧取消按钮
    NSString *navLeftBtnTitle;
    if (self.type == CCChooseGroupMemberViewControllerTypeLiveFilter) {
        navLeftBtnTitle = @"返回";
    } else {
        navLeftBtnTitle = @"取消";
    }
    UIBarButtonItem *cancelBarButtonItem = [UIBarButtonItem leftBarButtonItemWithTitle:navLeftBtnTitle textColor:nil target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    // 导航栏右侧按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, 0, 60, 40);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:CCButtonDisableColor forState:UIControlStateDisabled];
    [confirmButton setContentMode:UIViewContentModeBottomRight];
    confirmButton.titleLabel.font = CCNormalFont(15);
    [confirmButton addTarget:self action:@selector(didClickComfirmBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.confirmButton = confirmButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    [confirmButton setEnabled:NO];
    switch ( self.type )
    {
        case CCChooseGroupMemberViewControllerTypeCreateGroup:
        case CCChooseGroupMemberViewControllerTypeAddMember:
        case CCChooseGroupMemberViewControllerTypeAtMembers:
        {
            self.title = @"选择联系人";
            self.tableView.tableHeaderView = tableHeaderView;
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
            
        case CCChooseGroupMemberViewControllerTypeRemoveMember:
        {
             self.title = @"删除联系人";
            [confirmButton setTitle:@"删除" forState:UIControlStateNormal];
        }
            break;
        case CCChooseGroupMemberViewControllerTypeShowMembers:
        {
             self.title = @"群成员";
            [confirmButton setTitle:@"添加" forState:UIControlStateNormal];
            [confirmButton setEnabled:YES];
        }
            break;
        case CCChooseGroupMemberViewControllerTypeLiveFilter: {
            self.title = @"好友可见";
            [confirmButton setTitle:@"全选" forState:UIControlStateNormal];
            [confirmButton setTitle:@"取消全选" forState:UIControlStateSelected];
            [confirmButton setEnabled:YES];
        }
    }
}

- (void)didClickCancelButton:(id)sender
{
    if (self.type == CCChooseGroupMemberViewControllerTypeLiveFilter) {
        !self.completion ?: self.completion(nil, self.selectedMembers);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setDisMissVC:(DisMissVC)disMissVC
{
    if (disMissVC) {
        _disMissVC = disMissVC;
    }
}

- (void)headerClick
{
//    EVChooseGroupViewController *chooseGroupVC = [[EVChooseGroupViewController alloc]init];
//    chooseGroupVC.isForward = NO;
//    WEAK(self)
//    [chooseGroupVC setPopAndDismissVC:^(EVGroupItem *groupItem) {
//        if (weakself.disMissVC) {
//            weakself.disMissVC(groupItem);
//        }
//    }];
//    [self.navigationController pushViewController:chooseGroupVC animated:YES];
}

/**
 *  确定按钮
 *
 *  @param sender 点击的按钮
 */
- (void)didClickComfirmBarButtonItem:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    [CCProgressHUD showMessage:@"请稍候..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    if ( self.type == CCChooseGroupMemberViewControllerTypeCreateGroup )
    {
        [[EVChatMessageManager shareInstance] createGroupWithFriends:weakSelf.selectedMembers completion:^(EMGroup *group, EMError *error) {
            button.enabled = YES;
            [CCProgressHUD hideHUDForView:weakSelf.view];
            if ( error == nil )
            {
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    weakSelf.completion(group,weakSelf.selectedMembers);
                }];
            }
            else
            {
                [CCProgressHUD showError:error.description];
            }
        }];
    }
    else if (self.type == CCChooseGroupMemberViewControllerTypeAddMember)
    {
        [[EVChatMessageManager shareInstance] addFriends:weakSelf.selectedMembers toGroup:self.group.groupId completion:^(EMError *error) {
            button.enabled = YES;
            [CCProgressHUD hideHUDForView:weakSelf.view];
            if ( error == nil )
            {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    weakSelf.completion(weakSelf.group,weakSelf.selectedMembers);
                }];
            }
            else
            {
                [CCProgressHUD showError:error.description];
            }
        }];
    }
    else if (self.type == CCChooseGroupMemberViewControllerTypeRemoveMember )
    {
       [[EVChatMessageManager shareInstance] removeFriends:weakSelf.selectedMembers toGroup:self.group.groupId completion:^(EMError *error) {
           button.enabled = YES;
           [CCProgressHUD hideHUDForView:weakSelf.view];
           if ( error == nil )
           {
               if (self.group.groupOccupantsCount <= 1)
               {
                   [[EVChatMessageManager shareInstance] destroyGroupWithId:self.group.groupId completion:^(EMError *error) {
                       if ( !error )
                       {
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"群成员小于1群自动解散" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                           [alert show];
                           [self dismissViewControllerAnimated:YES completion:^{
                               [self.delegate groupDestroyed];
                           }];
                       }
                   }];
               }
               else
               {
                   [weakSelf dismissViewControllerAnimated:YES completion:^{
                       weakSelf.completion(weakSelf.group,weakSelf.selectedMembers);
                   }];
               }
           }
           else
           {
               [CCProgressHUD showError:error.description];
           }
       }];
    }
    else if (self.type == CCChooseGroupMemberViewControllerTypeAtMembers)
    {
        if ( self.completion )
        {
            __weak typeof(self) weakSelf = self;
            [self dismissViewControllerAnimated:YES completion:^{
                
                weakSelf.completion(weakSelf.group,weakSelf.selectedMembers);
            }];
        }
    }
    else if (self.type == CCChooseGroupMemberViewControllerTypeShowMembers)
    {
        [CCProgressHUD hideHUDForView:weakSelf.view];
        EVChooseGroupMemberViewController *chooseVC = [[EVChooseGroupMemberViewController alloc] init];
        chooseVC.type = CCChooseGroupMemberViewControllerTypeAddMember;
        chooseVC.group = self.group;
        // 结束选择页回来后的回调
        [chooseVC setDismissCompletion:^(EMGroup *newGroup, NSArray *friends) {
            [self setUpData];
            [CCNotificationCenter postNotificationName:CCChatGroupDidUpdateMembersNotification object:nil userInfo:@{CCChatGroupDidUpdateGroupKey:self.group}];
        }];
        EVNavigationController *navi = [[EVNavigationController alloc] initWithRootViewController:chooseVC];
        [self presentViewController:navi animated:YES completion:^{
            button.enabled = YES;
        }];
    }
    else if (self.type == CCChooseGroupMemberViewControllerTypeLiveFilter) {
        [CCProgressHUD hideHUDForView:weakSelf.view];
        self.confirmButton.selected = !self.confirmButton.selected;
        for (NSArray *items in self.dataSource) {
            for (EVFriendItem *item in items) {
                item.selected = self.confirmButton.selected;
                [self changeSelectedStateForFriendItem:item isAllSelected:YES];
            }
        }
        [self.tableView reloadData];
    }
}



- (void)setUpData
{
    switch ( self.type )
    {
        case CCChooseGroupMemberViewControllerTypeCreateGroup:
        case CCChooseGroupMemberViewControllerTypeLiveFilter:
        case CCChooseGroupMemberViewControllerTypeAddMember: {
            [self requestFriendStart:0 count:INT_MAX];
            break;
        }
        case CCChooseGroupMemberViewControllerTypeRemoveMember:
        case CCChooseGroupMemberViewControllerTypeShowMembers: {
            [self requestMembers];
            break;
        }
        case CCChooseGroupMemberViewControllerTypeAtMembers: {
            [self chooseAtMembers];
            break;
        }
    }
}

- (void)chooseAtMembers
{
    // 如果成员是空,先获取成员
    __weak typeof(self) weakSelf = self;
    [self.loadingView showLoadingView];
    if ( self.group.occupants.count == 0 )
    {
        [[EVEaseMob sharedInstance].chatManager asyncFetchGroupInfo:self.group.groupId completion:^(EMGroup *group, EMError *error) {
            [weakSelf occupantExceptMeCompletion:^(NSArray *friends) {
                [weakSelf.loadingView destroy];
            }];
        } onQueue:nil];
    }
    else
    {
        [self occupantExceptMeCompletion:^(NSArray *friends) {
            [self.loadingView destroy];
        }];
    }
}

- (void)occupantExceptMeCompletion:(void(^)(NSArray *friends)) completion
{
    __weak typeof(self) weakSelf = self;
    [[EVChatMessageManager shareInstance] initialCurrentOccupantItemsWithGroupId:self.group.groupId completion:^(NSArray *friends) {
        NSString *currentImuser = [EVEaseMob cc_shareInstance].currentUserName;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imuser != %@",currentImuser];
        NSArray *occpantNoMe = [friends filteredArrayUsingPredicate:predicate];
        for (EVFriendItem *item in occpantNoMe) {
            if ( [self.selectedAtMembers containsObject:item] )
            {
                item.disable = YES;
            }
        }
        weakSelf.friends = occpantNoMe;
        weakSelf.members = occpantNoMe;
        if ( completion )
        {
            completion(occpantNoMe);
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)requestMembers
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.loadingView showLoadingView];
    [[EVChatMessageManager shareInstance] initialCurrentMemberItemsWithGroupId:self.group.groupId completion:^(NSArray *friends) {
        [weakSelf.loadingView destroy];
        if ( weakSelf.type == CCChooseGroupMemberViewControllerTypeRemoveMember )
        {
            weakSelf.friends = friends;
            weakSelf.members = friends;
            [weakSelf.tableView reloadData];
        }
        else if (weakSelf.type == CCChooseGroupMemberViewControllerTypeShowMembers)
        {
            [[EVChatMessageManager shareInstance] initialCurrentOwnerInfoWithGroupId:self.group.groupId completion:^(EVFriendItem *ownerItem) {
                EVLoginInfo * loginInfo = [EVLoginInfo localObject];
                if ([loginInfo.name isEqualToString:ownerItem.name]) {
                    self.isOwner = YES;
                } else {
                    self.isOwner = NO;
                }
                NSMutableArray *dataArray = [NSMutableArray array];
                for (EVFriendItem *item in friends) {
                    EVFanOrFollowerModel *model = [[EVFanOrFollowerModel alloc] init];
                    model.name = item.name;
                    model.nickname = item.nickname;
                    model.logourl = item.logourl;
                    model.vip = item.vip;
                    model.vip_level = item.vip_level;
                    model.level = item.level;
                    model.imuser = item.imuser;
                    model.gender = item.gender;
                    [dataArray addObject:model];
                }
                weakSelf.fansOrFollowsArray = dataArray;
                [weakSelf requestFriendStart:0 count:INT_MAX];
            }];
        }
    }];
}

- (void)requestFriendStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) wself = self;
    [wself.loadingView showLoadingView];
    [wself.engine GETUserfriendlistStart:start count:count start:^{
    } fail:^(NSError *error) {
        [wself.loadingView destroy];
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:k_REQUST_FAIL toView:wself.view];
    } success:^(NSDictionary *result) {
        [wself.loadingView destroy];
        [CCProgressHUD hideHUDForView:wself.view];
        NSArray *friends = result[@"users"];
        if ( wself.type !=  CCChooseGroupMemberViewControllerTypeShowMembers)
        {
             wself.friends = [EVFriendItem objectWithDictionaryArray:friends];
            // 如果是添加成员
            if ( wself.type == CCChooseGroupMemberViewControllerTypeAddMember )
            {
                for (EVFriendItem *item in wself.friends) {
                    if ( [wself.group.occupants containsObject:item.imuser] )
                    {
                        item.disable = YES;
                    }
                }
            } else if (wself.type == CCChooseGroupMemberViewControllerTypeLiveFilter) {
                for (EVFriendItem *item in wself.alreadySelectedMembers) {
                    for (EVFriendItem *netItem in wself.friends) {
                        
                        if (netItem.name.integerValue == item.name.integerValue) {
                            netItem.selected = YES;
                            [wself changeSelectedStateForFriendItem:netItem isAllSelected:NO];
                        }
                    }
                }
            }
        }
        else
        {
            NSArray *friendArray = [EVFriendItem objectWithDictionaryArray:friends];
            NSMutableArray *friendImUsers = [NSMutableArray arrayWithCapacity:friendArray.count];
            for (EVFriendItem *item in friendArray) {
                [friendImUsers addObject:item.imuser];
            }
            for (EVFanOrFollowerModel *model  in wself.fansOrFollowsArray) {
                if ( [friendImUsers containsObject:model.imuser] )
                {
                    model.followed = YES;
                }
            }
        }
        [wself.tableView reloadData];
    } essionExpire:nil];
}


#pragma mark - getters and setters

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (NSMutableArray *)selectedMembers
{
    if ( _selectedMembers == nil )
    {
        _selectedMembers = [NSMutableArray array];
    }
    return _selectedMembers;
}

- (void)setConfirmTitle:(NSString *)confirmTitle
{
    _confirmTitle = confirmTitle;
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
}

- (NSMutableArray *)filterFriends
{
    if ( !_filterFriends )
    {
        _filterFriends = [NSMutableArray array];
    }
    return _filterFriends;
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

- (void)setFriends:(NSArray *)friends
{
    _friends = friends;

    CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,friends);
    self.dataSource = [_friends subArraysWithString:^NSString *(id obj) {
        EVFriendItem *item = (EVFriendItem *)obj;
        NSString *remarks = [NSString stringWithFormat:@"%@",item.nickname];
        return remarks;
    }];
    CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,self.dataSource);

    self.groupNames = _friends.groupNames;
}

- (void)setFansOrFollowsArray:(NSArray *)fansOrFollowsArray
{
    _fansOrFollowsArray = fansOrFollowsArray;
    self.dataSource = [_fansOrFollowsArray subArraysWithString:^NSString *(id obj) {
        EVFanOrFollowerModel *item = (EVFanOrFollowerModel *)obj;
        NSString *remarks = [NSString stringWithFormat:@"%@",item.nickname];
        return remarks;
    }];
    self.groupNames = _fansOrFollowsArray.groupNames;
}

@end
