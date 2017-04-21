//
//  EVHVCenterFansTableView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterFansTableView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVFansOrFocusTableViewCell.h"
#import "EVLoginInfo.h"
#import "EVNullDataView.h"

@interface EVHVCenterFansTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *fansOrFollowers;

@property (nonatomic, strong) EVNullDataView *nullDataView;


@end



@implementation EVHVCenterFansTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"EVFansOrFocusTableViewCell" bundle:nil] forCellReuseIdentifier:@"fansCell"];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addVipUI];
        WEAK(self)
        
        [self addRefreshFooterWithRefreshingBlock:^{
            [weakself loadDataWithname:weakself.WatchVideoInfo.name Start:weakself.fansOrFollowers.count count:20];
        }];
        
    }
    return self;
}

- (void)addVipUI
{
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, ScreenHeight-108)];
    
    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
    
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"他还没有粉丝";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fansOrFollowers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVFansOrFocusTableViewCell *fansCell = [tableView dequeueReusableCellWithIdentifier:@"fansCell" forIndexPath:indexPath];
    
    fansCell.model = self.fansOrFollowers[indexPath.row];
    fansCell.type = FANS;
    return fansCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)loadDataWithname:(NSString *)name Start:(NSInteger)start count:(NSInteger)count{
    __weak typeof(self) weakself = self;

    [self.baseToolManager GETFansListWithName:name startID:start count:count start:^{
        
            } fail:^(NSError *error) {
                [weakself endHeaderRefreshing];
                [weakself endFooterRefreshing];
              
            } success:^(NSArray *fans){
                
                if (start == 0) {
                    weakself.fansOrFollowers = nil;
                }
                [weakself.fansOrFollowers addObjectsFromArray:fans];
                [weakself reloadData];
                [weakself endHeaderRefreshing];
                [weakself endFooterRefreshing];
                
                // 处理数据列表为空的情况，当前页面显示为没有粉丝
                if ( weakself.fansOrFollowers.count )
                {
                    weakself.nullDataView.hidden = YES;
                    [weakself showFooter];
                }
                else
                {
                    weakself.nullDataView.hidden = NO;
                    [weakself hideFooter];
                }
                
                if (weakself.fansOrFollowers.count)
                {
                    if (fans.count < count)
                    {
                        [weakself setFooterState:CCRefreshStateNoMoreData];
                    }
                    else
                    {
                        [weakself setFooterState:CCRefreshStateIdle];
                    }
//                    //数据没有满一屏幕的时候隐藏加载更多
//                    if((ScreenHeight - cellsize) / cellsize >= weakself.fansOrFollowers.count && fans.count < count)
//                    {
//                        [weakself.tableView hideFooter];
//                    }else
//                    {
//                        [weakself.tableView showFooter];
//                    }
                }
                else
                {
                }
            } essionExpire:^{
                //                [EVProgressHUD hideHUDForView:weakself.view];
             
                [weakself endHeaderRefreshing];
                [weakself endFooterRefreshing];
//                EVRelogin(weakself);
            }];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)WatchVideoInfo
{
    _WatchVideoInfo = WatchVideoInfo;
    [self loadDataWithname:WatchVideoInfo.name Start:0 count:20];
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
