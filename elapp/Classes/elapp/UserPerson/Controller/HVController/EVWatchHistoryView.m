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

#import "EVVideoAndLiveModel.h"

#import "EVShopLiveCell.h"
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
    nTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    nTableView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    self.nTableView = nTableView;
    nTableView.delegate = self;
    nTableView.dataSource = self;
    [nTableView registerNib:[UINib nibWithNibName:@"EVLiveListViewCell" bundle:nil]  forCellReuseIdentifier:@"watchCell"];
    nTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    nTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [nTableView registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];
    
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还没有收看视频/直播噢";
    nullDataView.buttonTitle = @"去收看";
    nullDataView.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 108);
    
    [self loadNewData];
}

- (void)loadNewData
{
    WEAK(self)
    [self.baseToolManager GETUserHistoryListTypeNew:0 fail:^(NSError *error) {
        weakself.nullDataView.hidden = NO;
        weakself.nTableView.hidden = YES;
    } success:^(NSDictionary *retinfo) {
        NSArray * videolives = retinfo[@"videolive"];
        
        if ([videolives isKindOfClass:[NSArray class]] && videolives.count>0) {
            [self.dataArray removeAllObjects];
            
            [videolives enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * model = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
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
    //视频列表
    EVVideoAndLiveModel * videoModel = _dataArray[indexPath.row];
    
    EVShopLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EVShopLiveCell"];
    cell.liveModel = videoModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVVideoAndLiveModel * videoModel = _dataArray[indexPath.row];
    if (self.pushWatchBlock) {
        self.pushWatchBlock(videoModel);
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
