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
    [self initData];
    

}

- (void)addUpView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight-117) style:(UITableViewStyleGrouped)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView addRefreshHeaderWithRefreshingBlock:^{
        [self initData];
    }];
    
    [tableView addRefreshFooterWithRefreshingBlock:^{
        [self initMoreData];
    }];
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
        NSArray *eyesArr =   [EVHVEyesModel objectWithDictionaryArray:retinfo[@"news"]];
        if (eyesArr.count > 0) {
            
        }
        [self.eyesDataArray addObjectsFromArray:eyesArr];
        [self.tableView reloadData];
        _tableView.mj_footer.hidden = NO;
        [self.tableView setFooterState:(eyesArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
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
        NSArray *eyesArr =   [EVHVEyesModel objectWithDictionaryArray:retinfo[@"news"]];
        if (eyesArr.count > 0) {
            
        }
        [self.eyesDataArray addObjectsFromArray:eyesArr];
        [self.tableView reloadData];
        _start = [NSString stringWithFormat:@"%ld",[_start integerValue] + self.eyesDataArray.count];
        _tableView.mj_footer.hidden = NO;
        [self.tableView setFooterState:(eyesArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
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
