//
//  EVRecorededVideoListController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVRecorededVideoListController.h"
#import "EVRecoredItemCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVWatchVideoInfo.h"
#import "EVHVWatchViewController.h"
#import "EVLoginViewController.h"


@interface EVRecorededVideoListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *start;
@end

@implementation EVRecorededVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUpView];
    

    [self loadVideoDataStart:@"0" count:@"20"];

    WEAK(self)
    [self.listTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadVideoDataStart:@"0" count:@"20"];
    }];
    
    [self.listTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadVideoDataStart:weakself.start count:@"20"];
    }];
}

- (void)addUpView
{
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, EVContentHeight) style:(UITableViewStylePlain)];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    self.listTableView = listTableView;
    self.listTableView.rowHeight = 70 + ScreenWidth*9/16;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)loadVideoDataStart:(NSString *)start count:(NSString *)count
{
    [self.baseToolManager GETGoodVideoListStart:start count:count fail:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    } success:^(NSDictionary *info) {
        self.start = info[@"retinfo"][@"next"];
        [self endRefreshing];
        if ([info[@"retinfo"][@"start"] integerValue]== 0) {
            [self.dataArray removeAllObjects];
        }
        NSArray *videoArr = [EVWatchVideoInfo objectWithDictionaryArray:info[@"retinfo"][@"videos"]];
        [self.dataArray addObjectsFromArray:videoArr];
        [self.listTableView reloadData];
        [self.listTableView setFooterState:(videoArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVRecoredItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EVRecoredItemCell" owner:nil options:nil].firstObject;
        [cell setValue:@"itemCell" forKey:@"reuseIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.watchVideoInfo = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *sessionID = [self.baseToolManager getSessionIdWithBlock:nil];
//    
//    if (sessionID == nil || [sessionID isEqualToString:@""]) {
//        [self loginView];
//        return;
//    }
    
    EVWatchVideoInfo *WatchInfo = self.dataArray[indexPath.row];
    EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
    watchViewVC.watchVideoInfo = WatchInfo;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loginView
{
    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
    [self presentViewController:navighaVC animated:YES completion:nil];
}


- (void)endRefreshing
{
    [self.listTableView endHeaderRefreshing];
    [self.listTableView endFooterRefreshing];
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
