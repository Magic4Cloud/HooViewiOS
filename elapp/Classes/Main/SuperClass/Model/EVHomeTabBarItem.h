//
//  EVHomeTabBarItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVHomeTabBarItem : UITabBarItem

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic,weak) UIViewController *sercontr;
- (instancetype)initWithController:(UIViewController *)controller;
+ (instancetype)homeTabBarItemWithController:(UIViewController *)controller;

@end
