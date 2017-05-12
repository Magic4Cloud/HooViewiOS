//
//  EVHVEyesViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVEyesViewController.h"
#import "SGSegmentedControl.h"
#import "EVFastNewsModel.h"
#import "EVHVEyesDetailView.h"
#import "EVBaseToolManager+EVNewsAPI.h"
//#import "EVNewsDetailWebController.h"
#import "EVNativeNewsDetailViewController.h"

@interface EVHVEyesViewController ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *consultScrollView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, weak) EVHVEyesDetailView *oneView;
@property (nonatomic, weak) EVHVEyesDetailView *twoView;
@property (nonatomic, weak) EVHVEyesDetailView *threeView;
@end

@implementation EVHVEyesViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"火眼金睛";
    [self addUpView];
}


- (void)addUpView
{
    NSMutableArray *segmentArr = [NSMutableArray array];
    for (EVHVEyesModel *eyesModel in self.eyesArray) {
        [segmentArr addObject:eyesModel.name];
    }
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 1, ScreenWidth, 44) delegate:self childVcTitle:segmentArr indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        *segmentedControlStaticType = SGSegmentedControlStaticTypeDefault;
    }];
    
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [self.view addSubview:_topSView];
    
    
    UIScrollView *consultScrollView = [[UIScrollView alloc] init];
    consultScrollView.frame = CGRectMake(0, 45, ScreenWidth, ScreenHeight-44);
    consultScrollView.delegate = self;
    [self.view addSubview:consultScrollView];
    consultScrollView.pagingEnabled = YES;
    consultScrollView.contentSize = CGSizeMake(ScreenWidth  * 3, ScreenHeight-44);
    consultScrollView.showsHorizontalScrollIndicator = NO;
    self.consultScrollView = consultScrollView;
    
    
    if (self.eyesArray.count >= 1) {
        EVHVEyesDetailView *oneDetail = [[EVHVEyesDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44) model: self.eyesArray[0]];
        [consultScrollView addSubview:oneDetail];
        oneDetail.backgroundColor = [UIColor evBackgroundColor];
        self.oneView = oneDetail;
        __weak typeof(EVHVEyesDetailView *) weakView = oneDetail;
        oneDetail.eyesBlock = ^(EVHVEyesModel *eyesModel) {
            [self pushNewDetailVCModel:eyesModel view:weakView model:self.eyesArray[0]];
        };
    }
    
    if (self.eyesArray.count >= 2) {
        EVHVEyesDetailView *twoDetail = [[EVHVEyesDetailView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 44) model:self.eyesArray[1]];
        [consultScrollView addSubview:twoDetail];
        twoDetail.backgroundColor = [UIColor evBackgroundColor];
        self.twoView = twoDetail;
        __weak typeof(EVHVEyesDetailView *) weakView = twoDetail;
        twoDetail.eyesBlock = ^(EVHVEyesModel *eyesModel) {
            [self pushNewDetailVCModel:eyesModel view:weakView model:self.eyesArray[1]];
        };
        
    }
    
    if (self.eyesArray.count >= 3) {
        EVHVEyesDetailView *threeDetail = [[EVHVEyesDetailView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - 44) model: self.eyesArray[2]];
        [consultScrollView addSubview:threeDetail];
        threeDetail.backgroundColor = [UIColor evBackgroundColor];
        self.threeView = threeDetail;
        __weak typeof(EVHVEyesDetailView *) weakView = threeDetail;
        threeDetail.eyesBlock = ^(EVHVEyesModel *eyesModel) {
            [self pushNewDetailVCModel:eyesModel view:weakView model:self.eyesArray[2]];
        };
    }
}
   

- (void)pushNewDetailVCModel:(EVHVEyesModel *)eyesModel view:(EVHVEyesDetailView *)view model:(EVHVEyesModel*)model
{
    EVNativeNewsDetailViewController *newsDetailVC = [[EVNativeNewsDetailViewController alloc] init];
    newsDetailVC.newsID = eyesModel.eyesID;
    newsDetailVC.refreshViewCountBlock = ^()
    {
        [view loadEyesStart:@"0" count:@"20" eyesModel:model];
    };
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.consultScrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (void)setEyesID:(NSString *)eyesID
{
    _eyesID = eyesID;
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
