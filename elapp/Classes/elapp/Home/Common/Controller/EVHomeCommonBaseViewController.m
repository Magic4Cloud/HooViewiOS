//
//  EVHomeCommonBaseViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeCommonBaseViewController.h"

@interface EVHomeCommonBaseViewController ()

@end

@implementation EVHomeCommonBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    EVHomeScrollViewController *homeScrollVC = (EVHomeScrollViewController *)self.parentViewController;
    
    self.homeScrollView = homeScrollVC;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewControllerItem.viewLoadFinish = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
