//
//  EVHomeBaseViewController.m
//  elapp
//
//  Created by 唐超 on 4/5/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVHomeBaseViewController.h"
#import "EVChooseNewsViewController.h"
#import "EVFastNewsViewController.h"
#import "EVImportantNewsViewController.h"
#import "EVSearchAllViewController.h"
#import "EVSpeciaColumnViewController.h"
#import "EVNewsStocksViewController.h"

#import "EVHomeViewController.h"
@interface EVHomeBaseViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UIViewController * currentVc;
@end

@implementation EVHomeBaseViewController
#pragma mark - 👨‍💻‍ Initialization
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
//        self.progressViewIsNaughty = YES;
        self.titles = @[@"要闻",@"快讯",@"股市",@"专栏"];
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EVHomeViewController * tabarctronller = (EVHomeViewController *)self.tabBarController;
    tabarctronller.homeTabbarDidClickedBlock = ^(NSInteger index)
    {
        if (index == 0)
        {
            for (UIView * subView in [_currentVc.view subviews]) {
                if ([subView isKindOfClass:[UIScrollView class]]) {
                    UIScrollView * tableView = (UIScrollView *)subView;
                    [tableView startHeaderRefreshing];
                }
            }
        }
    };
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    EVHomeViewController * tabarctronller = (EVHomeViewController *)self.tabBarController;
    tabarctronller.homeTabbarDidClickedBlock = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
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

#pragma mark -👣 Target actions
- (void)searchClick
{
    EVSearchAllViewController *searchVC = [[EVSearchAllViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 🤝 Delegate
#pragma mark -- WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            //要闻
            EVImportantNewsViewController *importantVC = [[EVImportantNewsViewController alloc] init];
            importantVC.view.backgroundColor = CCColor(247, 247, 247);
            return importantVC;
        }
            break;
        case 1:
        {
            //快讯
             EVFastNewsViewController *fastVC = [[EVFastNewsViewController alloc] init];
            return fastVC;
        }
        case 2:
        {
            //股市
            EVNewsStocksViewController *stockVC = [[EVNewsStocksViewController alloc] init];
            return stockVC;
        }
        case 3:
        {
            //专栏
            EVSpeciaColumnViewController * speciaColumnVC = [[EVSpeciaColumnViewController alloc] init];
            return speciaColumnVC;
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

- (void)pageController:(WMPageController * _Nonnull)pageController didEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info
{
    _currentVc = viewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
