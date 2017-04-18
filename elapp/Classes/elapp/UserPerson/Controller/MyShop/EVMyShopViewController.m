//
//  EVMyShopViewController.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVMyShopViewController.h"
#import "EVShopLiveViewController.h"
#import "EVShopVideoViewController.h"
#import "EVShopCheatsViewController.h"

#import "UIViewController+Extension.h"
@interface EVMyShopViewController ()

@end

@implementation EVMyShopViewController
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
        self.menuItemWidth = 68;
        self.progressViewWidths = @[@16,@16,@16,@16];
        //        self.progressViewIsNaughty = YES;
        self.titles = @[@"视频直播",@"精品视频",@"已买秘籍"];
        float margin = 32;
//        if (ScreenWidth == 320) {
//            margin = 12;
//        }
        
        NSNumber * marginNum = [NSNumber numberWithFloat:margin];
        float lastMargin = ScreenWidth - 26-margin*2-68*3;
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
    self.title = @"我的购买";
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
            //视频直播
            EVShopLiveViewController * liveVC = [[EVShopLiveViewController alloc] init];
            return liveVC;
        }
            break;
        case 1:
        {
            //精品视频
            EVShopVideoViewController * videoVC = [[EVShopVideoViewController alloc] init];
            return videoVC;
        }
        case 2:
        {
            //已买秘籍
            EVShopCheatsViewController * cheatsVC = [[EVShopCheatsViewController alloc] init];
            return cheatsVC;
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
