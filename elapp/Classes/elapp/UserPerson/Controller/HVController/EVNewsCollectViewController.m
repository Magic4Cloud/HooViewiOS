//
//  EVNewsCollectViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsCollectViewController.h"
#import "EVNewsListViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVBaseNewsModel.h"
#import "EVNewsDetailWebController.h"

@interface EVNewsCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *iNewsTableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@end

@implementation EVNewsCollectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self addTableView];
    
    [self loadData];
    
//    [self.iNewsTableview addRefreshFooterWithRefreshingBlock:^{
//        
//    }];
}


- (void)loadData
{
    [self.baseToolManager GETUserCollectListType:EVCollectTypeNews start:^{
        
    } fail:^(NSError *error) {
        EVLog(@"error %@", error);
    } success:^(NSDictionary *retinfo) {
        NSLog(@"retingo----- %@",retinfo);
        NSString *newsid = retinfo[@"collectlist"];
        NSInteger newsCount = [retinfo[@"count"] integerValue];
        if (newsCount<= 0) {
            self.iNewsTableview.hidden = YES;
            self.nullDataView.hidden = NO;
        }else {
            self.iNewsTableview.hidden = NO;
            self.nullDataView.hidden = YES;
            [self loadNewsDataNewsid:newsid];
        }
    } sessionExpire:^{
        
    }];
}



- (void)addTableView
{
    UITableView *iNewsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight-64) style:(UITableViewStylePlain)];
    iNewsTableview.delegate = self;
    iNewsTableview.dataSource = self;
    iNewsTableview.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    iNewsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:iNewsTableview];
   
    _iNewsTableview = iNewsTableview;
    iNewsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - 44)];
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有收藏资讯噢";
    [self.view addSubview:nullDataView];
    self.nullDataView = nullDataView;
}

- (void)loadNewsDataNewsid:(NSString *)newsid
{
    [self.baseToolManager GETCollectUserNewsID:newsid start:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        
        NSArray *dataArray =    [EVBaseNewsModel objectWithDictionaryArray:retinfo[@"data"]];
        [self.dataArray addObjectsFromArray:dataArray];
        
        [self.iNewsTableview reloadData];
    } error:^(NSError *error) {
        self.iNewsTableview.hidden = YES;
        self.nullDataView.hidden = NO;
    }];
    
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsListViewCell"];
    if (!newsCell) {
        newsCell = [[NSBundle mainBundle] loadNibNamed:@"EVNewsListViewCell" owner:nil options:nil].firstObject;
        
        [newsCell setValue:@"EVNewsListViewCell" forKey:@"reuseIdentifier"];
    }
    newsCell.searchNewsModel = self.dataArray[indexPath.row];
    newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return newsCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVBaseNewsModel *newsModel = self.dataArray[indexPath.row];
    EVNewsDetailWebController *newsVC = [[EVNewsDetailWebController alloc] init];
    newsVC.newsID = newsModel.newsID;
    newsModel.title = newsModel.title;
    newsVC.refreshCollectBlock = ^()
    {
        [self loadData];
    };
    [self.navigationController pushViewController:newsVC animated:YES];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
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
