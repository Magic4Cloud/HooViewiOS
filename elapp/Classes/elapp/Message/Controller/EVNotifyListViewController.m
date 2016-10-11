//
//  EVNotifyListViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotifyListViewController.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVNotifyList.h"
#import "EVTableNotifListViewCell.h"
#import "EVNotifyItem.h"
#import "SRRefreshView.h"
#import "EVChooseChatterViewController.h"
#import "EVBaseToolManager+EVMessageAPI.h"

#define kNotifyListRequstCount 10

const NSString *const notifyListCellID = @"notifyList";

@interface EVNotifyListViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,CCChooseChatterDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notifmessages;//所有消息列表
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (assign, nonatomic) BOOL isLoading;


@end

@implementation EVNotifyListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUptable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)dealloc
{
    CCLog(@"----===是否===----");
    [_engine cancelAllOperation];
    _engine = nil;
    _notifmessages = nil;
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

#pragma mark -  getter
- (SRRefreshView *)slimeView
{
    if (_slimeView == nil)
    {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}


- (NSMutableArray *)notifmessages{
    if ( _notifmessages == nil ) {
        _notifmessages = [NSMutableArray array];
    }
    return _notifmessages;
}

-(EVBaseToolManager *)engine
{
    if(!_engine){
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifmessages.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [EVTableNotifListViewCell cellHeightForCellItem:self.notifmessages[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVTableNotifListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)notifyListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EVNotifyList *model = self.notifmessages[indexPath.row];
    cell.cellItem = model;
    cell.iconURL = self.notiItem.icon;
    return cell;
}

/**设置ui*/
-(void)setUptable
{
    CGRect frame = self.view.bounds;
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = self.notiItem.title;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CCBackgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [tableView addSubview:self.slimeView];
    
    //加载xib
    [tableView registerNib:[UINib nibWithNibName:@"EVTableNotifListViewCell" bundle:nil] forCellReuseIdentifier:(NSString *)notifyListCellID];
    //发送请求
    [self refreshMessagesStart:0 count:kNotifyListRequstCount];
}

- (void)refreshMessagesStart:(NSInteger)start count:(NSInteger)count
{
    if ( self.isLoading == YES )
    {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.engine GETMessageitemlistStart:start count:count
                              groupid:self.notiItem.groupid
                                start:^
    {
        self.isLoading = YES;
        
    }
                                 fail:^(NSError *error)
    {
        [weakSelf.slimeView endRefresh];
        self.isLoading = NO;
        [CCProgressHUD showError:@""toView:weakSelf.view];
        if ( error.userInfo[kCustomErrorKey] )
        {
            
        }
        else
        {
    
        }
    }
                              success:^(id messageData)
    {
        [weakSelf.slimeView endRefresh];
        self.isLoading = NO;
        NSArray *messageGroupslist= messageData[@"items"];
        if ( messageGroupslist.count < count )
        {
// fix by 杨尚彬  测试
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.slimeView removeFromSuperview];
            });
            CCLog(@"消失");
        }
        for (NSInteger i = 0; i < messageGroupslist.count; i ++)
        {
            NSDictionary *dic = [messageGroupslist objectAtIndex:i];
            EVNotifyList *item = [[EVNotifyList alloc] init];
            NSDictionary *content = [dic objectForKey:@"content"];
            NSDictionary *data = [content objectForKey:@"data"];
            item.content = [data objectForKey:@"text"];
            item.create_time = [dic objectForKey:@"time"];
            [weakSelf.notifmessages insertObject:item atIndex:0];
        }
        [weakSelf.tableView reloadData];
        //  第一次请求的时候 直接滑动到底部
        if ( start == 0 )
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf scrollViewToBottom];
            });

//            [weakSelf performSelector:@selector(scrollViewToBottom) withObject:nil afterDelay:0.005];
        }
    }];
}

- (void)scrollViewToBottom
{
    if ( self.notifmessages.count > 1 )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)self.notifmessages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshMessagesStart:self.notifmessages.count count:kNotifyListRequstCount];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView)
    {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView)
    {
        [_slimeView scrollViewDidEndDraging];
    }
}


@end
