//
//  EVVipCenterViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipCenterViewController.h"
#import "SwipeTableView.h"
#import "SGSegmentedControl.h"
#import "EVHVCenterLiveView.h"
#import "EVLineView.h"
#import "EVUserTagsView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVUserModel.h"
#import "EVNotOpenView.h"
#import "EVVipNotOpenTableView.h"
#import "EVHVCenterFansTableView.h"
#import "EVHVWatchTextViewController.h"
#import "EVVideoFunctions.h"
#import "EVTextLiveModel.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVHVWatchViewController.h"


#import "EVLoginInfo.h"
#import "EVLoginViewController.h"

@interface EVVipCenterViewController ()<EVHVVipCenterDelegate,SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,SGSegmentedControlStaticDelegate>

@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) STHeaderView * tableViewHeader;


@property (nonatomic, strong) SGSegmentedControlStatic *topSView;


@property (nonatomic, strong) UIView *sementedBackView;

@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, strong) EVHVCenterLiveView *hvCenterLiveView;

@property (nonatomic, weak) EVNotOpenView *notOpenView;

@property (nonatomic, strong) EVVipNotOpenTableView *vipNotOpenTableView;

@property (nonatomic, strong) EVHVCenterFansTableView *centerFansTableView;


@property (nonatomic, weak) UIButton *followButton;

@end

