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
#import "EVVideoAndLiveModel.h"
#import "EVShopLiveCell.h"

#import "EVMyTextLiveViewController.h"

#import "EVLoginInfo.h"

@interface EVMyReleaseOfLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int start;
}
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
    
    [self addVipUI];
    
    [self.tableView startHeaderRefreshing];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVReleaseImageWithTextLiveCell" bundle:nil] forCellReuseIdentifier:@"EVReleaseImageWithTextLiveCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];
    [self.tableView addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView hideFooter];
}

- (void)addVipUI
{
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108)];
    [self.tableView addSubview:nullDataView];
    self.nullDataView = nullDataView;
    nullDataView.hidden = YES;
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"您还不是主播噢";

}


#pragma mark - 🌐Networks
- (void)loadNewData
{
    start = 0;
    [self.baseToolManager GETMyReleaseListWithUserid:nil type:@"0" start:0 count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        self.nullDataView.hidden = NO;
        [self.tableView endHeaderRefreshing];
    } success:^(NSDictionary *videos) {
        [self.tableView endHeaderRefreshing];
        NSDictionary *dictionary = videos[@"textlive"];
        NSArray * videoArray = videos[@"videolive"];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            EVUserModel *textLiveModel = [EVUserModel yy_modelWithDictionary:dictionary];
            self.userModel = textLiveModel;
        }
        
        self.textLiveState = [videos[@"textlive"][@"state"] integerValue];
        
        if (videoArray && videoArray.count>0) {
            __weak typeof(self) weakSelf = self;
            [weakSelf.videos removeAllObjects];
            [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.videos addObject:livemodel];
                
            }];
        }
        
        if (videoArray.count == 0)
        {
            self.nullDataView.hidden = NO;
        }
        else
        {
            self.nullDataView.hidden = YES;
        }
        
        if (videos.count<20)
        {
            [self.tableView hideFooter];
        }
        else
        {
            [self.tableView showFooter];
        }
        start += 20;

        [self.tableView reloadData];
        
    } essionExpire:^{
        [self.tableView endHeaderRefreshing];
        self.nullDataView.hidden = NO;
    }];

}

- (void)loadMoreData
{
    [self.baseToolManager GETMyReleaseListWithUserid:self.userModel.name type:@"0" start:start count:20 startBlock:^{
        
    } fail:^(NSError *error) {
        [self.tableView endFooterRefreshing];
    } success:^(NSDictionary *videos) {
        [self.tableView endFooterRefreshing];

        NSArray * videoArray = videos[@"videolive"];
        if (videoArray && videoArray.count>0) {
            __weak typeof(self) weakSelf = self;
                        [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.videos addObject:livemodel];
                
            }];
        }
        
        if (videoArray && videoArray.count>0)
        {
            [self.tableView setFooterState:CCRefreshStateIdle];
        }
        else
        {
            [self.tableView setFooterState:CCRefreshStateNoMoreData];
        }
        start += 20;
        [self.tableView reloadData];
        
    } essionExpire:^{
        [self.tableView endFooterRefreshing];
    }];
}



//- (void)loadIsHaveTextLive
//{
//    WEAK(self)
//    [self.baseToolManager GETIsHaveTextLiveOwnerid:@"17123425" streamid:nil success:^(NSDictionary *retinfo) {
//        if ([retinfo[@"retval"] isEqualToString:@"ok"]) {
//            weakself.textLiveState = [retinfo[@"retinfo"][@"data"][@"state"] integerValue];
//        }
//        [weakself.tableView reloadData];
//    } error:^(NSError *error) {
//        
//    }];
//}
//


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
    
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.textLiveState != 2) {
        return 10;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.textLiveState != 2) {
        return 10;
    }
    return 0.01;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if ((self.textLiveState == 2 && section == 0) || (section == 1)) {
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
//
//    UIView *backView = [[UIView alloc] init];
//    backView.frame = CGRectMake(0, 0, ScreenWidth, 10);
//    backView.backgroundColor = [UIColor evBackgroundColor];
//    
//    return backView;
//}


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
    cell.liveModel = self.videos[indexPath.row];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && self.textLiveState != 2) {
        //进自己的直播间
        
        EVLoginInfo *loginInfo = [EVLoginInfo localObject];
        EVTextLiveModel * localModel = [EVTextLiveModel textLiveObject];
        
        if (localModel.streamid.length > 0)
        {
            //如果本地存到有  从本地取  否则 网络请求
            
            [self pushLiveImageVCModel:localModel];
            return;
        }
        NSString *easemobid = loginInfo.imuser.length <= 0 ? loginInfo.name : loginInfo.imuser;
        WEAK(self)
        [self.baseToolManager GETCreateTextLiveUserid:loginInfo.name nickName:loginInfo.nickname easemobid:easemobid success:^(NSDictionary *retinfo) {
            EVLog(@"LIVETEXT--------- %@",retinfo);
            dispatch_async(dispatch_get_main_queue(), ^{
                EVTextLiveModel *textLiveModel = [EVTextLiveModel objectWithDictionary:retinfo[@"retinfo"][@"data"]];
                [textLiveModel synchronized];
                [weakself pushLiveImageVCModel:textLiveModel];
            });
        } error:^(NSError *error) {
            //         [weakself pushLiveImageVCModel:nil];
            [EVProgressHUD showMessage:@"创建失败"];
        }];
        
    }
    else
    {
        EVVideoAndLiveModel * model = self.videos[indexPath.row];
        EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
        watchViewVC.videoAndLiveModel = model;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 跳转到我的直播间
- (void)pushLiveImageVCModel:(EVTextLiveModel *)model
{
    EVMyTextLiveViewController *myLiveImageVC = [[EVMyTextLiveViewController alloc] init];
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:myLiveImageVC];
    [self presentViewController:navigationVc animated:YES completion:nil];
    myLiveImageVC.textLiveModel = model;
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = [UIColor evBackGroundLightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
}

//- (void)setUserModel:(EVUserModel *)userModel
//{
//    _userModel = userModel;
//    [self loadIsHaveTextLive];
//    [self.tableView reloadData];
//}



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
