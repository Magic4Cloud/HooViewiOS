//
//  EVLiveVideoController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveVideoController.h"
#import "EVHotListViewCell.h"
#import "EVLiveListViewCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVWatchVideoInfo.h"
#import "UIViewController+Extension.h"
#import "EVHVWatchViewController.h"
#import "EVLoginViewController.h"
#import "EVShopLiveCell.h"
#import "EVVideoAndLiveModel.h"

@interface EVLiveVideoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *liveTableView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, assign) NSInteger count;

@end

@implementation EVLiveVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor evBackgroundColor];
    [self addUpView];
    WEAK(self);
    
    [self.liveTableView addRefreshHeaderWithRefreshingBlock:^{
         [weakself loadTopicVideoDataWithTopicId:@"0" start:0 count:20];
    }];
    [self.liveTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadTopicVideoDataWithTopicId:@"0" start:weakself.start count:20];
    }];
    [self.liveTableView startHeaderRefreshing];
    [self.liveTableView hideFooter];
}


- (void)addUpView
{
    UITableView *liveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight - 117) style:(UITableViewStyleGrouped)];
    liveTableView.delegate = self;
    liveTableView.dataSource = self;
    [self.view addSubview:liveTableView];
    liveTableView.backgroundColor = [UIColor evBackgroundColor];
    liveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.liveTableView = liveTableView;
    
    [self.liveTableView registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];

//    UIButton *liveButton = [[UIButton alloc] init];
//    liveButton.frame = CGRectMake(ScreenWidth - 60, ScreenHeight - 54, 44, 44);
//    [self.view addSubview:liveButton];
//    liveButton.backgroundColor = [UIColor yellowColor];
//    [liveButton addTarget:self action:@selector(liveButton) forControlEvents:(UIControlEventTouchUpInside)];
}

//获取热门数据
- (void)loadTopicVideoDataWithTopicId:(NSString *)topicId
                                start:(NSInteger)start
                                count:(NSInteger)count
{
    __weak typeof(self) weakself = self;
    [self.baseToolManager GETTopicVideolistStart:start count:count topicid:topicId start:^{
        
    } fail:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"请求错误"];
    } success:^(NSDictionary *videoInfo) {
        [self endRefreshing];
        self.start = [videoInfo[@"start"] integerValue];
        self.start = [videoInfo[@"next"] integerValue];
        if (self.hotArray.count != 0) {
            [self.hotArray removeAllObjects];
        }
        NSArray *hotVideoTemp = [EVWatchVideoInfo objectWithDictionaryArray:videoInfo[@"hotrecommend"]];
        [self.hotArray addObjectsFromArray:hotVideoTemp];
        if (start == 0) {
            [self.dataArray removeAllObjects];
        }
//        NSArray *videos_model_temp = [EVWatchVideoInfo objectWithDictionaryArray:videoInfo[@"recommend"]];
//        [self.dataArray addObjectsFromArray:videos_model_temp];
//        [self.liveTableView reloadData];
        
        NSArray *array = videoInfo[@"recommend"];
        
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.dataArray addObject:livemodel];
                [self.liveTableView reloadData];
            }];
        }

        
        [self.liveTableView showFooter];
        [self.liveTableView setFooterState:(array.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } sessionExpired:^{
        EVRelogin(weakself);
    }];
}

- (void)endRefreshing
{
    [self.liveTableView endHeaderRefreshing];
    [self.liveTableView endFooterRefreshing];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        EVHotListViewCell *Cell  = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        if (!Cell) {
            Cell =  [[EVHotListViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"hotCell"];
        }
        Cell.dataArray = self.hotArray;
        Cell.listSeletedBlock = ^(EVWatchVideoInfo *videoInfo) {
            EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
            watchViewVC.watchVideoInfo = videoInfo;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
            [self presentViewController:nav animated:YES completion:nil];
        };
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }
  
//    EVLiveListViewCell *liveCell =[tableView dequeueReusableCellWithIdentifier:@"liveCell"];
//    if (!liveCell) {
//        liveCell = [[NSBundle mainBundle] loadNibNamed:@"EVLiveListViewCell" owner:nil options:nil].firstObject;
//        [liveCell setValue:@"liveCell" forKey:@"reuseIdentifier"];
//        liveCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    liveCell.watchVideoInfo = self.dataArray[indexPath.row];
//    
//    return liveCell;
    static NSString * identifer = @"EVShopLiveCell";
    EVShopLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.liveModel = self.dataArray[indexPath.row];
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 178;
    } else {
    return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *titleArray = @[@" 热门推荐",@" 直播列表"];
    NSArray *imageArray = @[@"hv_recommend_n",@"hv_list_live"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    backView.backgroundColor = [UIColor evBackgroundColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
    [backView addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *imageButton = [[UIButton alloc] init];
    [contentView addSubview:imageButton];
    [imageButton setImage:[UIImage imageNamed:imageArray[section]] forState:(UIControlStateNormal)];
    [imageButton setTitle:titleArray[section] forState:(UIControlStateNormal)];
    [imageButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    imageButton.titleLabel.font = [UIFont textFontB2];
    imageButton.frame = CGRectMake(16, 9, 100, 22);
    imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (section == 0) {
        backView.hidden = YES;
    }
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
    return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EVLog(@"推荐视频");
        return;
    }

    EVVideoAndLiveModel * watchVideoInfo = self.dataArray[indexPath.row];
    
    EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];

    watchViewVC.videoAndLiveModel = watchVideoInfo;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)loginView
{
    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
    
    [self presentViewController:navighaVC animated:YES completion:nil];
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    
    return _baseToolManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
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
