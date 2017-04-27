//
//  EVMyReleaseViewController.m
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMyReleaseViewController.h"
#import "EVMyReleaseOfLiveViewController.h"//直播
#import "EVMyReleaseCheatsViewController.h"//秘籍
#import "EVMyReleaseArticleViewController.h"//文章
#import "UIViewController+Extension.h"

#import "EVHVWatchViewController.h"

#import "EVMyVideoTableViewController.h"

@interface EVMyReleaseViewController ()

@end

@implementation EVMyReleaseViewController

- (instancetype)init {
    if (self = [super init]) {
        
        self.menuViewStyle = WMMenuViewStyleLine;
        float addFont = 0;
        if (ScreenWidth>375) {
            addFont = 1;
        }
        self.titleSizeSelected = 16.0+addFont;
        self.titleSizeNormal = 16.0+addFont;
        self.progressViewBottomSpace = 1;
        self.menuHeight = 44;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
        self.menuItemWidth = 34;
        self.progressViewWidths = @[@16,@16,@16,@16];
        //        self.progressViewIsNaughty = YES;
        self.titles = @[@"直播",@"秘籍",@"文章"];
        float margin = 32;
        //        if (ScreenWidth == 320) {
        //            margin = 12;
        //        }
        
        NSNumber * marginNum = [NSNumber numberWithFloat:margin];
        float lastMargin = ScreenWidth - 26-margin*2-34*3;
        NSNumber * number = [NSNumber numberWithFloat:lastMargin];
        self.itemsMargins = @[@26,marginNum,marginNum,number];
        self.menuBGColor = [UIColor whiteColor];
        self.menuViewStyle = WMMenuViewLayoutModeLeft;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的发布";
    [self setSystemBackButton];
    
    UIView * topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor evLineColor];
    [self.menuView addSubview:topLineView];
    [topLineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [topLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [topLineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [topLineView autoSetDimension:ALDimensionHeight toSize:1];
    
    UIView * bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [UIColor evLineColor];
    [self.menuView addSubview:bottomLineView];
    [bottomLineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [bottomLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [bottomLineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [bottomLineView autoSetDimension:ALDimensionHeight toSize:1];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
            //直播
            EVMyReleaseOfLiveViewController * liveVC = [[EVMyReleaseOfLiveViewController alloc] init];
            liveVC.userModel = self.userModel;
            
            return liveVC;
        }
            break;
        case 1:
        {
            //秘籍
            EVMyReleaseCheatsViewController * cheatsVC = [[EVMyReleaseCheatsViewController alloc] init];
            return cheatsVC;
        }
        case 2:
        {
            //文章
            EVMyReleaseArticleViewController *articleCollectVC = [[EVMyReleaseArticleViewController alloc] init];
            return articleCollectVC;
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

@end
