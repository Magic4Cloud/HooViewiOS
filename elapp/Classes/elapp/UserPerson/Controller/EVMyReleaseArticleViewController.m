//
//  EVMyReleaseArticleViewController.m
//  elapp
//
//  Created by 周恒 on 2017/4/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyReleaseArticleViewController.h"
#import "EVNewsListViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#import "EVNullDataView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsModel.h"
#import "EVNewsDetailWebController.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"

@interface EVMyReleaseArticleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger start;
}

@property (nonatomic, weak) UITableView *iNewsTableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVNullDataView *nullDataView;

@end

@implementation EVMyReleaseArticleViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTableView];
    
    [self.iNewsTableview startHeaderRefreshing];
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
    
    [self.iNewsTableview addSubview:self.nullDataView];
    
}



- (void)loadNewData
{
    start = 0;
    
    [self.baseToolManager GETMyReleaseListWithUserid:nil type:@"2" start:0 count:20 startBlock:^{
    } fail:^(NSError *error) {
        self.nullDataView.hidden = NO;
        [self.iNewsTableview endHeaderRefreshing];
    } success:^(NSDictionary *videos) {
        [self.iNewsTableview endHeaderRefreshing];
        NSArray * news = videos[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [self.dataArray removeAllObjects];
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
        }
        
        if (news.count == 0)
        {
            self.nullDataView.hidden = NO;
        }
        else
        {
            self.nullDataView.hidden = YES;
        }
        
        if (news.count<20)
        {
            [self.iNewsTableview hideFooter];
        }
        else
        {
            [self.iNewsTableview showFooter];
        }
        start += 20;
        
        [self.iNewsTableview reloadData];
        
    } essionExpire:^{
        [self.iNewsTableview endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];
    
}

- (void)loadMoreData
{
    [self.baseToolManager GETMyReleaseListWithUserid:nil type:@"2" start:start count:20 startBlock:^{
    } fail:^(NSError *error) {
        [self.iNewsTableview endFooterRefreshing];
    } success:^(NSDictionary *videos) {
        [self.iNewsTableview endFooterRefreshing];
        NSArray * news = videos[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
        }
        
        if (news && news.count>0)
        {
            [self.iNewsTableview setFooterState:CCRefreshStateIdle];
            start += 20;
        }
        else
        {
            [self.iNewsTableview setFooterState:CCRefreshStateNoMoreData];
        }
        
        [self.iNewsTableview reloadData];
    } essionExpire:^{
        [self.iNewsTableview endFooterRefreshing];
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
    [self.navigationController pushViewController:newsVC animated:YES];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (EVNullDataView *)nullDataView
{
    if (!_nullDataView) {
        _nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108)];
        _nullDataView.hidden = YES;
        _nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
        _nullDataView.title = @"暂时还没发布文章噢";
    }
    return _nullDataView;
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

@end
