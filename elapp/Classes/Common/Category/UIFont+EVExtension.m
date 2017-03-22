//
//  UIFont+EVExtension.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "UIFont+EVExtension.h"
#import "UIFont+swizzle.h"

@implementation UIFont (EVExtension)

+ (UIFont *)topBarBigFont
{
    return [UIFont systemFontOfSize:20.f];
}

+ (UIFont *)textFontB1
{
    return [UIFont systemFontOfSize:18.f];
}

+ (UIFont *)textFontB2
{
    return [UIFont systemFontOfSize:16.f];
}

+ (UIFont *)textFontB3
{
    return [UIFont systemFontOfSize:14.f];
}
@end
