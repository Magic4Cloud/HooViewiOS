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


#import "EVNewsModel.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"
@interface EVNewsCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}

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

    self.title = @"我的收藏";

    [self addTableView];
    
    [self.iNewsTableview startHeaderRefreshing];
    
}

- (void)loadNewData
{
    start = 0;
    NSString * uid = [CCUserDefault objectForKey:CCUSER_NAME];
    [self.baseToolManager GETUserCollectListsWithStart:@"0" count:@"20" userId:uid fail:^(NSError *error) {
        self.nullDataView.hidden = NO;
        [self.iNewsTableview endHeaderRefreshing];
    } success:^(NSDictionary *retinfo) {
        [self.iNewsTableview endHeaderRefreshing];
        NSArray * news = retinfo[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [self.dataArray removeAllObjects];
            
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
        }
        
        self.nullDataView.hidden = self.dataArray.count == 0?NO:YES;
        if (self.dataArray.count == 20)
        {
            [self.iNewsTableview showFooter];
            start += 20;
        }
        else
        {
            [self.iNewsTableview hideFooter];
        }
        
        [self.iNewsTableview reloadData];
        
    } sessionExpire:^{
        [self.iNewsTableview endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];
}

- (void)loadMoreData
{
    NSString * uid = [CCUserDefault objectForKey:CCUSER_NAME];
    [self.baseToolManager GETUserCollectListsWithStart:[NSString stringWithFormat:@"%d",start] count:@"20" userId:uid fail:^(NSError *error) {
        [self.iNewsTableview endFooterRefreshing];
    } success:^(NSDictionary *retinfo) {
        [self.iNewsTableview endFooterRefreshing];
        NSArray * news = retinfo[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            [self.iNewsTableview setFooterState:CCRefreshStateIdle];
            start += news.count;
        }
        else
        {
            [self.iNewsTableview setFooterState:CCRefreshStateNoMoreData];
        }
        
        [self.iNewsTableview reloadData];
        
    } sessionExpire:^{
        [self.iNewsTableview endFooterRefreshing];
        
    }];
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
    iNewsTableview.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    _iNewsTableview = iNewsTableview;
    iNewsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_iNewsTableview registerNib:[UINib nibWithNibName:@"EVOnlyTextCell" bundle:nil] forCellReuseIdentifier:@"EVOnlyTextCell"];
    [_iNewsTableview registerNib:[UINib nibWithNibName:@"EVThreeImageCell" bundle:nil] forCellReuseIdentifier:@"EVThreeImageCell"];
    [_iNewsTableview registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil] forCellReuseIdentifier:@"EVNewsListViewCell"];
    
    [_iNewsTableview addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
    [_iNewsTableview addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
    [_iNewsTableview hideFooter];
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有收藏资讯噢";
    nullDataView.backgroundColor = [UIColor evBackGroundLightGrayColor];
    [_iNewsTableview addSubview:nullDataView];
    self.nullDataView = nullDataView;
    self.nullDataView.hidden = YES;
}

- (void)loadNewsDataNewsid:(NSString *)newsid
{
    [self.baseToolManager GETCollectUserNewsID:newsid start:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        
        NSArray *dataArray =    [EVBaseNewsModel objectWithDictionaryArray:retinfo[@"data"]];
        [self.dataArray addObjectsFromArray:dataArray];
        
        [self.iNewsTableview reloadData];
        self.nullDataView.hidden = self.dataArray.count == 0?NO:YES;
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
    //新闻列表
    EVNewsModel * newsModel = _dataArray[indexPath.row];
    
    if ([newsModel.type isEqualToString:@"0"])
    {
        //普通新闻
        if (newsModel.cover == nil || newsModel.cover.count == 0)
        {
            //没有图片
            EVOnlyTextCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"EVOnlyTextCell"];
            textCell.newsModel = newsModel;
            return textCell;
        }
        else if (newsModel.cover.count == 1)
        {
            //一张图片
            EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsListViewCell"];
            newsCell.consultNewsModel = newsModel;
            return newsCell;
        }
        else if (newsModel.cover.count == 3)
        {
            //三张图片
            EVThreeImageCell * threeImageCell = [tableView dequeueReusableCellWithIdentifier:@"EVThreeImageCell"];
            threeImageCell.newsModel = newsModel;
            return threeImageCell;
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsModel * model = self.dataArray[indexPath.row];
    return model.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsModel * model = self.dataArray[indexPath.row];
    EVNewsDetailWebController *newsVC = [[EVNewsDetailWebController alloc] init];
    newsVC.newsID = model.newsID;
    newsVC.title = model.title;
    newsVC.refreshCollectBlock = ^()
    {
        [self loadNewData];
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
