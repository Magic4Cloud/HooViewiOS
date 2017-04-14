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

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) EVStockBaseViewController *shStockBaseVC;
@property (nonatomic, strong) EVStockBaseViewController *hkStockBaseVC;
@property (nonatomic, strong) EVGlobalViewController *globalVC;

@end

@implementation EVMarketViewController

- (instancetype)init {
    if (self = [super init]) {
    
        self.menuViewStyle = WMMenuViewStyleLine;
        float addFont = 0;
        if (ScreenWidth>375) {
            addFont = 1;
        }
        self.titleSizeSelected = 16.0+addFont;
        self.titleSizeNormal = 14.0+addFont;
        self.menuHeight = 44;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
        self.menuItemWidth = 45;
        self.progressViewWidths = @[@16,@16,@16,@16];
        //self.progressViewIsNaughty = YES;
        self.titles = @[@"自选",@"沪深",@"港股",@"全球"];
        float margin = 12;
        if (ScreenWidth == 320) {
            margin = 0;
        }
        
        NSNumber * marginNum = [NSNumber numberWithFloat:margin];
        float lastMargin = ScreenWidth - 50-margin*3-45*4;
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
}

- (void)setupView {
    self.viewFrame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(ScreenWidth - 44 -10, 20, 44,44);
    [searchButton setImage:[UIImage imageNamed:@"btn_news_search_n"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchButton];
    
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


@end
