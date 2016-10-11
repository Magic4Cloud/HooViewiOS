//
//  UIWindow+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 *  获取UIWindow的根控制器
 *
 *  @return UIWindow的根控制器
 */
- (UIViewController *)visibleViewController;

@end
