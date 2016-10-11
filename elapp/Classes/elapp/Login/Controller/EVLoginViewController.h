//
//  EVLoginViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

@interface EVLoginViewController : EVViewController

/**
 *  创建带有导航栏的控制器
 */
+ (UINavigationController *)loginViewControllerWithNavigationController;

@property (nonatomic,assign) BOOL autoDismiss;  // yes表示自动dismiss

@end
