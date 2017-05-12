//
//  EVNewsStocksViewController.m
//  elapp
//
//  Created by 周恒 on 2017/5/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsStocksViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsListViewCell.h"
//#import "EVNewsDetailWebController.h"
#import "EVNativeNewsDetailViewController.h"

#import "EVNewsModel.h"
#import "EVCoreDataClass.h"

@interface EVNewsStocksViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *eyesDataArray;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, weak) UILabel *successLabel;


@end

@implementation EVNewsStocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUpView];
//    [self initData];
    

}

- (void)addUpView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-113) style:(UITableViewStyleGrouped)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    headerView.backgroundColor = CCColor(238, 238, 238);
    tableView.tableHeaderView = headerView;
    
    [tableView addRefreshHeaderWithRefreshingBlock:^{
        [self initData];
    }];
    
    [tableView addRefreshFooterWithRefreshingBlock:^{
        [self initMoreData];
    }];
    [tableView startHeaderRefreshing];
    [tableView hideFooter];
}

- (void)initData {
    _start = @"0";
    [self.baseToolManager GETEyesNewsRequestChannelid:@"2" Programid:nil start:_start count:@"20" Success:^(NSDictionary *retinfo) {
        [_tableView endFooterRefreshing];
        [_tableView endHeaderRefreshing];
        if ([_start integerValue]== 0) {
            [self.eyesDataArray removeAllObjects];
        }
        self.start = retinfo[@"next"];
        
//        NSArray *eyesArr =   [EVHVEyesModel objectWithDictionaryArray:retinfo[@"news"]];
        NSArray * eyeArray = retinfo[@"news"];
        for (NSDictionary * dic in eyeArray)
        {
            EVHVEyesModel * model = [EVHVEyesModel yy_modelWithDictionary:dic];
            [self.eyesDataArray addObject:model];
        }
        [self.tableView reloadData];
        _tableView.mj_footer.hidden = NO;
        [self.tableView setFooterState:(eyeArray.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } error:^(NSError *error) {
        [_tableView endFooterRefreshing];
        [_tableView endHeaderRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    }];
}

- (void)initMoreData {
    [self.baseToolManager GETEyesNewsRequestChannelid:@"2" Programid:nil start:_start count:@"20" Success:^(NSDictionary *retinfo) {
        [_tableView endFooterRefreshing];
        [_tableView endHeaderRefreshing];
        if ([_start integerValue]== 0) {
            [self.eyesDataArray removeAllObjects];
        }
        self.start = retinfo[@"next"];
        NSArray * eyeArray = retinfo[@"news"];
        for (NSDictionary * dic in eyeArray) {
            EVHVEyesModel * model = [EVHVEyesModel yy_modelWithDictionary:dic];
            [self.eyesDataArray addObject:model];
        }
        [self.tableView reloadData];
        _start = [NSString stringWithFormat:@"%ld",[_start integerValue] + self.eyesDataArray.count];
        _tableView.mj_footer.hidden = NO;
        [self.tableView setFooterState:(eyeArray.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } error:^(NSError *error) {
        [_tableView endFooterRefreshing];
        [_tableView endHeaderRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eyesDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsListViewCell"];
    if (!newsCell) {
        newsCell = [[NSBundle mainBundle] loadNibNamed:@"EVNewsListViewCell" owner:nil options:nil].firstObject;
        [newsCell setValue:@"EVNewsListViewCell" forKey:@"reuseIdentifier"];
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    newsCell.eyesModel = self.eyesDataArray[indexPath.row];
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVEyesModel * newsModel = _eyesDataArray[indexPath.row];
    
    //添加已读历史记录 字体变灰
    [[EVCoreDataClass shareInstance] insertReadNewsId:newsModel.eyesID];
    newsModel.haveRead = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //普通新闻
    EVNativeNewsDetailViewController *newsWebVC = [[EVNativeNewsDetailViewController alloc] init];
    newsWebVC.newsID = newsModel.eyesID;
    newsWebVC.refreshViewCountBlock = ^()
    {
        [self initData];
    };
    [self.navigationController pushViewController:newsWebVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


- (NSMutableArray *)eyesDataArray
{
    if (!_eyesDataArray) {
        _eyesDataArray = [NSMutableArray array];
    }
    return _eyesDataArray;
}


@end
