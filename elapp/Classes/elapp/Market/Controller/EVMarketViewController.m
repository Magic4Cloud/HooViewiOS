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




- (NSArray *)musicCategories {
    if (!_musicCategories) {
        _musicCategories = @[@"自选", @"沪深", @"港股", @"全球"];
    }
    return _musicCategories;
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 17;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.itemsMargins = @[@"50",@"25",@"25", @"25",@"100"];
        //        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.musicCategories.count;
        self.menuItemWidth = 35.f;
        self.menuHeight = 34;
        self.menuViewBottomSpace = 5.f;
        self.menuBGColor = [UIColor whiteColor];
        self.progressWidth = 20.f;//进度条长度
        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor blackColor];
        self.scrollView.backgroundColor = [UIColor evBackgroundColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor evBackgroundColor];
    [self setupView];
    
}

- (void)setupView {
    self.navigationController.navigationBar.hidden = YES;
    
    UIButton *logoButton = [[UIButton alloc] init];
    logoButton.frame = CGRectMake(15.f, 30.f, 22.f, 22.f);
    [logoButton setImage:[UIImage imageNamed:@"huoyan_logo"] forState:(UIControlStateNormal)];
    logoButton.userInteractionEnabled = NO;
    [self.view addSubview:logoButton];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"Huoyan_market_search"] forState:(UIControlStateNormal)];
    rightButton.frame = CGRectMake(340, 30, rightButton.imageView.image.size.width, rightButton.imageView.image.size.height);
    self.rightButton = rightButton;
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightButton];
    
}



// MARK: ChangeViewFrame (Animatable)
- (void)setViewTop:(CGFloat)viewTop {
    
    _viewTop = viewTop;
    
    if (_viewTop <= kNavigationBarHeight) {
        _viewTop = kNavigationBarHeight;
    }
    
    if (_viewTop > kWMHeaderViewHeight + kNavigationBarHeight) {
        _viewTop = kWMHeaderViewHeight + kNavigationBarHeight;
    }
    
    self.viewFrame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (index == 0) {
        //自选
        EVSelfStockViewController *allStockVC = [[EVSelfStockViewController alloc] init];
        [self addChildViewController:allStockVC];
        allStockVC.view.frame = CGRectMake(0, 10, ScreenWidth, ScreenHeight - 113 -10);
        allStockVC.stockType = EVSelfStockTypeAll;
        return allStockVC;
    } else if(index == 1) {
        //沪深
        EVStockBaseViewController *shStockBaseVC = [[EVStockBaseViewController alloc] init];
        shStockBaseVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.shStockBaseVC = shStockBaseVC;
        self.shStockBaseVC.marketType = @"cn";
        return shStockBaseVC;
    } else if(index == 2) {
        //港股
        EVStockBaseViewController *hkStockBaseVC = [[EVStockBaseViewController alloc] init];
        hkStockBaseVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.hkStockBaseVC = hkStockBaseVC;
        self.hkStockBaseVC.marketType = @"hk";
        return hkStockBaseVC;
    } else {
        //全球
        EVGlobalViewController *globalVC = [[EVGlobalViewController alloc] init];
        globalVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.globalVC = globalVC;
        return globalVC;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.musicCategories[index];
}



//搜索
- (void)rightClick:(UIButton *)sender {
    
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
