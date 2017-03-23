//
//  EVMarketViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMarketViewController.h"
#import "EVSortMarketViewController.h"
#import "EVSelectMarketViewController.h"
#import "EVLabelsTabbarItem.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"

@interface EVMarketViewController ()

@end

@implementation EVMarketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
}

- (NSArray *)currChildrenViewControllers
{
    NSMutableArray *cildrenControllers = [NSMutableArray arrayWithCapacity:3];
    
    // 关注
    EVLabelsTabbarItem *replayItem = [[EVLabelsTabbarItem alloc] init];
    replayItem.title = @"市场";
    replayItem.index = 1;
    EVSortMarketViewController *friendVC = [[EVSortMarketViewController alloc] init];
    friendVC.viewControllerItem = replayItem;
    [cildrenControllers addObject:friendVC];
    
    // 热门
    EVLabelsTabbarItem *nowItem = [[EVLabelsTabbarItem alloc] init];
    nowItem.title =@"自选";
    nowItem.index = 1;
    EVSelectMarketViewController *nowVC = [[EVSelectMarketViewController alloc] init];
    nowVC.viewControllerItem = nowItem;
    [cildrenControllers addObject:nowVC];
    
    return cildrenControllers;
}

- (void)homeScrollNavgationBarDidSeleceIndex:(NSInteger)index
{
    
    if (index==1) {
        //如果点击自选  没有登录则弹出登录界面并不切换界面
        if ([[EVLoginInfo localObject].sessionid isEqualToString:@""] || [EVLoginInfo localObject].sessionid == nil) {
            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
            [self presentViewController:navighaVC animated:YES completion:nil];
            return;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
}

- (NSInteger)defaultSelectedIndex
{
    return 0;
}

@end
