//
//  EVEditGlobalViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/30.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVEditGlobalViewController.h"
#import "SGSegmentedControl.h"
#import "EVNameGlobalController.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"

@interface EVEditGlobalViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UILabel *tipTopLabel;

@property (nonatomic, weak) UIScrollView  *backScrollView;

@property (nonatomic, weak) UIButton *rightButton;

@property (nonatomic, weak) UIButton *refreshButton;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;



@end

@implementation EVEditGlobalViewController
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
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"全球内容管理";
    
    [self addUpView];
    

    [self addRightBarButton];
    
    [self loadData];
}

- (void)loadData
{

}
- (void)addRightBarButton
{
    UIButton *rightButton = [[UIButton alloc] init];
    
    [rightButton setTitle:@"完成" forState:(UIControlStateNormal)];
    rightButton.frame = CGRectMake(0, 0, rightButton.imageView.image.size.width, rightButton.imageView.image.size.height);
    self.rightButton = rightButton;
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)rightClick:(UIButton *)btn
{

    //    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
    //
    //    [self presentViewController:navighaVC animated:YES completion:nil];
}

- (void)popBack
{
    if (self.popBlock) {
        self.popBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addUpView
{
//    NSArray *titleArray = @[@"全球指数",@"全球商品",@"全球汇率"];
//    
//    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
//    topBackView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:topBackView];
//    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth - 30, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
//    // 必须实现的方法
//    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
//        
//    }];
//    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
//        *segmentedControlColor = [UIColor whiteColor];
//        *titleColor = [UIColor evTextColorH2];
//        *selectedTitleColor = [UIColor evMainColor];
//        *indicatorColor = [UIColor evMainColor];
//    }];
//    self.topSView.selectedIndex = 0;
//    [self.view addSubview:_topSView];
    
    UILabel *tipTopLabel = [[UILabel alloc] init];
    tipTopLabel.backgroundColor = [UIColor evTipColor];
    tipTopLabel.text = @"  点击添加指数,再次点击取消添加";
    tipTopLabel.font = [UIFont textFontB3];
    tipTopLabel.frame = CGRectMake(0,44, ScreenWidth, 20);
    [self.view addSubview:tipTopLabel];
    self.tipTopLabel = tipTopLabel;
    
    
//    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, EVContentHeight)];
//    backScrollView.backgroundColor = [UIColor evBackgroundColor];
//    backScrollView.delegate = self;
//    [self.view addSubview:backScrollView];
//    self.backScrollView = backScrollView;
//    backScrollView.pagingEnabled = YES;
//    backScrollView.showsHorizontalScrollIndicator = NO;
//    backScrollView.contentSize = CGSizeMake(ScreenWidth * 3, EVContentHeight);
    
    EVNameGlobalController  *nameGVC = [[EVNameGlobalController alloc] init];
    nameGVC.selectedStocks = self.selectedStocks;
    [self addChildViewController:nameGVC];
    nameGVC.view.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
    [self.view addSubview:nameGVC.view];
    
//    EVNameGlobalController  *nameGVCTwo = [[EVNameGlobalController alloc] init];
//    [self addChildViewController:nameGVCTwo];
//    nameGVCTwo.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth,EVContentHeight);
//    [backScrollView addSubview:nameGVCTwo.view];
//    
//    
//    EVNameGlobalController  *nameGVCThree = [[EVNameGlobalController alloc] init];
//    [self addChildViewController:nameGVCThree];
//    nameGVCThree.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth,EVContentHeight);
//    [backScrollView addSubview:nameGVCThree.view];
//    
//    [self.view sendSubviewToBack:topBackView];
//    [self.view bringSubviewToFront:self.tipTopLabel];
    
    
    UIButton *refreshButton = [[UIButton alloc] init];
    refreshButton.frame = CGRectMake(ScreenWidth - 64, self.view.frame.size.height - 58, 44, 44);
    refreshButton.layer.masksToBounds = YES;
    refreshButton.layer.cornerRadius = 22;
    refreshButton.alpha = 0.7;
    [refreshButton setImage:[UIImage imageNamed:@"btn_market_refresh_n"] forState:(UIControlStateNormal)];
    [self.view addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.refreshButton = refreshButton;
    [self.view bringSubviewToFront:refreshButton];

}

- (void)refreshClick
{
    
}

//- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
//    NSLog(@"index - - %ld", (long)index);
//    // 计算滚动的位置
//    CGFloat offsetX = index * self.view.frame.size.width;
//    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
//}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    // 2.把对应的标题选中
//    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
//}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager  = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
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
