//
//  EVNormalPersonCenterController.m
//  elapp
//
//  Created by 周恒 on 2017/4/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNormalPersonCenterController.h"
#import "SwipeTableView.h"
#import "SGSegmentedControl.h"
#import "EVLineView.h"
#import "EVUserTagsView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVUserModel.h"
#import "EVNotOpenView.h"
#import "EVVipNotOpenTableView.h"
#import "EVHVWatchTextViewController.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVHVWatchViewController.h"

#import "EVHVCenterArticleTableView.h"//文章
#import "EVFansOrFocusesTableViewController.h"

#import "EVLoginInfo.h"
#import "EVLoginViewController.h"
#import "EVNewsModel.h"
#import "EVNewsDetailWebController.h"
#import "EVHVCenterCommentTableView.h"


@interface EVNormalPersonCenterController ()<EVHVVipCenterDelegate,SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,SGSegmentedControlStaticDelegate>

@property (nonatomic, strong) EVVipDetailCenterView *hvCenterView;

@property (nonatomic, weak) UIButton *followButton;


@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) STHeaderView * tableViewHeader;


@property (nonatomic, strong) SGSegmentedControlStatic *topSView;


@property (nonatomic, strong) UIView *sementedBackView;

@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVUserModel *userModel;


@property (nonatomic, weak) EVNotOpenView *notOpenView;

@property (nonatomic, strong) EVVipNotOpenTableView *vipNotOpenTableView;


@property (nonatomic, strong) EVHVCenterArticleTableView *centerArticleView;

@property (nonatomic, strong) EVHVCenterCommentTableView *CenterCommentView;

@end

@implementation EVNormalPersonCenterController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackTableView];
    [self loadData];
    //    [self loadImageCarousel];
    //
    //    WEAK(self)
    //    [_iNewsTableview addRefreshHeaderWithRefreshingBlock:^{
    //        [weakself loadImageCarousel];
    //        [weakself loadNewData];
    //    }];
    //
    //    [_iNewsTableview addRefreshFooterWithRefreshingBlock:^{
    //        [weakself loadMoreData];
    //    }];
    //
    //    [self.iNewsTableview.mj_footer setHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark - 🖍 User Interface layout
