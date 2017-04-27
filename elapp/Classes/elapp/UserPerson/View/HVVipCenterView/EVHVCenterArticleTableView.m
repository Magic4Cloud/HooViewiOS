//
//  EVHVCenterArticleTableView.m
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterArticleTableView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVLoginInfo.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsModel.h"
#import "EVNewsDetailWebController.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"


@interface EVHVCenterArticleTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *fansOrFollowers;

@property (nonatomic, strong) EVNullDataView *nullDataView;

@end

@implementation EVHVCenterArticleTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        
        [self registerNib:[UINib nibWithNibName:@"EVOnlyTextCell" bundle:nil] forCellReuseIdentifier:@"EVOnlyTextCell"];
        [self registerNib:[UINib nibWithNibName:@"EVThreeImageCell" bundle:nil] forCellReuseIdentifier:@"EVThreeImageCell"];
        [self registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil] forCellReuseIdentifier:@"EVNewsListViewCell"];
        
        
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addVipUI];
        [self addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
        [self addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
        [self hideFooter];
        [self startHeaderRefreshing];
        
//        WEAK(self)
//        [self addRefreshFooterWithRefreshingBlock:^{
//            [weakself loadDataWithname:weakself.WatchVideoInfo.name Start:weakself.fansOrFollowers.count count:20];
//        }];
        
    }
    return self;
}

- (void)addVipUI
{
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-108)];
    
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"没有相关文章奥";
}


- (void)loadNewData
{
    start = 0;
    NSString * uid = [CCUserDefault objectForKey:CCUSER_NAME];
    [self.baseToolManager GETUserCollectListsWithStart:@"0" count:@"20" userId:uid fail:^(NSError *error) {
        self.nullDataView.hidden = NO;
        [self endHeaderRefreshing];
    } success:^(NSDictionary *retinfo) {
        [self endHeaderRefreshing];
        NSArray * news = retinfo[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [self.fansOrFollowers removeAllObjects];
            
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.fansOrFollowers addObject:model];
            }];
        }
        
        self.nullDataView.hidden = self.fansOrFollowers.count == 0?NO:YES;
        if (self.fansOrFollowers.count == 20)
        {
            [self showFooter];
            start += 20;
        }
        else
        {
            [self hideFooter];
        }
        
        [self reloadData];
        
    } sessionExpire:^{
        [self endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];
}

- (void)loadMoreData
{
    NSString * uid = [CCUserDefault objectForKey:CCUSER_NAME];
    [self.baseToolManager GETUserCollectListsWithStart:[NSString stringWithFormat:@"%d",start] count:@"20" userId:uid fail:^(NSError *error) {
        [self endFooterRefreshing];
    } success:^(NSDictionary *retinfo) {
        [self endFooterRefreshing];
        NSArray * news = retinfo[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.fansOrFollowers addObject:model];
            }];
            
            [self setFooterState:CCRefreshStateIdle];
            start += news.count;
        }
        else
        {
            [self setFooterState:CCRefreshStateNoMoreData];
        }
        
        [self reloadData];
        
    } sessionExpire:^{
        [self endFooterRefreshing];
        
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fansOrFollowers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //新闻列表
    EVNewsModel * newsModel = _fansOrFollowers[indexPath.row];
    
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
    EVNewsModel * model = self.fansOrFollowers[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsModel *articleModel = self.fansOrFollowers[indexPath.row];
    if (self.ArticleBlock) {
        self.ArticleBlock(articleModel);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//- (void)loadDataWithname:(NSString *)name Start:(NSInteger)start count:(NSInteger)count{
//    NSString *type = @"2";
//    
//    [self.baseToolManager GETMyReleaseListWithUserid:self.WatchVideoInfo.name type:type start:0 count:20 startBlock:^{
//        
//    } fail:^(NSError *error) {
//        NSLog(@"error = %@",error);
//    } success:^(NSDictionary *videos) {
//        NSLog(@"videos = %@",videos);
//        NSArray * news = videos[@"news"];
//        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
//            [self.fansOrFollowers removeAllObjects];
//            
//            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
//                [self.fansOrFollowers addObject:model];
//            }];
//            
//            self.hidden = NO;
//            self.nullDataView.hidden = YES;
//            
//            [self reloadData];
//        }
//        else
//        {
//            self.hidden = YES;
//            self.nullDataView.hidden = NO;
//        }
//        
//    } essionExpire:^{
//    }];
//}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)WatchVideoInfo
{
    _WatchVideoInfo = WatchVideoInfo;
    [self loadNewData];
//    [self loadDataWithname:WatchVideoInfo.name Start:0 count:20];
}

- (NSMutableArray *)fansOrFollowers
{
    if (!_fansOrFollowers) {
        _fansOrFollowers = [NSMutableArray array];
    }
    return _fansOrFollowers;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
