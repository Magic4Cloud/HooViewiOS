//
//  EVTextLiveListController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVTextLiveListController.h"
#import "EVNotOpenView.h"
#import "EVLiveImageViewCell.h"
#import "EVHotImageListViewCell.h"
#import "EVHVWatchTextViewController.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVBaseToolManager+EVSDKMessage.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EMClient.h"
#import "EVMyTextLiveViewController.h"
#import "EVLoginInfo.h"
@interface EVTextLiveListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *liveTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, strong) NSMutableArray *hotLiveArray;

@property (nonatomic, strong) NSMutableArray *dataLiveArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *next;

@end

@implementation EVTextLiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _next = @"0";
    [self addUpView];
    [self loadDataStart:@"0"];
    WEAK(self)
    [self.liveTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadDataStart:@"0"];
    }];
    [self.liveTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadDataStart:_next];
    }];
}

- (void)addUpView
{
    UITableView *liveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, EVContentHeight) style:(UITableViewStyleGrouped)];
    liveTableView.delegate = self;
    liveTableView.dataSource = self;
    [self.view addSubview:liveTableView];
    liveTableView.backgroundColor = [UIColor evBackgroundColor];
    liveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.liveTableView = liveTableView;
    
}

- (void)loadDataStart:(NSString *)start
{
    WEAK(self)
    [self.baseToolManager GETTextLiveHomeListStart:start success:^(NSDictionary *info) {
        [weakself.liveTableView endFooterRefreshing];
        [weakself.liveTableView endHeaderRefreshing];
        if ([info[@"reterr"] isEqualToString:@"OK"]) {
            if ( [info[@"retinfo"][@"start"] integerValue] == 0) {
                [weakself.hotLiveArray removeAllObjects];
                [weakself.dataLiveArray removeAllObjects];
                [weakself.hotArray removeAllObjects];
                [weakself.dataArray removeAllObjects];
            }
            
            weakself.next = info[@"retinfo"][@"next"];
            NSArray *hotArr = [EVWatchVideoInfo objectWithDictionaryArray:info[@"retinfo"][@"hotstreams"]];
            [weakself.hotLiveArray addObjectsFromArray:hotArr];
            NSMutableString *userid = [weakself loadDataUserInfos:hotArr];
            [weakself loadUserDataUserID:userid isHot:YES];
            NSArray *streamsArr = [EVWatchVideoInfo objectWithDictionaryArray:info[@"retinfo"][@"streams"]];
            [weakself.dataLiveArray addObjectsFromArray:streamsArr];
            NSMutableString *sUserid = [weakself loadDataUserInfos:streamsArr];
            [weakself loadUserDataUserID:sUserid isHot:NO];
            [weakself.liveTableView setFooterState:(streamsArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
        }
    } fail:^(NSError *error) {
        [weakself.liveTableView endFooterRefreshing];
        [weakself.liveTableView endHeaderRefreshing];
    }];
}


- (void)loadUserDataUserID:(NSMutableString *)userid isHot:(BOOL)ishot
{
    WEAK(self)
    [self.baseToolManager GETBaseUserInfoListWithUname:userid.mutableCopy start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *modelDict) {
        NSLog(@"modelDict----- %@",modelDict);
        NSArray *userArr = [EVWatchVideoInfo objectWithDictionaryArray:modelDict[@"users"]];
        ishot == YES ? [self.hotArray addObjectsFromArray:userArr] : [self.dataArray addObjectsFromArray:userArr];
        [weakself.liveTableView reloadData];
    } sessionExpire:^{
        
    }];
}
- (NSMutableString *)loadDataUserInfos:(NSArray *)array
{
    //NSMutableArray *dataA = [NSMutableArray arrayWithArray:array];
    NSMutableString *userID = [NSMutableString string];
    for (NSInteger i =0 ; i< array.count; i++) {
        EVWatchVideoInfo *watchInfo = array[i];
        [userID appendString:watchInfo.ownerid];
        i == (array.count - 1) ? [userID appendString:@""]: [userID appendString:@","];
    }
    return userID;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.hotArray.count == 0)
    {
        if (self.dataArray.count == 0) {
            return 0;
        }
    }
    else
    {
        if (section == 0) {
            return 1;
        }
    }
    
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.hotArray.count == 0) {
        if (self.dataArray.count == 0) {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.dataArray.count == 0) {
            return 1;
        }
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotArray.count == 0)
    {
        if (self.dataArray.count>0) {
            EVHotImageListViewCell *liveCell =[tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            if (!liveCell) {
                liveCell = [[NSBundle mainBundle] loadNibNamed:@"EVHotImageListViewCell" owner:nil options:nil].firstObject;
                [liveCell setValue:@"imageCell" forKey:@"reuseIdentifier"];
                liveCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataArray.count != 0) {
                liveCell.watchVideoInfo = self.dataArray[indexPath.row];
            }
            
            return liveCell;
        }
    }
    else
    {
        
            if (indexPath.section == 0)
            {
                EVLiveImageViewCell *Cell  = [tableView dequeueReusableCellWithIdentifier:@"imageItemCell"];
                if (!Cell) {
                    Cell =  [[EVLiveImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"imageItemCell"];
                }
                Cell.dataArray = self.hotArray;
                Cell.dataLiveArray = self.hotLiveArray;
                Cell.listSeletedBlock = ^(EVWatchVideoInfo *videoInfo,EVWatchVideoInfo *liveVideoInfo) {
                    //            NSString *sessionID = [self.baseToolManager getSessionIdWithBlock:nil];
                    //            if (sessionID == nil || [sessionID isEqualToString:@""]) {
                    //                [self loginView];
                    //                return;
                    //            }
                    EVHVWatchTextViewController *watchViewVC = [[EVHVWatchTextViewController alloc] init];
                    watchViewVC.watchVideoInfo = videoInfo;
                    watchViewVC.liveVideoInfo = liveVideoInfo;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
                    [self presentViewController:nav animated:YES completion:nil];
                };
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return Cell;
            }
    }
    EVHotImageListViewCell *liveCell =[tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    if (!liveCell) {
        liveCell = [[NSBundle mainBundle] loadNibNamed:@"EVHotImageListViewCell" owner:nil options:nil].firstObject;
        [liveCell setValue:@"imageCell" forKey:@"reuseIdentifier"];
    }
    if (self.dataArray.count != 0) {
        liveCell.watchVideoInfo = self.dataArray[indexPath.row];
    }
    liveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return liveCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
      return  125;
    }
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    NSArray *titleArray = @[@" 热门大牛",@" 大牛列表"];
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
    if (self.hotArray.count == 0) {
        [imageButton setTitle:titleArray[1] forState:(UIControlStateNormal)];
        [imageButton setImage:[UIImage imageNamed:imageArray[1]] forState:(UIControlStateNormal)];
    }
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVLog(@"-----------------------watchtextlive--------------");
    EVWatchVideoInfo *WatchVideoInfo = _dataArray[indexPath.row];
    EVWatchVideoInfo *liveVideoInfo = _dataLiveArray[indexPath.row];
    
    
    
    NSString *myId = [EVLoginInfo localObject].name;

    if ([liveVideoInfo.ownerid isEqualToString:myId]) {
        //是进自己的直播间
        NSString *sessionID = [self.baseToolManager getSessionIdWithBlock:nil];
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
        //进别人的直播间
        EVHVWatchTextViewController *watchImageVC = [[EVHVWatchTextViewController alloc] init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:watchImageVC];
        watchImageVC.watchVideoInfo = WatchVideoInfo;
        watchImageVC.liveVideoInfo = liveVideoInfo;
        [self presentViewController:navigationVC animated:YES completion:nil];
    }
    
    
}


#pragma mark - 跳转到我的直播间
- (void)pushLiveImageVCModel:(EVTextLiveModel *)model
{
    EVMyTextLiveViewController *myLiveImageVC = [[EVMyTextLiveViewController alloc] init];
    myLiveImageVC.textLiveModel = model;
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:myLiveImageVC];
    [self presentViewController:navigationVc animated:YES completion:nil];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
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

- (NSMutableArray *)hotLiveArray
{
    if (!_hotLiveArray) {
        _hotLiveArray = [NSMutableArray array];
    }
    return _hotLiveArray;
}

- (NSMutableArray *)dataLiveArray
{
    if (!_dataLiveArray) {
        _dataLiveArray = [NSMutableArray array];
    }
    return _dataLiveArray;
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
