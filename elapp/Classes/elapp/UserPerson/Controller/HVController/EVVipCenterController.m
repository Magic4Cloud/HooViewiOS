//
//  EVVipCenterController.m
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipCenterController.h"
#import "EVVipDetailCenterView.h"
#import "WMPanGestureRecognizer.h"


#import "EVSelfStockViewController.h"

@interface EVVipCenterController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *musicCategories;
@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint lastPoint;


@end

@implementation EVVipCenterController


#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
    [self.view addGestureRecognizer:self.panGesture];

//    [self loadImageCarousel];
//    
//    WEAK(self)
//    [_iNewsTableview addRefreshHeaderWithRefreshingBlock:^{
//        [weakself loadImageCarousel];
//        [weakself loadNewData];
//    }];
//    
//    [_iNewsTableview addRefreshFooterWithRefreshingBlock:^{
//        [weakself loadMoreData];
//    }];
//    
//    [self.iNewsTableview.mj_footer setHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [self loadNewData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark - 🖍 User Interface layout
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressViewWidths = @[@16,@16,@16,@16];
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.musicCategories.count;
        self.menuHeight = 44;
        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
    }
    return self;
}


- (void)setupView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(ScreenWidth - 44 -10, 20, 44,44);
    [searchButton setImage:[UIImage imageNamed:@"btn_return_n"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchButton];
    
    UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_return_n"]];
    icon.frame = CGRectMake(4, 20, 44, 44);
    [self.view addSubview:icon];

    
    
}



#pragma mark - 🌐Networks





#pragma mark -👣 Target actions
- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    
    CGPoint currentPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat targetPoint = velocity.y < 0 ? kNavigationBarHeight : kNavigationBarHeight + kWMHeaderViewHeight;
        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) * 1.0 > fabs(targetPoint - self.viewTop)) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewTop = targetPoint;
            } completion:nil];
            
            return;
        }
        
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    self.viewTop += yChange;
    self.lastPoint = currentPoint;
}


- (void)searchClick {
    NSLog(@"搜索");
}



#pragma mark - 🌺  Delegate & Datasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    //自选
    EVSelfStockViewController *allStockVC = [[EVSelfStockViewController alloc] init];
    allStockVC.view.frame = CGRectMake(0, 10, ScreenWidth, ScreenHeight - 113 -10);
    allStockVC.stockType = EVSelfStockTypeAll;
    return allStockVC;
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.musicCategories[index];
}



#pragma mark -   Getter
- (NSArray *)musicCategories {
    if (!_musicCategories) {
        _musicCategories = @[@"直播", @"秘籍", @"专栏", @"粉丝"];
    }
    return _musicCategories;
}


#pragma mark -   Setter
- (void)setViewTop:(CGFloat)viewTop {
    
    _viewTop = viewTop;
    
    if (_viewTop <= kNavigationBarHeight) {
        _viewTop = kNavigationBarHeight;
    }
    
    if (_viewTop > kWMHeaderViewHeight + kNavigationBarHeight) {
        _viewTop = kWMHeaderViewHeight + kNavigationBarHeight;
    }
    
    self.viewFrame = CGRectMake(0, _viewTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _viewTop);
}











@end
