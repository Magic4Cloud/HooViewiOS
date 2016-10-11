//
//  UIBarButtonItem+CCNavigationRight.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCNavigationRight)

+(instancetype) rightBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action;

+(instancetype) leftBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action;


@end
