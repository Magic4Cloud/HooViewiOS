//
//  EVConsultViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/22.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVConsultViewController.h"
#import "EVConsultTopView.h"
#import "SGSegmentedControl.h"
#import "EVChooseNewsViewController.h"
#import "EVFastNewsViewController.h"
#import "EVImportantNewsViewController.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVSearchAllViewController.h"

@interface EVConsultViewController ()<EVConsultTopViewDelegate,UIScrollViewDelegate,UITableViewDelegate>
@property (nonatomic, weak) EVConsultTopView *consultTopView;
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, weak) UIScrollView *consultScrollView;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVImportantNewsViewController *importNewsVC;

@property (nonatomic, strong) EVFastNewsViewController *fastNewsVC;

@property (nonatomic, strong) EVChooseNewsViewController *chooseNewsVC;

@end

@implementation EVConsultViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资讯";
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addUpView];
    
        
}
- (void)addUpView
{
    EVConsultTopView *consultTopView = [[EVConsultTopView alloc] init];
    consultTopView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.view addSubview:consultTopView];
    consultTopView.delegate = self;
    self.consultTopView = consultTopView;

    
    UIScrollView *consultScrollView = [[UIScrollView alloc] init];
    consultScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-44);
    consultScrollView.delegate = self;
    [self.view addSubview:consultScrollView];
    consultScrollView.pagingEnabled = YES;
    consultScrollView.contentSize = CGSizeMake(ScreenWidth  * 3, ScreenHeight-50);
    consultScrollView.showsHorizontalScrollIndicator = NO;
    self.consultScrollView = consultScrollView;
    

    EVImportantNewsViewController *importantVC = [[EVImportantNewsViewController alloc] init];
    importantVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
    [self addChildViewController:importantVC];
    importantVC.view.backgroundColor = [UIColor grayColor];
    WEAK(self)
    importantVC.offsetBlock = ^(CGFloat offsetF,BOOL isStop) {
        CGFloat alphaF = offsetF/64;
        [weakself updateTopViewAlpha:alphaF isStop:isStop consultView:consultTopView];
    };
    [consultScrollView addSubview:importantVC.view];
    self.importNewsVC = importantVC;
    
    
    EVFastNewsViewController *fastVC = [[EVFastNewsViewController alloc] init];
    fastVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 44);
    [self addChildViewController:fastVC];
    fastVC.offsetBlock = ^(CGFloat offsetF,BOOL isStop) {
        CGFloat alphaF = offsetF/64;
       [weakself updateTopViewAlpha:alphaF isStop:isStop consultView:consultTopView];
    };
    [consultScrollView addSubview:fastVC.view];
    self.fastNewsVC = fastVC;
    
    
    EVChooseNewsViewController *chooseVC = [[EVChooseNewsViewController alloc] init];
    chooseVC.view.frame = CGRectMake(ScreenWidth  * 2, 0, ScreenWidth, ScreenHeight - 44);
    [self addChildViewController:chooseVC];
    [consultScrollView addSubview:chooseVC.view];
    
    chooseVC.offsetBlock = ^(CGFloat offsetF,BOOL isStop) {
        CGFloat alphaF = offsetF/64;
       [weakself updateTopViewAlpha:alphaF isStop:isStop consultView:consultTopView];
       
    };
    [self.view bringSubviewToFront:consultTopView];
    self.chooseNewsVC = chooseVC;
}

- (void)updateTopViewAlpha:(CGFloat)alpha isStop:(BOOL)stop consultView:(EVConsultTopView *)consultView
{
    consultView.contentView.backgroundColor = [UIColor whiteColor];
    consultView.contentView.alpha = alpha;
    consultView.searchButton.backgroundColor = alpha >= 1 ? [UIColor whiteColor] : [UIColor hvPurpleColor];
    consultView.contentView.layer.borderColor = alpha >= 1 ? [UIColor colorWithHexString:@"#f8f8f8"].CGColor : [UIColor clearColor].CGColor;
    UIImage *searchImage = alpha >= 1? [UIImage imageNamed:@"btn_market_search_n"] : [UIImage imageNamed:@"btn_news_search_n"];
    [consultView.searchButton setImage:searchImage forState:(UIControlStateNormal)];
    if (alpha > 0) {
        [consultView.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
            *segmentedControlColor = [UIColor clearColor];
            *titleColor = [UIColor evTextColorH2];
            *selectedTitleColor = [UIColor evMainColor];
            *indicatorColor = [UIColor evMainColor];
        }];
    }else {
        [consultView.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
            *segmentedControlColor = [UIColor clearColor];
            *titleColor = [UIColor whiteColor];
            *selectedTitleColor = [UIColor whiteColor];
            *indicatorColor = [UIColor whiteColor];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self scrollViewChangeTopViewIndex:index];
    if (index == 0) {
        self.consultTopView.searchButton.hidden = NO;
    }else {
        self.consultTopView.searchButton.hidden = YES;
    }
    [self.consultTopView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
    
}

#pragma mark - ***********         Init💧         ***********
- (void)topViewDidSeleteIndex:(NSInteger)index
{
    // 计算滚动的位置
    [self scrollViewChangeTopViewIndex:index];
    CGFloat offsetX = index * self.view.frame.size.width;
    self.consultScrollView.contentOffset = CGPointMake(offsetX, 0);
    if (index == 0) {
        self.consultTopView.searchButton.hidden = NO;
    }else {
        self.consultTopView.searchButton.hidden = YES;
    }
}

- (void)scrollViewChangeTopViewIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            CGFloat alphaF = self.importNewsVC.iNewsTableview.contentOffset.y/64;
            [self updateTopViewAlpha:alphaF isStop:YES consultView:self.consultTopView];
            
        }
            break;
        case 1:
        {
            CGFloat alphaF = self.fastNewsVC.newsTableView.contentOffset.y/64;
            [self updateTopViewAlpha:alphaF isStop:YES consultView:self.consultTopView];
        }
            break;
        case 2:
        {
            CGFloat alphaF = self.chooseNewsVC.newsTableView.contentOffset.y/64;
            [self updateTopViewAlpha:alphaF isStop:YES consultView:self.consultTopView];
        }
            break;
            
        default:
            break;
    }
}

- (void)didSeleteSearch
{
    EVSearchAllViewController *searchVC = [[EVSearchAllViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
