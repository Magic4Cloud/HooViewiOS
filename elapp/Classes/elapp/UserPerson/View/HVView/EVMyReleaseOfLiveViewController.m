//
//  EVMyReleaseOfLiveViewController.m
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyReleaseOfLiveViewController.h"

#import "EVReleaseImageWithTextLiveCell.h"

#import "EVUserVideoModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVHVWatchViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVNullDataView.h"
//

#import "EVShopLiveCell.h"

//#import "EVHVCenterImageLiveViewCell.h"
//#import "EVMyVideoTableViewCell.h"

@interface EVMyReleaseOfLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, copy) NSString *next;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, assign) NSInteger textLiveState;


@end

@implementation EVMyReleaseOfLiveViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self initDatasource];
    [self addVipUI];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVReleaseImageWithTextLiveCell" bundle:nil] forCellReuseIdentifier:@"EVReleaseImageWithTextLiveCell"];
<<<<<<< HEAD
    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];
=======
    [self.tableView registerNib:[UINib nibWithNibName:@"EVReleaseImageWithTextLiveCell" bundle:nil] forCellReuseIdentifier:@"EVReleaseImageWithTextLiveCell"];
    
>>>>>>> master
}

- (void)addVipUI
{
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108)];
    [self.view addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还不是主播噢";

}


#pragma mark - 🌐Networks

- (void)initDatasource {
    NSString *type = @"video";
    NSInteger start = 0;
    __weak typeof(self) weakself = self;
    [self.baseToolManager GETUserVideoListWithName:@"17123425" type:type start:start count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
    } success:^(NSArray *videos) {
        
        
        if (start == 0)
        {
            [weakself.videos removeAllObjects];
        }
        [weakself.videos addObjectsFromArray:videos];
        [weakself.tableView reloadData];
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        
        if ( weakself.videos.count )
        {
            [weakself.tableView showFooter];
        }
        else
        {
            [weakself.tableView hideFooter];
        }
        if (weakself.videos.count)
        {
            
            if (videos.count < 20)
            {
                [weakself.tableView setFooterState:CCRefreshStateNoMoreData];
            }
            else
            {
                [weakself.tableView setFooterState:CCRefreshStateIdle];
            }
            
            
        }
        
        if (start == 0 && videos.count == 0) {
            weakself.nullDataView.hidden = NO;
        }
        else
        {
            weakself.nullDataView.hidden = YES;
        }
        [weakself.tableView reloadData];
    } essionExpire:^{
        [weakself.tableView endHeaderRefreshing];
        [weakself.tableView endFooterRefreshing];
        EVRelogin(weakself);
    }];

}


- (void)loadIsHaveTextLive
{
    WEAK(self)
    [self.baseToolManager GETIsHaveTextLiveOwnerid:@"17123425" streamid:nil success:^(NSDictionary *retinfo) {
        if ([retinfo[@"retval"] isEqualToString:@"ok"]) {
            weakself.textLiveState = [retinfo[@"retinfo"][@"data"][@"state"] integerValue];
        }
        [weakself.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}



#pragma mark -👣 Target actions


#pragma mark - 🌺 TableView Delegate & Datasource
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
    if ((self.textLiveState == 2 && section == 0) || (section == 1)) {
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
//    else if (section == 1) {
//        UIView *backView = [[UIView alloc] init];
//        backView.frame = CGRectMake(0, 0, ScreenWidth, 40);
//        backView.backgroundColor = [UIColor whiteColor];
//        
//        UILabel *nameLabel  = [[UILabel alloc] init];
//        nameLabel.frame = CGRectMake(16, 10, ScreenWidth, 20);
//        nameLabel.font = [UIFont systemFontOfSize:14.f];
//        nameLabel.textColor = [UIColor evTextColorH2];
//        [backView addSubview:nameLabel];
//        nameLabel.text = @"往期视频直播";
//        return backView;
//    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, ScreenWidth, 10);
    backView.backgroundColor = [UIColor evBackgroundColor];
    
    return backView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.textLiveState != 2) {
        static NSString * identifer = @"EVReleaseImageWithTextLiveCell";
        EVReleaseImageWithTextLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.userModel = self.userModel;
        return cell;
    }
    
    static NSString * identifer = @"EVShopLiveCell";
    EVShopLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.watchModel = self.videos[indexPath.row];
    return cell;

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


#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
        _tableView.backgroundColor = [UIColor evBackGroundLightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    [self loadIsHaveTextLive];
    [self.tableView reloadData];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
