//
//  EVTimeLineViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTimeLineViewController.h"
#import "EVHomeCommonBaseViewController.h"
#import "EVTimeLineNewVideoViewController.h"
#import "EVHomeFriendCircleFriendViewController.h"
#import "EVFriendCircleRanklistCtrl.h"

#define kPushHotController  @"pushHotController"
#define kPushNextPage  @"pushNextPageCenter"
@interface EVTimeLineViewController ()<EVHomeHotViewControllerDelegate>


@end

@implementation EVTimeLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CCNotificationCenter addObserver:self selector:@selector(pushHotController) name:kPushHotController object:nil];
    // add by 佳南
    [CCNotificationCenter postNotificationName:kPushNextPage object:nil];
}

- (void)pushHotController
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 1, 0) animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
}

- (NSArray *)currChildrenViewControllers
{
    NSMutableArray *cildrenControllers = [NSMutableArray arrayWithCapacity:3];
    // change by 佳南
    // 关注
//    EVLabelsTabbarItem *replayItem = [[EVLabelsTabbarItem alloc] init];
//    replayItem.title = kNavigatioBarFollow;
//    replayItem.index = 1;
//    EVHomeFriendCircleFriendViewController *friendVC = [[EVHomeFriendCircleFriendViewController alloc] init];
//    friendVC.viewControllerItem = replayItem;
//    friendVC.delegate = self;
//    [cildrenControllers addObject:friendVC];
    
    // 热门
    EVLabelsTabbarItem *nowItem = [[EVLabelsTabbarItem alloc] init];
//    nowItem.title =kNavigatioBarHot;
    nowItem.title = @"火眼财经";
    nowItem.index = 1;
    EVTimeLineNewVideoViewController *nowVC = [[EVTimeLineNewVideoViewController alloc] init];
    nowVC.viewControllerItem = nowItem;
    [cildrenControllers addObject:nowVC];
    
//    EVLabelsTabbarItem *forecastItem = [[EVLabelsTabbarItem alloc] init];
//    forecastItem.title = kNavigatioBarRank;
//    forecastItem.index = 2;
//    EVFriendCircleRanklistCtrl *ranklistCtrl = [[EVFriendCircleRanklistCtrl alloc] init];
//    ranklistCtrl.viewControllerItem = forecastItem;
//    [cildrenControllers addObject:ranklistCtrl];
    
    return cildrenControllers;
}

- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index
{
    if (index == self.selectedIndex && index == 1) {
        // delete by 佳南
//        [CCNotificationCenter postNotificationName:kPushNextPage object:nil];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
}


- (void)pushHotViewController
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width , 0) animated:YES];
}


- (NSInteger)defaultSelectedIndex
{
    return 0;
}





@end
