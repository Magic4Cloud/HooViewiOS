//
//  EVHVHistoryViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVHistoryViewController.h"
#import "SGSegmentedControl.h"
#import "EVNullDataView.h"
#import "EVWatchHistoryView.h"
#import "EVReadHistoryView.h"
#import "EVHVWatchViewController.h"
#import "EVNewsDetailWebController.h"
#import "EVBaseNewsModel.h"

@interface EVHVHistoryViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *backScrollView;

@end

@implementation EVHVHistoryViewController

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
    self.title = @"历史记录";
    [self addUpView];
}

- (void)addUpView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArray = @[@"观看历史",@"阅读历史"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth/2, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    
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
    
    
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44)];
    backScrollView.backgroundColor = [UIColor evBackgroundColor];
    backScrollView.delegate = self;
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    backScrollView.pagingEnabled = YES;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - 44);
    WEAK(self)
    EVWatchHistoryView *watchHistoryView = [[EVWatchHistoryView alloc] init];
    [backScrollView addSubview:watchHistoryView];
    watchHistoryView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
    watchHistoryView.pushWatchBlock = ^(EVWatchVideoInfo *watchVideoInfo) {
        EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
        watchViewVC.watchVideoInfo = watchVideoInfo;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    
    EVReadHistoryView *readHistoryView = [[EVReadHistoryView alloc] init];
    [backScrollView addSubview:readHistoryView];
    readHistoryView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 44);
    readHistoryView.pushWatchBlock = ^(EVBaseNewsModel *baseNewsModel) {
        EVNewsDetailWebController *newsDetail = [[EVNewsDetailWebController alloc] init];
        newsDetail.newsID = baseNewsModel.newsID;
        newsDetail.title = baseNewsModel.title;
        [weakself.navigationController pushViewController:newsDetail animated:YES];
    };
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.view.frame.size.width;
    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
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
