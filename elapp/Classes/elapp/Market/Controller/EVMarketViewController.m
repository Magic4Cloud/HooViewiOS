//
//  EVMarketViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMarketViewController.h"
#import "EVSortMarketViewController.h"
#import "EVSelectMarketViewController.h"
#import "EVLabelsTabbarItem.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"

#import "EVSelfStockViewController.h"
#import "EVStockBaseViewController.h"
#import "EVGlobalViewController.h"
#import "EVSearchAllViewController.h"

@interface EVMarketViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *musicCategories;

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) EVStockBaseViewController *shStockBaseVC;
@property (nonatomic, strong) EVStockBaseViewController *hkStockBaseVC;
@property (nonatomic, strong) EVGlobalViewController *globalVC;

@end

@implementation EVMarketViewController




//- (NSArray *)musicCategories {
//    if (!_musicCategories) {
//        _musicCategories = @[@"自选", @"沪深", @"港股", @"全球"];
//    }
//    return _musicCategories;
//}

- (instancetype)init {
    if (self = [super init]) {
//        self.titleSizeNormal = 15;
//        self.titleSizeSelected = 17;
//        self.menuViewStyle = WMMenuViewStyleLine;
//        self.itemsMargins = @[@"50",@"25",@"25", @"25",@"100"];
//        //        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.musicCategories.count;
//        self.menuItemWidth = 35.f;
//        self.menuHeight = 34;
//        self.menuViewBottomSpace = 5.f;
//        self.menuBGColor = [UIColor whiteColor];
//        self.progressWidth = 20.f;//进度条长度
//        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
//        self.titleColorSelected = [UIColor evMainColor];
//        self.titleColorNormal = [UIColor blackColor];
//        self.scrollView.backgroundColor = [UIColor evBackgroundColor];
        
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 16.0f;
        self.titleSizeNormal = 14.0f;
        self.menuHeight = 44;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
        self.menuItemWidth = 50;
        self.progressViewWidths = @[@16,@16,@16,@16];
        //self.progressViewIsNaughty = YES;
        self.titles = @[@"自选",@"沪深",@"港股",@"全球"];
        float margin = 15;
        if (ScreenWidth == 320) {
            margin = (ScreenWidth - 50 - 60 - 50*4)/3;
        }
        NSNumber * marginNum = [NSNumber numberWithFloat:margin];
        float lastMargin = ScreenWidth - 50-margin*3-50*4;
        NSNumber * number = [NSNumber numberWithFloat:lastMargin];
        self.itemsMargins = @[@50,marginNum,marginNum,marginNum,number];
        self.menuBGColor = [UIColor whiteColor];
        self.menuViewStyle = WMMenuViewLayoutModeLeft;
        
    }
    return self;
}

#pragma mark - ♻️Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView {
    self.viewFrame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(ScreenWidth - 44 -10, 20, 44,44);
    [searchButton setImage:[UIImage imageNamed:@"Huoyan_market_search"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchButton];
    
    //    self.menuView.rightView = searchButton;
    UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huoyan_logo"]];
    icon.frame = CGRectMake(20, 30, 23, 23);
    [self.view addSubview:icon];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            //自选
            EVSelfStockViewController *allStockVC = [[EVSelfStockViewController alloc] init];
            allStockVC.view.frame = CGRectMake(0, 10, ScreenWidth, ScreenHeight - 113 -10);
            allStockVC.stockType = EVSelfStockTypeAll;
            return allStockVC;
        }
            break;
        case 1:
        {
            //沪深
            EVStockBaseViewController *shStockBaseVC = [[EVStockBaseViewController alloc] init];
            self.shStockBaseVC = shStockBaseVC;
            self.shStockBaseVC.marketType = @"cn";
            return shStockBaseVC;
        }
        case 2:
        {
            //港股
            EVStockBaseViewController *hkStockBaseVC = [[EVStockBaseViewController alloc] init];
            self.hkStockBaseVC = hkStockBaseVC;
            self.hkStockBaseVC.marketType = @"hk";
            return hkStockBaseVC;        }
        case 3:
        {
            //全球
            EVGlobalViewController *globalVC = [[EVGlobalViewController alloc] init];
            self.globalVC = globalVC;
            return globalVC;
        }
        default:
        {
            return nil;
        }
            break;
    }

}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}



#pragma mark -👣 Target actions
- (void)searchClick
{
    EVSearchAllViewController *searchVC = [[EVSearchAllViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

















#pragma mark ----------------------------------------------------------------
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//
//- (void)dealloc
//{
//    
//}
//
//- (NSArray *)currChildrenViewControllers
//{
//    NSMutableArray *cildrenControllers = [NSMutableArray arrayWithCapacity:3];
//    
//    // 关注
//    EVLabelsTabbarItem *replayItem = [[EVLabelsTabbarItem alloc] init];
//    replayItem.title = @"市场";
//    replayItem.index = 1;
//    EVSortMarketViewController *friendVC = [[EVSortMarketViewController alloc] init];
//    friendVC.viewControllerItem = replayItem;
//    [cildrenControllers addObject:friendVC];
//    
//    // 热门
//    EVLabelsTabbarItem *nowItem = [[EVLabelsTabbarItem alloc] init];
//    nowItem.title =@"自选";
//    nowItem.index = 1;
//    EVSelectMarketViewController *nowVC = [[EVSelectMarketViewController alloc] init];
//    nowVC.viewControllerItem = nowItem;
//    [cildrenControllers addObject:nowVC];
//    
//    return cildrenControllers;
//}
//
//- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index
//{
//    
//    if (index==1) {
//        //如果点击自选  没有登录则弹出登录界面并不切换界面
//        if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil) {
//            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//            [self presentViewController:navighaVC animated:YES completion:nil];
//            return;
//        }
//    }
//    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
//}
//
//- (NSInteger)defaultSelectedIndex
//{
//    return 0;
//}













@end
