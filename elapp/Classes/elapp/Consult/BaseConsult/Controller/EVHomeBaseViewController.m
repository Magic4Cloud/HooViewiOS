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

@interface EVHomeBaseViewController ()

@end

@implementation EVHomeBaseViewController
#pragma mark - 👨‍💻‍ Initialization
- (instancetype)init {
    if (self = [super init]) {
        
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 18.0f;
        self.titleSizeNormal = 16.0f;
        self.menuHeight = 44;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
        self.menuItemWidth = 50;
        self.progressViewWidths = @[@20,@20,@20,@20];
//        self.progressViewIsNaughty = YES;
        self.titles = @[@"要闻",@"快讯",@"自选",@"专栏"];
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
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
//    self.view.frame = CGRectMake(0, 30, ScreenWidth, ScreenHeight);
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
            importantVC.view.backgroundColor = [UIColor grayColor];
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
            //自选
            EVChooseNewsViewController *chooseVC = [[EVChooseNewsViewController alloc] init];
            return chooseVC;
        }
        case 3:
        {
            //专栏
            EVChooseNewsViewController *chooseVC = [[EVChooseNewsViewController alloc] init];
            return chooseVC;
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
