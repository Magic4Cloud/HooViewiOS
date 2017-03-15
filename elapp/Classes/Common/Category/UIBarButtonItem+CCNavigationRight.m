//
//  UIBarButtonItem+CCNavigationRight.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "UIBarButtonItem+CCNavigationRight.h"

@implementation UIBarButtonItem (CCNavigationRight)


+(instancetype) rightBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 40);
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = EVNormalFont(15);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIColor *textColor = nil;
    if ( color == nil )
    {
        textColor = [UIColor textBlackColor];
    }
    [rightButton setTitleColor:textColor forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return rightBarButtonItem;
}

+(instancetype) leftBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 40);
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = EVNormalFont(15);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIColor *textColor = nil;
    if ( color == nil )
    {
        textColor = [UIColor textBlackColor];
    }
    [rightButton setTitleColor:textColor forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return rightBarButtonItem;
}



@end
