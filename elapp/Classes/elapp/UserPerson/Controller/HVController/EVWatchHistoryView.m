//
//  EVWatchHistoryView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVWatchHistoryView.h"
#import "EVNullDataView.h"
#import "EVLiveListViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"


@interface EVWatchHistoryView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *nTableView;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *next;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@end

@implementation EVWatchHistoryView

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
    self.nTableView = nTableView;
    nTableView.delegate = self;
    nTableView.dataSource = self;
    [nTableView registerNib:[UINib nibWithNibName:@"EVLiveListViewCell" bundle:nil]  forCellReuseIdentifier:@"watchCell"];
    nTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    nTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    [nTableView addRefreshHeaderWithRefreshingBlock:^{
        [self loadData];
    }];
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有收看视频/直播噢";
    nullDataView.buttonTitle = @"去收看";
    nullDataView.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 108);
    
    [self loadData];
}

- (void)loadData
{
    WEAK(self)
    [self.baseToolManager GETUserHistoryListType:EVCollectTypeVideo start:^{
        
    } fail:^(NSError *error) {
        weakself.nullDataView.hidden = NO;
        weakself.nTableView.hidden = YES;
    } success:^(NSDictionary *retinfo) {
        NSLog(@"watchistory------  %@",retinfo);
        NSString *historyList = retinfo[@"historylist"];
        if (historyList.length > 0) {
            weakself.nullDataView.hidden = YES;
            weakself.nTableView.hidden = NO;
            [weakself loadListData:historyList];
        }else {
            weakself.nullDataView.hidden = NO;
            weakself.nTableView.hidden = YES;
        }
       
    } sessionExpire:^{
        
    }];
}

- (void)loadListData:(NSString *)data
{
    WEAK(self)
    [self.baseToolManager GETVideoInfosList:data fail:^(NSError *error) {
            [weakself.nTableView endHeaderRefreshing];
        weakself.nullDataView.hidden = NO;
        weakself.nTableView.hidden = YES;
    } success:^(NSDictionary *info) {
        [weakself.nTableView endHeaderRefreshing];
        weakself.nullDataView.hidden = YES;
        weakself.nTableView.hidden = NO;
  
        [self.dataArray removeAllObjects];
        
        NSArray *dataArray = [EVWatchVideoInfo objectWithDictionaryArray:info[@"videos"]];
        NSArray *dictAry = info[@"videos"];
        for (NSInteger i = 0; i < dataArray.count; i++) {
            EVWatchVideoInfo *info = dataArray[i];
            NSDictionary *dict = dictAry[i];
            info.nickname = dict[@"owner"][@"nickname"];
            
        }
        [self.dataArray addObjectsFromArray:dataArray];
        [self.nTableView reloadData];
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
    EVLiveListViewCell *listCell  = [tableView dequeueReusableCellWithIdentifier:@"watchCell" forIndexPath:indexPath];
    listCell.watchVideoInfo = self.dataArray[indexPath.row];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVWatchVideoInfo *watchVideoInfo = self.dataArray[indexPath.row];
    if (self.pushWatchBlock) {
        self.pushWatchBlock(watchVideoInfo);
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
