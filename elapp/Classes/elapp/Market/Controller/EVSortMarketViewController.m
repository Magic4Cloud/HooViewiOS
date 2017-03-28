//
//  EVSortMarketViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVSortMarketViewController.h"
#import "EVStockBaseViewController.h"
#import "SGSegmentedControl.h"
#import "EVGlobalViewController.h"
#import "EVNotOpenView.h"
#import "EVGlobalView.h"

@interface EVSortMarketViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) EVStockBaseViewController *shStockBaseVC;
@property (nonatomic, strong) EVStockBaseViewController *hkStockBaseVC;
@property (nonatomic, strong) EVStockBaseViewController *usStockBaseVC;
@property (nonatomic, strong) EVGlobalViewController *globalVC;

@property (nonatomic, assign) NSInteger chooseIndex;
@end

@implementation EVSortMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTopPageView];
    
    
}


- (void)addTopPageView {
   
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, EVContentHeight)];
    backScrollView.backgroundColor = [UIColor evBackgroundColor];
    backScrollView.delegate = self;
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    backScrollView.pagingEnabled = YES;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth * 3, EVContentHeight);
    
    //沪深
    EVStockBaseViewController *shStockBaseVC = [[EVStockBaseViewController alloc] init];
    shStockBaseVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self addChildViewController:shStockBaseVC];
    [backScrollView addSubview:shStockBaseVC.view];
    self.shStockBaseVC = shStockBaseVC;
    self.shStockBaseVC.marketType = @"cn";
    
    //港股
    EVStockBaseViewController *hkStockBaseVC = [[EVStockBaseViewController alloc] init];
    hkStockBaseVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [self addChildViewController:hkStockBaseVC];
    [backScrollView addSubview:hkStockBaseVC.view];
    self.hkStockBaseVC = hkStockBaseVC;
     self.hkStockBaseVC.marketType = @"hk";
//    EVNotOpenView *hkNotOpenView = [[EVNotOpenView alloc] init];
//    hkNotOpenView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
//    [backScrollView addSubview:hkNotOpenView];
    
    
    //美股  暂未开通
//    EVNotOpenView *usNotOpenView = [[EVNotOpenView alloc] init];
//    usNotOpenView.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
//    [backScrollView addSubview:usNotOpenView];
    
    //全球
    EVGlobalViewController *globalVC = [[EVGlobalViewController alloc] init];
    globalVC.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
    [backScrollView addSubview:globalVC.view];
    [self addChildViewController:globalVC];
//    EVNotOpenView *globalVC = [[EVNotOpenView alloc] init];
//    globalVC.frame =  CGRectMake(ScreenWidth * 3, 0, ScreenWidth, ScreenHeight);
//    [backScrollView addSubview:globalVC];
    self.globalVC = globalVC;
    
    NSArray *titleArray = @[@"沪深",@"港股",@"全球"];

    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 64, ScreenWidth, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [self.view addSubview:_topSView];
    
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
    [self chooseIndex:index];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 2.把对应的标题选中
     NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self chooseIndex:index];
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

- (void)chooseIndex:(NSInteger)index
{
    self.chooseIndex = index;
    switch (index) {
            case 0:
        {
            self.shStockBaseVC.chooseIndex = 0;
        }
            break;
            case 1:
        {
            self.hkStockBaseVC.chooseIndex = 1;
        }
            break;
            case 2:
        {
            [self.globalVC.globalView loadData];
        }
            break;
        
        default:
            break;
    }
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
