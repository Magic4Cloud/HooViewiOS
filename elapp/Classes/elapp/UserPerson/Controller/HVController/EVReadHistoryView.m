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

#import "EVNewsModel.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"
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
    
    [nTableView registerNib:[UINib nibWithNibName:@"EVOnlyTextCell" bundle:nil] forCellReuseIdentifier:@"EVOnlyTextCell"];
    [nTableView registerNib:[UINib nibWithNibName:@"EVThreeImageCell" bundle:nil] forCellReuseIdentifier:@"EVThreeImageCell"];
    [nTableView registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil] forCellReuseIdentifier:@"EVNewsListViewCell"];
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有看过任何资讯噢";
    nullDataView.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 108);
    
    [self loadNewData];
}

- (void)loadNewData
{
    WEAK(self)
    [self.baseToolManager GETUserHistoryListTypeNew:1 fail:^(NSError *error) {
        weakself.nullDataView.hidden = NO;
        weakself.nTableView.hidden = YES;
    } success:^(NSDictionary *retinfo) {
        NSArray * news = retinfo[@"news"];
        
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [self.dataArray removeAllObjects];
            
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            self.nTableView.hidden = NO;
            self.nullDataView.hidden = YES;
            
            [self.nTableView reloadData];
        }
        else
        {
            self.nTableView.hidden = YES;
            self.nullDataView.hidden = NO;
        }
        
    } sessionExpire:^{
        
    }];
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
    EVNewsModel * model = self.dataArray[indexPath.row];
    return model.cellHeight;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EVBaseNewsModel *baseNewsModel = self.dataArray[indexPath.row];
    EVNewsModel * newsModel = _dataArray[indexPath.row];
    if (self.pushWatchBlock) {
        self.pushWatchBlock(newsModel);
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
