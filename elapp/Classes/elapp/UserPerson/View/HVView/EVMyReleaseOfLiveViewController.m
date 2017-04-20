//
//  EVMyReleaseOfLiveViewController.m
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyReleaseOfLiveViewController.h"

#import "EVReleaseImageWithTextLiveCell.h"


//#import "EVHVCenterLiveView.h"
//
#import "EVUserVideoModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVHVWatchViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVNullDataView.h"
//
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
//    [self addVipUI];
}


#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVReleaseImageWithTextLiveCell" bundle:nil] forCellReuseIdentifier:@"EVReleaseImageWithTextLiveCell"];
    
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


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0 && self.textLiveState != 2) {
//        return 10;
//    }
//    return 40;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0 && self.textLiveState != 2) {
//        return 10;
//    }
//    return 0.01;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (self.textLiveState == 2 && section == 0) {
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
//    }else if (section == 1) {
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && self.textLiveState != 2) {
//        EVReleaseImageWithTextLiveCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
//        if (Cell == nil) {
//            Cell = [[NSBundle mainBundle] loadNibNamed:@"EVReleaseImageWithTextLiveCell" owner:nil options:nil].firstObject;
//        }
////        Cell.userModel = self.userModel;
//        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return Cell;
//    }
//    EVMyVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
//    if (videoCell == nil) {
//        videoCell = [[NSBundle mainBundle] loadNibNamed:@"EVMyVideoTableViewCell_6" owner:nil options:nil].firstObject;
//        [videoCell setValue:@"videoCell" forKey:@"reuseIdentifier"];
//        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    videoCell.videoModel = self.videos[indexPath.row];
//    
//    return videoCell;
    
    static NSString * identifer = @"EVReleaseImageWithTextLiveCell";
    EVReleaseImageWithTextLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
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
//    [self loadIsHaveTextLive];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