- (void)addBackTableView
{
    EVVipDetailCenterView * vipCenterView = [[EVVipDetailCenterView alloc] init];
    vipCenterView.frame = CGRectMake(0, 0, ScreenWidth, 450);
    self.vipCenterView = vipCenterView;
    vipCenterView.fansAndFollowClickBlock = ^(controllerType type)
    {
        if (![EVLoginInfo hasLogged]) {
            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
            [self presentViewController:navighaVC animated:YES completion:nil];
            return;
        }
        //点击  粉丝和关注
        EVFansOrFocusesTableViewController *fansOrFocusesTVC = [[EVFansOrFocusesTableViewController alloc] init];
        fansOrFocusesTVC.type = type;
        [self.navigationController pushViewController:fansOrFocusesTVC animated:YES];
    };
    
    
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.alwaysBounceHorizontal = YES;
    _swipeTableView.swipeHeaderBar = self.sementedBackView;
    _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    _swipeTableView.swipeHeaderTopInset = 64;
    [self.view addSubview:_swipeTableView];
    self.vipCenterView.watchVideoInfo = self.watchVideoInfo;
    
    
    self.navigationView = [[UIView alloc] init];
    _navigationView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _navigationView.backgroundColor = [UIColor whiteColor];
    [EVLineView addTopLineToView:_navigationView];
    [self.view addSubview:_navigationView];
    
    
    UIButton *popButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_navigationView addSubview:popButton];
    [popButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [popButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:27];
    [popButton autoSetDimensionsToSize:CGSizeMake(30,30)];
    [popButton setImage:[UIImage imageNamed:@"btn_return_n"] forState:(UIControlStateNormal)];
    [popButton addTarget:self action:@selector(popClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    //举报
    UIButton *reportButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_navigationView addSubview:reportButton];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [reportButton autoSetDimensionsToSize:CGSizeMake(44,44)];
    [reportButton setImage:[UIImage imageNamed:@"btn_report_n"] forState:(UIControlStateNormal)];
    [reportButton addTarget:self action:@selector(reportClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}


- (UIView *)sementedBackView
{
    if (nil == _sementedBackView) {
        self.sementedBackView  = [[UIView alloc] init];
        _sementedBackView.frame = CGRectMake(0, 0, ScreenWidth, 44);
        _sementedBackView.backgroundColor = [UIColor whiteColor];
        
        
        NSArray *titleArray = @[@"评论",@"收藏"];
        
        self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth / 2, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
        
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
    }
    return _sementedBackView;
}






#pragma mark - 🌐Networks
- (void)loadData
{
    [self.baseToolManager GETUserInfoWithUname:self.watchVideoInfo.name orImuser:nil start:^{
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    } success:^(NSDictionary *modelDict) {
        EVUserModel *userModel = [EVUserModel objectWithDictionary:modelDict];
        self.userModel = userModel;
        self.vipCenterView.userModel = userModel;
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                                      NSParagraphStyleAttributeName: paragraphStyle};
        CGSize contentSize = [@"火眼财经火眼财经" boundingRectWithSize:CGSizeMake(ScreenWidth - 51 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
        NSLog(@"cont = %@",NSStringFromCGSize(contentSize));
        
        CGFloat viewHeight = contentSize.height + 75 + ScreenWidth * 210 / 375;
        self.vipCenterView.frame = CGRectMake(0, 0, ScreenWidth, viewHeight);
        _swipeTableView.swipeHeaderView = self.vipCenterView;
    } sessionExpire:^{
        
    }];
}




#pragma mark -👣 Target actions
- (void)popClick
{
    [self backButton];
}

//举报
- (void)reportClick
{
    
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


// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    
    //    _topSView.selectedIndex = swipeView.currentItemIndex;
    [self.topSView changeSelectButtonIndex:swipeView.currentItemIndex];
}


#pragma mark - 🌺  Delegate & Datasource
- (void)updateTableViewFloat:(CGFloat)vfloat
{
    //    if (vfloat > 150) {
    //        self.navigationView.alpha = 1;
    //    }else {
    //        self.navigationView.alpha = 0.0;
    //    }
    
}

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 2;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    
    switch (index) {
        case 0:
            
        {
            EVHVCenterCommentTableView *CenterCommentView = self.CenterCommentView;
            CenterCommentView.WatchVideoInfo = self.watchVideoInfo;
            view = CenterCommentView;

        }
            break;
        
        case 1:
        {
            EVHVCenterArticleTableView *centerArticleView = self.centerArticleView;
            centerArticleView.WatchVideoInfo = self.watchVideoInfo;
            centerArticleView.ArticleBlock = ^(EVNewsModel *newsModel) {
                EVNewsDetailWebController *newsVC = [[EVNewsDetailWebController alloc] init];
                newsVC.newsID = newsModel.newsID;
                //    newsVC.title = model.title;
                [self.navigationController pushViewController:newsVC animated:YES];
            };
            view = centerArticleView;
        }
            break;
        
        default:
            break;
    }
    
    return view;
}




#pragma mark -   Getter
- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (EVVipNotOpenTableView *)vipNotOpenTableView
{
    if (nil == _vipNotOpenTableView) {
        _vipNotOpenTableView = [[EVVipNotOpenTableView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _vipNotOpenTableView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _vipNotOpenTableView;
}


- (EVHVCenterCommentTableView *)CenterCommentView
{
    if (nil == _CenterCommentView) {
        _CenterCommentView = [[EVHVCenterCommentTableView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _CenterCommentView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _CenterCommentView;
}


- (EVHVCenterArticleTableView *)centerArticleView
{
    if (nil == _centerArticleView) {
        _centerArticleView = [[EVHVCenterArticleTableView alloc] initWithFrame:_swipeTableView.bounds style:(UITableViewStyleGrouped)];
        _centerArticleView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _centerArticleView;
}



- (EVVipDetailCenterView * )vipCenterView
{
    if (!_vipCenterView) {
        _vipCenterView = [[EVVipDetailCenterView alloc] init];
    }
    return _vipCenterView;
}


#pragma mark -   Setter
- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
}

- (void)setIsFollow:(BOOL)isFollow
{
    _isFollow = isFollow;
}


- (void)dealloc
{
    EVLog(@"---------EVVipCenterViewController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
