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
#import "EVHVCenterLiveView.h"
#import "EVVipNotOpenTableView.h"
#import "EVHVWatchViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVNotOpenView.h"
#import "EVFansOrFocusesTableViewController.h"//我的粉丝
#import "EVMyReleaseCheatsViewController.h"//秘籍

@interface EVVipCenterController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *musicCategories;
@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVVipDetailCenterView *vipCenterView;

@property (nonatomic, strong) EVVipDetailCenterView *hvCenterView;

@property (nonatomic, weak) UIButton *followButton;

@property (nonatomic, assign) CGFloat viewHeight;


@end

@implementation EVVipCenterController


#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
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
//        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
        self.titleColorSelected = [UIColor evMainColor];
        self.titleColorNormal = [UIColor evTextColorH2];
    }
    return self;
}


- (void)setupView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    UIButton *toReportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toReportButton.frame = CGRectMake(ScreenWidth - 44 -10, 20, 44,44);
    [toReportButton setImage:[UIImage imageNamed:@"btn_report_n"] forState:(UIControlStateNormal)];
    [toReportButton addTarget:self action:@selector(toReport:) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationView addSubview:toReportButton];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(4, 20, 44, 44);
    [returnButton setImage:[UIImage imageNamed:@"btn_return_n"] forState:(UIControlStateNormal)];
    [returnButton addTarget:self action:@selector(returnButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationView addSubview:returnButton];

    

    EVVipDetailCenterView * hvCenterView = [[EVVipDetailCenterView alloc] init];
    hvCenterView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    self.hvCenterView = hvCenterView;
    hvCenterView.backgroundColor = [UIColor orangeColor];
    [self.view insertSubview:hvCenterView atIndex:0];
    
}



#pragma mark - 🌐Networks

- (void)loadData {
    NSLog(@"self.watchVideoInfo.name:%@",self.usermodel.name);
    [self.baseToolManager GETBaseUserInfoWithUname:@"19215469" start:^{
        
    } fail:^(NSError *error) {
        NSLog(@"eeeeeee = %@",error);
    } success:^(NSDictionary *modelDict) {
        self.usermodel = [EVUserModel objectWithDictionary:modelDict];
        self.hvCenterView.userModel = self.usermodel;
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                                      NSParagraphStyleAttributeName: paragraphStyle};
        CGSize contentSize = [@"火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经" boundingRectWithSize:CGSizeMake(ScreenWidth - 51 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
        NSLog(@"cont = %@",NSStringFromCGSize(contentSize));

        self.viewHeight = contentSize.height + 75 + ScreenWidth * 210 / 375;
        self.viewTop = kNavigationBarHeight + contentSize.height + 75 + ScreenWidth * 210 / 375;
        
        [self updateIsFollow:self.usermodel.followed];
    } sessionExpire:^{
        
    }];

}




#pragma mark -👣 Target actions
- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    
    CGPoint currentPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        NSLog(@"%lf",velocity.y);
        CGFloat targetPoint = velocity.y < 0 ? kNavigationBarHeight : kNavigationBarHeight + self.viewHeight;
//        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) * 1.0 > fabs(targetPoint - self.viewTop)) {
//            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self.viewTop = targetPoint;
//            } completion:nil];
            self.viewTop = targetPoint;
            
            return;
        }
        
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    self.viewTop += yChange;
    self.lastPoint = currentPoint;
    
    
}

//返回
- (void)returnButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//举报
- (void)toReport:(UIButton *)sender {
    NSLog(@"举报");
}



- (void)updateIsFollow:(BOOL)follow
{
    NSString *imageStr = follow ? @"btn_concerned_s": @"btn_unconcerned_n";
    [self.followButton setImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
    NSString *titleStr = follow ? @"已关注" : @"关注";
    [self.followButton setTitle:titleStr forState:(UIControlStateNormal)];
}



#pragma mark - 🌺  Delegate & Datasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            //自选
            EVSelfStockViewController *allStockVC = [[EVSelfStockViewController alloc] init];
            allStockVC.view.frame = CGRectMake(0, 10, ScreenWidth, ScreenHeight - 113 -10);
            allStockVC.stockType = EVSelfStockTypeAll;
            return allStockVC;
        }
            break;
        case 1:
        {
            EVMyReleaseCheatsViewController *cheatVC = [[EVMyReleaseCheatsViewController alloc] init];
            return cheatVC;
        }
        case 2:
        {
            EVFansOrFocusesTableViewController *fansVC = [[EVFansOrFocusesTableViewController alloc] init];
            fansVC.type = FANS;
            fansVC.navitionHidden = YES;
            return fansVC;
        }
        case 3:
        {
            //我的粉丝
            EVFansOrFocusesTableViewController *fansVC = [[EVFansOrFocusesTableViewController alloc] init];
            fansVC.type = FANS;
            fansVC.navitionHidden = YES;
            return fansVC;
        }
        default:
        {
            return nil;
        }
            break;
    }

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

- (EVVipDetailCenterView *)hvCenterView {
    if (!_hvCenterView) {
        _hvCenterView = [[EVVipDetailCenterView alloc] init];
    }
    return _hvCenterView;
}



- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}


#pragma mark -   Setter
- (void)setViewTop:(CGFloat)viewTop {
    
    _viewTop = viewTop;
    
    if (_viewTop <= kNavigationBarHeight) {
        _viewTop = kNavigationBarHeight;
    }
    
    if (_viewTop > self.viewHeight + kNavigationBarHeight) {
        _viewTop = self.viewHeight + kNavigationBarHeight;
    }

    self.viewFrame = CGRectMake(0, _viewTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _viewTop);
    self.hvCenterView.frame = CGRectMake(0, _viewTop - self.viewHeight, [UIScreen mainScreen].bounds.size.width, self.viewHeight);
}











@end
