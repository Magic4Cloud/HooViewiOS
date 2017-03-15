//
//  EVHomeScrollViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeScrollViewController.h"
#import "EVHomeCommonBaseViewController.h"
#import <PureLayout.h>
#import "AppDelegate.h"
#import "EVMineViewController.h"
#import "EVSearchAllViewController.h"
#import "EVLoginInfo.h"
#import "EVEditSelfStockViewController.h"
#import "EVLoginViewController.h"



@interface EVHomeScrollViewController () <UIScrollViewDelegate, CCHomeScrollNavgationBarDelegate>
@property (nonatomic,weak) EVHomeScrollNavgationBar *navBar;

@property (nonatomic,strong) NSArray *subTitles;

@end

@implementation EVHomeScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [scrollView setNeedsLayout];
    [scrollView layoutIfNeeded];
    scrollView.scrollEnabled = NO;
    
    NSArray *childrenControllers = [self currChildrenViewControllers];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:childrenControllers.count];
    for ( EVHomeCommonBaseViewController *item  in childrenControllers )
    {
        [titles addObject:item.viewControllerItem.title];
    }
    self.subTitles = titles;
    
    CGFloat scrollW = childrenControllers.count * self.view.bounds.size.width;
    [scrollView setContentSize:CGSizeMake(scrollW, 0)];
    
    if ( self.selectedIndex < childrenControllers.count )
    {
        CGPoint contentOffset = CGPointMake(self.selectedIndex * self.view.bounds.size.width, 0);
        [scrollView setContentOffset:contentOffset];
    }
    
    self.scrollView = scrollView;
    
    for ( EVHomeCommonBaseViewController *item in childrenControllers )
    {
        [self addChildViewController:item];
    }
    
    self.selectedIndex = [self defaultSelectedIndex];
    
    CGFloat x = self.selectedIndex * self.view.bounds.size.width;
    CGFloat y = 0;
    [scrollView setContentOffset:CGPointMake(x, y)];
    
    self.view.backgroundColor = [UIColor evBackgroundColor];
}


- (EVHomeScrollNavgationBar *)navBar
{
    if (_navBar == nil) {
        EVHomeScrollNavgationBar *navBar = [[EVHomeScrollNavgationBar alloc] initWithSubTitles:self.subTitles];
        navBar.delegate = self;
        [self.view addSubview:navBar];
        navBar.topConstraint = [navBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [navBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [navBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [navBar autoSetDimension:ALDimensionHeight toSize:CCHOMENAV_HEIGHT];
        self.navBar = navBar;
        navBar.title = [self showTitle];
        navBar.selectedIndex = 1;
    }
    return _navBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
}

- (NSInteger)defaultSelectedIndex
{
    return 0;
}

- (NSArray *)currChildrenViewControllers
{
    return nil;
}

- (NSString *)showTitle
{
    return nil;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex < 0 || selectedIndex >= self.childViewControllers.count)
        return;
    
    _selectedIndex = selectedIndex;
    EVHomeCommonBaseViewController *item = self.childViewControllers[selectedIndex];
    if ( !item.viewControllerItem.viewLoadFinish )
    {
        item.view.frame = CGRectMake(selectedIndex * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.scrollView addSubview:item.view];
    }
    self.navBar.selectedIndex = selectedIndex;
}

- (void)homeScrollViewDidScroll
{
    if ( !_listenerScrollState )
    {
        return;
    }
    
    for ( UIViewController *controller in  self.childViewControllers )
    {
        if ( [controller isKindOfClass:[EVHomeCommonBaseViewController class]] && [controller respondsToSelector:@selector(homeScrollViewDidScroll)] )
        {
            EVHomeCommonBaseViewController *item = (EVHomeCommonBaseViewController *)controller;
            [item homeScrollViewDidScroll];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if ( page != self.selectedIndex )
    {
        self.selectedIndex = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if ( page != self.selectedIndex )
    {
        self.selectedIndex = page;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat percent = 0;
    percent = scrollView.contentOffset.x / ( scrollView.contentSize.width - scrollView.frame.size.width );
    if ( percent < 0 )
    {
        percent = 0;
    }
    
    if ( percent > 1 )
    {
        percent = 1;
    }
    
    self.navBar.scrollPercent = percent;
    
    [self homeScrollViewControllerShowBar];
    
    [self homeScrollViewDidScroll];
}

#pragma mark - CCHomeScrollNavgationBarDelegate
- (void)homeScrollViewUserDidMoveToPercent:(CGFloat)percent
{
    if ( percent < 0 )
    {
        percent = 0;
    }
    else if ( percent > 1 )
    {
        percent = 1;
    }
    CGFloat contentOffsetX = ( _scrollView.contentSize.width - _scrollView.bounds.size.width ) * percent;
    [_scrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
}

- (void)homeScrollNavgationBarDidClicked:(EVHomeScrollNavgationBarButton)btn
{
    switch ( btn )
    {
        case EVHomeScrollNavgationBarEditButton:
        {
            EVEditSelfStockViewController *mineVC = [[EVEditSelfStockViewController alloc] init];
            mineVC.commitBlock = ^(){
                
            };
            [self.navigationController pushViewController:mineVC animated:YES];
        }
            break;
            
        case EVHomeScrollNavgationBarSearchButton:
        {
            EVSearchAllViewController *searchAllVC = [[EVSearchAllViewController alloc] init];
            [self.navigationController pushViewController:searchAllVC animated:YES];
        }
            break;
    }
}

- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index
{
  
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
}

- (void)homeScrollNavgationBarDidDragToUpdateIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
    self.selectedIndex = index;
}

- (void)homeScrollViewControllerHideBar
{
   [((AppDelegate *)[UIApplication sharedApplication].delegate).homeVC hideHomeTabbarWithAnimation];
    [self.navBar hideHomeNavigationBar];
}

- (void)homeScrollViewControllerShowBar
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).homeVC showHomeTabbarWithAnimation];
    [self.navBar showHomeNavigationBar];
}

@end
