//
//  EVHVCenterLiveView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterLiveView.h"
#import "EVHVCenterImageLiveViewCell.h"
#import "EVMyVideoTableViewCell.h"
#import "EVUserVideoModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVHVWatchViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVNullDataView.h"

@interface EVHVCenterLiveView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, copy) NSString *next;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, assign) NSInteger textLiveState;


@end

@implementation EVHVCenterLiveView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"livecell"];
        self.tableFooterView = [UIView new];
        WEAK(self)

        [self getDataWithName:weakself.name start:0 count:20];
        [self addRefreshFooterWithRefreshingBlock:^{
            [weakself getDataWithName:weakself.name start:weakself.videos.count count:20];
        }];
        
        
     
        [self addVipUI];
    }
    return self;
}

- (void)addVipUI
{

    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-108)];

    [self addSubview:nullDataView];
    self.nullDataView = nullDataView;
//    [nullDataView autoPinEdgesToSuperviewEdges];
    
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"他还没有直播";
//    [nullDataView addButtonTarget:self action:@selector(nullDataClick) forControlEvents:(UIControlEventTouchUpInside)];
}


//- (void)nullDataClick
//{
//    [EVProgressHUD showSuccess:@"申请成功"];
//}

- (void)getDataWithName:(NSString *)name {
    _name = name;
    [self getDataWithName:name start:0 count:20];
}

- (void)getDataWithName:(NSString *)name start:(NSInteger)start count:(NSInteger)count
{
    NSString *type = @"video";
    
    __weak typeof(self) weakself = self;
    [self.baseToolManager GETUserVideoListWithName:name type:type start:start count:count startBlock:^{
        
    } fail:^(NSError *error) {
        [weakself endHeaderRefreshing];
        [weakself endFooterRefreshing];
    } success:^(NSArray *videos) {
        
        
        if (start == 0)
        {
            [weakself.videos removeAllObjects];
        }
        [weakself.videos addObjectsFromArray:videos];
        [weakself reloadData];
        [weakself endHeaderRefreshing];
        [weakself endFooterRefreshing];
        
        if ( weakself.videos.count )
        {
            [weakself showFooter];
        }
        else
        {
            [weakself hideFooter];
        }
        if (weakself.videos.count)
        {
            
            if (videos.count < count)
            {
                [weakself setFooterState:CCRefreshStateNoMoreData];
            }
            else
            {
                [weakself setFooterState:CCRefreshStateIdle];
            }
            
            
        }
        
        if (start == 0 && videos.count == 0) {
            weakself.nullDataView.hidden = NO;
        }
        else
        {
            weakself.nullDataView.hidden = YES;
        }
        
    } essionExpire:^{
        [weakself endHeaderRefreshing];
        [weakself endFooterRefreshing];
        EVRelogin(weakself);
    }];
}

- (void)loadIsHaveTextLive
{
    WEAK(self)
    [self.baseToolManager GETIsHaveTextLiveOwnerid:self.userModel.name streamid:nil success:^(NSDictionary *retinfo) {
        if ([retinfo[@"retval"] isEqualToString:@"ok"]) {
           weakself.textLiveState = [retinfo[@"retinfo"][@"data"][@"state"] integerValue];
        }
        [weakself reloadData];
    } error:^(NSError *error) {
        
    }];
}
#pragma mark - UITableView M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.textLiveState != 2 && section == 0) {
        return 1;
    }
    return self.videos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.nullDataView.hidden == NO) {
        return 0;
    }
    if (self.textLiveState == 2) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.textLiveState != 2) {
        return 96;
    }
    
    return 104;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.textLiveState != 2) {
        return 10;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.textLiveState != 2) {
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.textLiveState == 2 && section == 0) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel  = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(16, 10, ScreenWidth, 20);
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.textColor = [UIColor evTextColorH2];
        [backView addSubview:nameLabel];
        nameLabel.text = @"往期视频直播";
        return backView;
    }else if (section == 1) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel  = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(16, 10, ScreenWidth, 20);
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.textColor = [UIColor evTextColorH2];
        [backView addSubview:nameLabel];
        nameLabel.text = @"往期视频直播";
        return backView;
    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, ScreenWidth, 10);
    backView.backgroundColor = [UIColor evBackgroundColor];
    
    return backView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.textLiveState != 2) {
        EVHVCenterImageLiveViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        if (Cell == nil) {
            Cell = [[NSBundle mainBundle] loadNibNamed:@"EVHVCenterImageLiveViewCell" owner:nil options:nil].firstObject;
        }
        Cell.userModel = self.userModel;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }
    EVMyVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (videoCell == nil) {
        videoCell = [[NSBundle mainBundle] loadNibNamed:@"EVMyVideoTableViewCell_6" owner:nil options:nil].firstObject;
        [videoCell setValue:@"videoCell" forKey:@"reuseIdentifier"];
        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    videoCell.videoModel = self.videos[indexPath.row];
    
    return videoCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && self.textLiveState != 2) {
        if (self.textLiveBlock) {
            self.textLiveBlock(self.userModel);
        }
    }else {
        EVWatchVideoInfo *videoModel = self.videos[indexPath.row];
        if (self.videoBlock) {
            self.videoBlock(videoModel);
        }
    }
}


- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    [self loadIsHaveTextLive];
    [self reloadData];
}





- (NSMutableArray *)videos
{
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
