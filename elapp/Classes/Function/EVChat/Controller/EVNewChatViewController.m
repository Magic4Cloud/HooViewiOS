//
//  EVNewChatViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNewChatViewController.h"
#import "EVChooseChatterCell.h"
#import <PureLayout.h>
#import "EVNotifyConversationItem.h"
#import "EVBaseToolManager.h"
#import "EVUserModel.h"
#import "EVAlertManager.h"
#import "EVLoadingView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"


@interface EVNewChatViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property ( strong, nonatomic ) NSMutableArray *dataArray;      // 数据源
@property ( strong, nonatomic ) EVBaseToolManager *engine;             // 网络请求类
@property ( strong, nonatomic ) NSArray *resultArray;           // 搜索结果
@property (nonatomic, weak) EVLoadingView *loadingView;         // 加载动画视图


@end

@implementation EVNewChatViewController

- (void)dealloc
{
    [_engine cancelAllOperation];
}

- (void)viewDidLoad {
    self.placeHolder = kE_GlobalZH(@"kSearch_follow_user");
    [super viewDidLoad];
}

// 加载数据
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserfriendlistStart:0
                               count:500
                               start:^
    {
        if ( 0 == weakSelf.dataArray.count )
        {
            [weakSelf.loadingView showLoadingView];
        }
    }
                                fail:^(NSError *error)
    {
        [weakSelf.loadingView showFailedViewWithClickBlock:^{
            [weakSelf loadData];
        }];
    }
                             success:^(NSDictionary *result)
    {
        [weakSelf.loadingView destroy];
        NSArray *friends = [result objectForKey:@"friends"];
        for (NSDictionary *dic in friends)
        {
            EVUserModel *friend = [[EVUserModel alloc] init];
            friend.name = [dic objectForKey:@"name"];
            friend.nickname = [dic objectForKey:@"nickname"];
            friend.logourl = [dic objectForKey:@"logourl"];
            friend.imuser = [dic objectForKey:@"imuser"];
            [weakSelf.dataArray addObject:friend];
            [weakSelf.tableView reloadData];
        }
    } essionExpire:^{}
     ];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.remarks contains [cd] %@) || (self.nickname contains [cd] %@ )|| (self.name contains [cd] %@)",searchText,searchText,searchText];
        
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
        cell.userModel = [self.resultArray objectAtIndex:indexPath.row];
        return cell;
    }
    cell.userModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    EVUserModel *model;
    if ( tableView != self.tableView )
    {
        model = [self.resultArray objectAtIndex:indexPath.row];
    }
    else
    {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    NSString *remark = [NSString stringWithFormat:@"%@ %@",model.name,model.nickname];
    [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"define_send_user")
                                                message:remark
                                      cancelButtonTitle:kCancel
                                           comfirmTitle:kOK
                                            WithComfirm:^
     {
         [weakSelf dismissViewControllerAnimated:YES completion:^{
             
             if ( model.imuser != nil )
             {
                 EMMessage *msg = [[EMMessage alloc] initWithReceiver:model.imuser bodies:weakSelf.relayMsgBodies];
                 
                 // 转发消息
                 [weakSelf relayMessage:msg];
             }
             else
             {
                 [CCProgressHUD showError:kFailChat];
             }
         }];
     }
                                                 cancel:NULL
     ];
}

- (EVBaseToolManager *)engine{
    if ( _engine == nil ) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (NSMutableArray *)dataArray
{
    if ( _dataArray == nil )
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

@end
