//
//  UIView+SDExtension.m
//  SDRefreshView
//
//  Created by aier on 15-2-23.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * GitHub: https://github.com/gsdios
 *                                                      *
 *********************************************************************************
 
 */


#import "UIView+SDExtension.h"

@implementation UIView (SDExtension)

- (CGFloat)sd_height
{
    return self.frame.size.height;
}

- (void)setSd_height:(CGFloat)sd_height
{
    CGRect temp = self.frame;
    temp.size.height = sd_height;
    self.frame = temp;
}

- (CGFloat)sd_width
{
    return self.frame.size.width;
}

- (void)setSd_width:(CGFloat)sd_width
{
    CGRect temp = self.frame;
    temp.size.width = sd_width;
    self.frame = temp;
}


- (CGFloat)sd_y
{
    return self.frame.origin.y;
}

- (void)setSd_y:(CGFloat)sd_y
{
    CGRect temp = self.frame;
    temp.origin.y = sd_y;
    self.frame = temp;
}

- (CGFloat)sd_x
{
    return self.frame.origin.x;
}

- (void)setSd_x:(CGFloat)sd_x
{
    CGRect temp = self.frame;
    temp.origin.x = sd_x;
    self.frame = temp;
}



@end
