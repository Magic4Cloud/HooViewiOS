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
    
    WEAK(self)
    [self.liveTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadDataStart:@"0"];
    }];
    [self.liveTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadDataStart:_next];
    }];
    [self.liveTableView hideFooter];
    [self.liveTableView startHeaderRefreshing];
}

- (void)addUpView
{
    UITableView *liveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight - 64 -49 -4) style:(UITableViewStyleGrouped)];
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
        [self.liveTableView showFooter];
    } success:^(NSDictionary *modelDict) {
        
        NSArray *userArr = [EVWatchVideoInfo objectWithDictionaryArray:modelDict[@"users"]];
        ishot == YES ? [self.hotArray addObjectsFromArray:userArr] : [self.dataArray addObjectsFromArray:userArr];
        [weakself.liveTableView reloadData];
        [self.liveTableView showFooter];
    } sessionExpire:^{
        [self.liveTableView showFooter];
    }];
}

- (NSMutableString *)loadDataUserInfos:(NSArray *)array
{
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
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return 98;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVWatchVideoInfo *WatchVideoInfo = _dataArray[indexPath.row];
    EVWatchVideoInfo *liveVideoInfo = _dataLiveArray[indexPath.row];
    [self pushTextLivingControllerWithWatchVideoInfo:WatchVideoInfo liveVideoInfo:liveVideoInfo];
}

- (void)pushTextLivingControllerWithWatchVideoInfo:(EVWatchVideoInfo *)WatchVideoInfoModel liveVideoInfo:(EVWatchVideoInfo *)liveVideoInfoModel
{
    NSString *myId = [EVLoginInfo localObject].name;
    
    if ([liveVideoInfoModel.ownerid isEqualToString:myId]) {
        //是进自己的直播间
        EVLoginInfo *loginInfo = [EVLoginInfo localObject];
        EVTextLiveModel * localModel = [EVTextLiveModel textLiveObject];
        
        if (localModel.streamid.length > 0)
        {
            //如果本地存到有  从本地取  否则 网络请求
            
            [self pushLiveImageVCModel:localModel];
            return;
        }
        NSString *easemobid = loginInfo.imuser.length <= 0 ? loginInfo.name : loginInfo.imuser;
        [EVProgressHUD showIndeterminateForView:self.view];
        
        WEAK(self)
        [self.baseToolManager GETCreateTextLiveUserid:loginInfo.name nickName:loginInfo.nickname easemobid:easemobid success:^(NSDictionary *retinfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                EVTextLiveModel *textLiveModel = [EVTextLiveModel objectWithDictionary:retinfo[@"retinfo"][@"data"]];
                [textLiveModel synchronized];
                [EVProgressHUD hideHUDForView:self.view];
                [weakself pushLiveImageVCModel:textLiveModel];
            });
        } error:^(NSError *error) {
            [EVProgressHUD hideHUDForView:self.view];
            [EVProgressHUD showMessage:@"创建失败"];
        }];
        
    }
    else
    {
        //进别人的直播间
        EVHVWatchTextViewController *watchImageVC = [[EVHVWatchTextViewController alloc] init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:watchImageVC];
        watchImageVC.watchVideoInfo = WatchVideoInfoModel;
        watchImageVC.liveVideoInfo = liveVideoInfoModel;
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
