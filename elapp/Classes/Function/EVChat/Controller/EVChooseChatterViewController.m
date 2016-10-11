//
//  EVChooseChatterViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//




#define kSectionHeight 70.0f

#import "EVChooseChatterViewController.h"
#import <PureLayout.h>
#import "EVNotifyConversationItem.h"
#import "EVChooseChatterCell.h"
#import "EVNewChatViewController.h"
#import "EVAlertManager.h"
#import "EVSearchBar.h"


@interface EVChooseChatterViewController () <UITableViewDataSource,UITableViewDelegate>

@property ( weak, nonatomic ) EVSearchBar *searchBar;
@property ( strong, nonatomic ) NSArray *dataArray;
@property ( strong, nonatomic ) NSArray *resultArray;


@end

@implementation EVChooseChatterViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI
{
    self.view.backgroundColor = CCBackgroundColor;
    UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc] initWithTitle:kCancel style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelBtnItem)];
    self.navigationItem.rightBarButtonItem = cancelBtnItem;
    self.title = kE_GlobalZH(@"message_choose_user");
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CCBackgroundColor;
    
    EVSearchBar *searchBar = [EVSearchBar cc_SearchBar];
    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
    if ( self.placeHolder == nil )
    {
        self.placeHolder = kE_GlobalZH(@"search_recent_user");
    }
    searchBar.placeholder = self.placeHolder;
    
    self.mySearchDisplaycontroller = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _mySearchDisplaycontroller.searchResultsDataSource = self;
    _mySearchDisplaycontroller.searchResultsDelegate = self;
    
    // 加载数据
    [self loadData];
}

//  从本地缓存中获取私信会话列表
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [EVNotifyConversationItem getConversationArrayFromDBStart:0 count:100 complete:^(NSArray *result) {
        weakSelf.dataArray = result;
        [weakSelf.tableView reloadData];
    }];
}


- (UIView *)sectionHeader
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSectionHeight)];
    sectionHeader.backgroundColor = CCBackgroundColor;
    
    UIView *topView = [[UIView alloc] init];
    [sectionHeader addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startNewChart:)];
    [topView addGestureRecognizer:tapGesture];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = kE_GlobalZH(@"new_chat");
    [topView addSubview:topLabel];
    [topLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [topLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    [topView addSubview:arrowIcon];
    [arrowIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [arrowIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    arrowIcon.image = [UIImage imageNamed:@"personal_find_back"];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    [sectionHeader addSubview:bottomLabel];
    [bottomLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topView withOffset:0];
    [bottomLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [bottomLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    bottomLabel.text = kE_GlobalZH(@"recent_chat");
    bottomLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    
    return sectionHeader;
}

#pragma mark - actions

- (void)clickCancelBtnItem
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)startNewChart:(UITapGestureRecognizer *)recognizer
{
    EVNewChatViewController *chatVC = [[EVNewChatViewController alloc] init];
    chatVC.relayMsgBodies = self.relayMsgBodies;
    chatVC.ext = self.ext;
    chatVC.delegate = self.delegate;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - table view delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.tableView) {
        //  根据联系人名字,昵称搜索
        NSString *searchText = self.mySearchDisplaycontroller.searchBar.text;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.title contains [cd] %@) || (self.nickName contains [cd] %@ ) || (self.name contains [cd] %@)",searchText,searchText,searchText];
        
        self.resultArray = [self.dataArray filteredArrayUsingPredicate:predicate];
        return self.resultArray.count;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVChooseChatterCell *cell = [EVChooseChatterCell cellForTableView:tableView];
    if ( tableView != self.tableView )
    {
        cell.cellItem = [self.resultArray objectAtIndex:indexPath.row];
        return cell;
    }
    cell.cellItem = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self sectionHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EVNotifyConversationItem *item;
    if ( tableView != self.tableView )
    {
        item = [self.resultArray objectAtIndex:indexPath.row];
    }
    else
    {
        item = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
    [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"define_send_user")
                                                message:item.title
                                      cancelButtonTitle:kCancel
                                            comfirmTitle:kOK
                                            WithComfirm:^
    {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
            if ( item.imuser == nil )
            {
                [CCProgressHUD showError:kFailChat];
                return ;
            }
            // 包装要转发的消息
            EMMessage *msg = [[EMMessage alloc] initWithReceiver:item.imuser bodies:weakSelf.relayMsgBodies];
            [weakSelf relayMessage:msg];
        }];
    }
                                                 cancel:NULL
     ];
}

- (void)relayMessage:(EMMessage *)msg
{
    msg.ext = self.ext;
    // 发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(relayCompleteMessage:)] )
    {
        [self.delegate relayCompleteMessage:msg];
    }
}

@end
