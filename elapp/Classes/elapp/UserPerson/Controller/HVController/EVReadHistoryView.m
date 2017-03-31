//
//  EVReadHistoryView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVReadHistoryView.h"
#import "EVNewsListViewCell.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVBaseNewsModel.h"

@interface EVReadHistoryView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *nTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, copy) NSString *next;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@end

@implementation EVReadHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UITableView *nTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 108) style:(UITableViewStylePlain)];
    [self addSubview:nTableView];
    nTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    nTableView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    self.nTableView = nTableView;
    nTableView.delegate = self;
    nTableView.dataSource = self;
    nTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    nTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有看过任何资讯噢";
    nullDataView.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 108);
    
    [self loadData];
}

- (void)loadData
{
    WEAK(self)
    [self.baseToolManager GETUserHistoryListType:EVCollectTypeNews start:^{
        
    } fail:^(NSError *error) {
        weakself.nullDataView.hidden = NO;
        weakself.nTableView.hidden = YES;
    } success:^(NSDictionary *retinfo) {
        NSString *historyList = retinfo[@"historylist"];
        if (historyList.length > 0) {
            weakself.nullDataView.hidden = YES;
            weakself.nTableView.hidden = NO;
            [self loadNewsList:historyList];
        }else {
            weakself.nullDataView.hidden = NO;
            weakself.nTableView.hidden = YES;
        }
    } sessionExpire:^{
        
    }];

}

- (void)loadNewsList:(NSString *)news
{
    [self.baseToolManager GETCollectUserNewsID:news start:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        
        NSArray *newsArr = [EVBaseNewsModel objectWithDictionaryArray:retinfo[@"data"]];
        [self.dataArray addObjectsFromArray:newsArr];
        [self.nTableView reloadData];
    } error:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"readCell"];
    if (!newsCell) {
        
        newsCell = [[NSBundle mainBundle] loadNibNamed:@"EVNewsListViewCell" owner:nil options:nil].firstObject;
    }
    newsCell.searchNewsModel = self.dataArray[indexPath.row];
    newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVBaseNewsModel *baseNewsModel = self.dataArray[indexPath.row];
    if (self.pushWatchBlock) {
        self.pushWatchBlock(baseNewsModel);
    }
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
@end