@implementation EVVipCenterViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    [self addBackTableView];
    [self loadData];
}
- (void)addBackTableView
{
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.alwaysBounceHorizontal = YES;
    _swipeTableView.swipeHeaderView = self.vipCenterView;
    _swipeTableView.swipeHeaderBar = self.sementedBackView;
    _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    _swipeTableView.swipeHeaderTopInset = 0;
    [self.view addSubview:_swipeTableView];
    self.vipCenterView.watchVideoInfo = self.watchVideoInfo;
    
    
    self.navigationView = [[UIView alloc] init];
    _navigationView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _navigationView.backgroundColor = [UIColor whiteColor];
    [EVLineView addTopLineToView:_navigationView];
    [self.view addSubview:_navigationView];
    _navigationView.alpha = 0.0;
    
    
    UIButton *popButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_navigationView addSubview:popButton];
    [popButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [popButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [popButton autoSetDimensionsToSize:CGSizeMake(22,22)];
    [popButton setImage:[UIImage imageNamed:@"hv_back_return"] forState:(UIControlStateNormal)];
    [popButton addTarget:self action:@selector(popClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (EVHVVipCenterView * )vipCenterView
{
    if (!_vipCenterView) {
        _vipCenterView = [[EVHVVipCenterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 226) isTextLive:NO];
        _vipCenterView.delegate = self;
    }
    return _vipCenterView;
}



- (UIView *)sementedBackView
{
     if (nil == _sementedBackView) {
         self.sementedBackView  = [[UIView alloc] init];
         _sementedBackView.frame = CGRectMake(0, 0, ScreenWidth, 44);
         _sementedBackView.backgroundColor = [UIColor whiteColor];
         
         
         NSArray *titleArray = @[@"直播",@"秘籍",@"粉丝"];
         
         self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth / 4 * 3, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
         
         // 必须实现的方法
         [_topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
             
         }];
         
         [_topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
             *segmentedControlColor = [UIColor whiteColor];
             *titleColor = [UIColor evTextColorH2];
             *selectedTitleColor = [UIColor evMainColor];
             *indicatorColor = [UIColor evMainColor];
         }];
         _topSView.selectedIndex = 0;
         [_sementedBackView addSubview:_topSView];
         
         
         UIButton *followButton = [[UIButton alloc] init];
         [_sementedBackView addSubview:followButton];
         self.followButton = followButton;
         followButton.frame = CGRectMake(ScreenWidth - 86, 7, 70, 30);
         [followButton setImage:[UIImage imageNamed:@"btn_unconcerned_n"] forState:(UIControlStateNormal)];
         [followButton setTitle:@"关注" forState:(UIControlStateNormal)];
         [followButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
         followButton.layer.borderColor = [UIColor evBackgroundColor].CGColor;
         followButton.layer.borderWidth = 1;
         followButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
         followButton.layer.cornerRadius = 4;
         followButton.clipsToBounds = YES;         
         [followButton addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchDown)];
         [self buttonStatus:self.isFollow button:followButton];
         
     }
    return _sementedBackView;
}

- (void)popClick
{
    [self backButton];
}

- (void)shareClick
{
    EVLog(@"shareClick--------- ");
}

- (void)followClick:(UIButton *)btn
{
    if (![EVLoginInfo hasLogged]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    
    WEAK(self)
    BOOL followType = self.watchVideoInfo.followed ? NO : YES;
    [self.baseToolManager GETFollowUserWithName:self.watchVideoInfo.name followType:followType start:^{
        
    } fail:^(NSError *error) {
        
    } success:^{
         btn.selected = !btn.selected;
        [weakself buttonStatus:btn.selected button:btn];
        weakself.watchVideoInfo.followed = followType;
        
    }
    essionExpire:^{
        
    }];
}

- (void)buttonStatus:(BOOL)status button:(UIButton *)button
{
    if (status == YES) {
        [button setImage:[UIImage imageNamed:@"btn_concerned_s"] forState:(UIControlStateNormal)];
        [button setTitle:@"已关注" forState:(UIControlStateNormal)];
    }else {
        [button setImage:[UIImage imageNamed:@"btn_unconcerned_n"] forState:(UIControlStateNormal)];
        
        [button setTitle:@"关注" forState:(UIControlStateNormal)];
    }
}



- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
     [_swipeTableView scrollToItemAtIndex:index animated:NO];
}

- (void)loadData
{
//    [self.baseToolManager GETUserInfoWithUname:self.watchVideoInfo.name orImuser:nil start:^{
//        
//    } fail:^(NSError *error) {
//        NSLog(@"error = %@",error);
//    } success:^(NSDictionary *modelDict) {
//        EVUserModel *userModel = [EVUserModel objectWithDictionary:modelDict];
//        self.userModel = userModel;
//        self.hvCenterLiveView.userModel = userModel;
//        self.vipCenterView.userModel = userModel;
//        
//        
//    } sessionExpire:^{
//        
//    }];
}


#pragma mark - SwipeTableView M
- (void)updateTableViewFloat:(CGFloat)vfloat
{
    if (vfloat > 150) {
        self.navigationView.alpha = 1;
    }else {
        self.navigationView.alpha = 0.0;
    }
    
}

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 3;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {

    switch (index) {
        case 0:
     
        {
            WEAK(self)
            EVHVCenterLiveView *hvCenterLiveView = self.hvCenterLiveView;
            [hvCenterLiveView getDataWithName:self.watchVideoInfo.name];
            hvCenterLiveView.videoBlock = ^(EVWatchVideoInfo *videoModel) {
                EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
                watchViewVC.watchVideoInfo = videoModel;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
                [weakself presentViewController:nav animated:YES completion:nil];
            };
            hvCenterLiveView.textLiveBlock= ^(EVUserModel *videoInfo) {
                [weakself loadTextLiveData:videoInfo];
            };
            view = hvCenterLiveView;
        }
            break;
        case 1:
        {
            EVVipNotOpenTableView *notOpenTableView = self.vipNotOpenTableView;
        
            view = notOpenTableView;
        }
            break;
        case 2:
        {
            EVHVCenterFansTableView *centerFansView = self.centerFansTableView;
            centerFansView.WatchVideoInfo = self.watchVideoInfo;
            view = centerFansView;
        }
            break;
            
        default:
            break;
    }
    
    return view;
}

- (void)loadTextLiveData:(EVUserModel *)userModel
{
    
  
    WEAK(self)
    [self.baseToolManager GETCreateTextLiveUserid:userModel.name nickName:userModel.nickname easemobid:userModel.name success:^(NSDictionary *retinfo) {
        EVLog(@"LIVETEXT--------- %@",retinfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            EVTextLiveModel *textLiveModel = [EVTextLiveModel objectWithDictionary:retinfo[@"retinfo"][@"data"]];
            [weakself pushLiveImageVCModel:textLiveModel userModel:userModel];
        });
    } error:^(NSError *error) {
        //         [weakself pushLiveImageVCModel:nil];
        [EVProgressHUD showMessage:@"创建失败"];
    }];
}

- (void)pushLiveImageVCModel:(EVTextLiveModel *)model userModel:(EVUserModel *)usermodel
{
    EVHVWatchTextViewController *watchImageVC = [[EVHVWatchTextViewController alloc] init];
    
    //                if (videoInfo.liveID == nil || [videoInfo.liveID isEqualToString:@""]) {
    //                    [EVProgressHUD showMessage:@"没有获取到房间号"];
    //                    return;
    //                }
    EVWatchVideoInfo *watchVideoInfo = [[EVWatchVideoInfo alloc] init];
    watchVideoInfo.liveID = model.streamid;
    watchVideoInfo.name = model.name;
    watchVideoInfo.viewcount = model.viewcount;
    watchVideoInfo.nickname = usermodel.nickname;
    watchImageVC.watchVideoInfo = watchVideoInfo;
    watchImageVC.liveVideoInfo = watchVideoInfo;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:watchImageVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}

// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    
//    _topSView.selectedIndex = swipeView.currentItemIndex;
    [self.topSView changeSelectButtonIndex:swipeView.currentItemIndex];
}

// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
//    [self getDataAtIndex:swipeView.currentItemIndex];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)reportButton
{
    [EVVideoFunctions handleReportAction];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
}

- (void)setIsFollow:(BOOL)isFollow
{
    _isFollow = isFollow;
}
- (void)backButton
{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (EVHVCenterLiveView *)hvCenterLiveView
{
    if (_hvCenterLiveView == nil) {
        _hvCenterLiveView = [[EVHVCenterLiveView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _hvCenterLiveView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _hvCenterLiveView;
}

- (EVVipNotOpenTableView *)vipNotOpenTableView
{
    if (nil == _vipNotOpenTableView) {
        _vipNotOpenTableView = [[EVVipNotOpenTableView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _vipNotOpenTableView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _vipNotOpenTableView;
}

- (EVHVCenterFansTableView *)centerFansTableView
{
    if (nil == _centerFansTableView) {
        _centerFansTableView = [[EVHVCenterFansTableView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _centerFansTableView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _centerFansTableView;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


- (void)dealloc
{
    EVLog(@"---------EVVipCenterViewController dealloc");
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
