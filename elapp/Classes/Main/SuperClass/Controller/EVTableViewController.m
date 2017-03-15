//
//  EVTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTableViewController.h"
#import "UIButton+Extension.h"

@interface EVTableViewController ()<UIGestureRecognizerDelegate>

@end

@implementation EVTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
}

- (void)setLeftItem
{
    if ( self.navigationController.viewControllers.count <= 1 )
    {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        
        return;
    }
    
    UIButton *backBtn = [[UIButton alloc] initWithTitle:@""];
    [backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateSelected];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ( self.navigationController )
    {
        [self setLeftItem];
    }
    
    if ( !IOS8_OR_LATER &&
        self.navigationController )
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        return;
    }

    if ( self.navigationController )
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UIGestureRecogiserDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( !IOS8_OR_LATER )
    {
        return NO;
    }
    
    if ( self.navigationController.viewControllers.count <= 1 )
    {
        return NO;
    }
    
    return YES;
}

@end
