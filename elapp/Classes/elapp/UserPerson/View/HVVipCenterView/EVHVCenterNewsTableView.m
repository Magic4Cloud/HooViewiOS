//
//  EVHVCenterNewsTableView.m
//  elapp
//
//  Created by 周恒 on 2017/4/28.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterNewsTableView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVLoginInfo.h"
#import "EVNullDataView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsModel.h"
//#import "EVNewsDetailWebController.h"
#import "EVNativeNewsDetailViewController.h"

#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVNewsListViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"


@interface EVHVCenterNewsTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *fansOrFollowers;

@property (nonatomic, strong) EVNullDataView *nullDataView;


@end

@implementation EVHVCenterNewsTableView

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
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-400)];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"没有相关文章奥";
    self.tableFooterView = nullDataView;
}


- (void)loadNewData
{
    start = 0;
    [EVProgressHUD showIndeterminateForView:self];
    [self.baseToolManager GETMyReleaseListWithUserid:self.WatchVideoInfo.name type:@"2" start:0 count:20 startBlock:^{
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self];
        self.nullDataView.hidden = NO;
        [self endHeaderRefreshing];
    } success:^(NSDictionary *videos) {
        [self endHeaderRefreshing];
        [EVProgressHUD hideHUDForView:self];
        NSArray * news = videos[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [self.fansOrFollowers removeAllObjects];
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.fansOrFollowers addObject:model];
            }];
            
        }
        
        self.nullDataView.hidden = self.fansOrFollowers.count == 0?NO:YES;
        if (news.count<20)
        {
            [self hideFooter];
        }
        else
        {
            [self showFooter];
        }
        start += 20;
        
        [self reloadData];
        
    } essionExpire:^{
        [EVProgressHUD hideHUDForView:self];
        [self endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];

}

- (void)loadMoreData
{
    
    [self.baseToolManager GETMyReleaseListWithUserid:self.WatchVideoInfo.name type:@"2" start:start count:20 startBlock:^{
    } fail:^(NSError *error) {
        [self endFooterRefreshing];
    } success:^(NSDictionary *videos) {
        [self endFooterRefreshing];
        NSArray * news = videos[@"news"];
        if ([news isKindOfClass:[NSArray class]] && news.count>0) {
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [self.fansOrFollowers addObject:model];
            }];
            
        }
        
        if (news && news.count>0)
        {
            [self setFooterState:CCRefreshStateIdle];
            start += 20;
        }
        else
        {
            [self setFooterState:CCRefreshStateNoMoreData];
        }
        
        [self reloadData];
    } essionExpire:^{
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



- (void)setWatchVideoInfo:(EVWatchVideoInfo *)WatchVideoInfo
{
    _WatchVideoInfo = WatchVideoInfo;

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
