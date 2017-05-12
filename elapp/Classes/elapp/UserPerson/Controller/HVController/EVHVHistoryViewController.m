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
//#import "EVNewsDetailWebController.h"
#import "EVNativeNewsDetailViewController.h"

#import "EVBaseNewsModel.h"

#import "EVNewsModel.h"
#import "EVVideoAndLiveModel.h"

#import "EVBaseToolManager+EVStockMarketAPI.h"
@interface EVHVHistoryViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>
{
    int currentIndex;
}

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *backScrollView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak)EVWatchHistoryView * watchHistoryView;

@property (nonatomic, weak)EVReadHistoryView *readHistoryView;

@property (nonatomic, strong) UIButton * cleanButton;
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
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_clear_n"] forState:UIControlStateNormal];
    _cleanButton = button;
    button.frame = CGRectMake(6, 0, 44, 44);
    [button addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * cleanButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = cleanButton;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArray = @[@"观看历史",@"阅读历史"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(26, 0, ScreenWidth/2, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    
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
    currentIndex = 0;
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
    _watchHistoryView = watchHistoryView;
    watchHistoryView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
    watchHistoryView.pushWatchBlock = ^(EVVideoAndLiveModel * model) {
        EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
        EVWatchVideoInfo * watchVideoInfo = [[EVWatchVideoInfo alloc] init];
        
        watchViewVC.videoAndLiveModel = model;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
        [weakself presentViewController:nav animated:YES completion:nil];
    };
    
   
    EVReadHistoryView *readHistoryView = [[EVReadHistoryView alloc] init];
    [backScrollView addSubview:readHistoryView];
    _readHistoryView = readHistoryView;
    readHistoryView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 44);
    readHistoryView.pushWatchBlock = ^(EVNewsModel *baseNewsModel) {
        EVNativeNewsDetailViewController *newsDetail = [[EVNativeNewsDetailViewController alloc] init];
        newsDetail.newsID = baseNewsModel.newsID;
        [weakself.navigationController pushViewController:newsDetail animated:YES];
    };
    
}

- (void)cleanButtonClick
{
    NSString * typeString;
    if (currentIndex == 0)
    {
        typeString = @"观看";
    }
    else
    {
        typeString = @"阅读";
    }
    
    [self showAlertWithTitle:[NSString stringWithFormat:@"确定要清除所有%@历史记录吗？",typeString] message:nil okHandler:^(UIAlertAction * _Nullable okaction) {
        [EVProgressHUD showIndeterminateForView:self.view];
        [self.baseToolManager GETCleanhistoryWithType:[NSString stringWithFormat:@"%d",currentIndex] fail:^(NSError *error) {
            [EVProgressHUD hideHUDForView:self.view];
        } success:^(NSDictionary *retinfo) {
            [EVProgressHUD hideHUDForView:self.view];
            if (currentIndex == 0) {
                [self.watchHistoryView loadNewData];
            }
            else
            {
                [self.readHistoryView loadNewData];
            }
        } sessionExpire:^{
            [EVProgressHUD hideHUDForView:self.view];
        }];
        
    } cancelHandler:^(UIAlertAction * _Nullable canCelaction) {
        
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIndex =  scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    currentIndex = index;
    CGFloat offsetX = index * self.view.frame.size.width;
    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
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
