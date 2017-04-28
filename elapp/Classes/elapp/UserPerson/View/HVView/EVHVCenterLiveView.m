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
#import "EVReleaseImageWithTextLiveCell.h"
#import "EVShopLiveCell.h"
#import "EVVideoAndLiveModel.h"

@interface EVHVCenterLiveView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger start;
}
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
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"livecell"];
        self.tableFooterView = [UIView new];
        [self registerNib:[UINib nibWithNibName:@"EVReleaseImageWithTextLiveCell" bundle:nil] forCellReuseIdentifier:@"EVReleaseImageWithTextLiveCell"];
        [self registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];


        
        [self addRefreshHeaderWithTarget:self action:@selector(loadNewData)];
        [self addRefreshFooterWithiTarget:self action:@selector(loadMoreData)];
        [self hideFooter];
        [self addVipUI];
//        [self startHeaderRefreshing];
    }
    return self;
}

- (void)addVipUI
{

    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-400)];

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




- (void)loadNewData {
    start = 0;
    [EVProgressHUD showIndeterminateForView:self];
    [self.baseToolManager GETHVCenterVideoListWithUserid:self.userModel.name start:start count:20 startBlock:^{
        [EVProgressHUD hideHUDForView:self];
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self endHeaderRefreshing];
        [EVProgressHUD hideHUDForView:self];
    } success:^(NSDictionary *retinfo) {
        NSLog(@"videos = %@",retinfo);
        [self endHeaderRefreshing];
        [EVProgressHUD hideHUDForView:self];
        NSDictionary *dictionary = retinfo[@"textlive"];
        [self.videos removeAllObjects];
        NSArray *array = retinfo[@"videolive"];
        
        EVUserModel *textLiveModel = [EVUserModel yy_modelWithDictionary:dictionary];
        textLiveModel.name = dictionary[@"ownerid"];
        self.userModel = textLiveModel;
        self.textLiveState = [retinfo[@"textlive"][@"state"] integerValue];
        
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.videos addObject:livemodel];
            }];
            if (array.count<20)
            {
                [self hideFooter];
            }
            else
            {
                [self showFooter];
            }
            start += 20;
        } else {
            [self hideFooter];
        }
        
        if (start == 0 && array.count == 0) {
            self.nullDataView.hidden = NO;
        }
        else
        {
            self.nullDataView.hidden = YES;
        }
        
        [self reloadData];
        
    } essionExpire:^{
        [self endHeaderRefreshing];
        [EVProgressHUD hideHUDForView:self];
    }];
}


- (void)loadMoreData
{
    [self.baseToolManager GETHVCenterVideoListWithUserid:self.userModel.name start:start count:20 startBlock:^{
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
        [self endHeaderRefreshing];
    } success:^(NSDictionary *retinfo) {
        NSLog(@"videos = %@",retinfo);
        [self endHeaderRefreshing];
        [self.videos removeAllObjects];
        NSDictionary *dictionary = retinfo[@"textlive"];
        NSArray *array = retinfo[@"videolive"];
        EVUserModel *textLiveModel = [EVUserModel yy_modelWithDictionary:dictionary];
        textLiveModel.name = dictionary[@"ownerid"];
        self.userModel = textLiveModel;
        self.textLiveState = [retinfo[@"textlive"][@"state"] integerValue];
        
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.videos addObject:livemodel];
            }];
            if (array.count<20)
            {
                [self hideFooter];
            }
            else
            {
                [self showFooter];
            }
            start += 20;
        } else {
            [self hideFooter];
        }
        
        if (start == 0 && array.count == 0) {
            self.nullDataView.hidden = NO;
        }
        else
        {
            self.nullDataView.hidden = YES;
        }
        
        [self reloadData];
        
    } essionExpire:^{
        [self endHeaderRefreshing];
    }];
}


//- (void)loadIsHaveTextLive
//{
//    WEAK(self)
//    [self.baseToolManager GETIsHaveTextLiveOwnerid:self.userModel.name streamid:nil success:^(NSDictionary *retinfo) {
//        if ([retinfo[@"retval"] isEqualToString:@"ok"]) {
//           weakself.textLiveState = [retinfo[@"retinfo"][@"data"][@"state"] integerValue];
//        }
//        [weakself reloadData];
//    } error:^(NSError *error) {
//        
//    }];
//}
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
//    UIView *backView = [[UIView alloc] init];
//    backView.frame = CGRectMake(0, 0, ScreenWidth, 10);
//    backView.backgroundColor = [UIColor evBackgroundColor];
//    
//    return backView;
//}
//


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.textLiveState != 2) {
        static NSString * identifer = @"EVReleaseImageWithTextLiveCell";
        EVReleaseImageWithTextLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.userModel = self.userModel;
        cell.selectionStyle = UIAccessibilityTraitNone;
        return cell;
    }
    
    
    static NSString * identifer = @"EVShopLiveCell";
    EVShopLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.liveModel = self.videos[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && self.textLiveState != 2) {
        if (self.textLiveBlock) {
            self.textLiveBlock(self.userModel);
        }
    }else {
        NSLog(@"dianji = %ld",indexPath.row);
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
//    [self loadIsHaveTextLive];
//    [self reloadData];
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
