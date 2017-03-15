//
//  EVSearchBar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import "EVSearchBar.h"

@implementation EVSearchBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
    }
    return self;
}

// 设置参数
- (void)configuration
{
    self.tintColor = [UIColor evMainColor];
    
    // 获取当前对象的底部视图
    UIView *bgView = [self.subviews objectAtIndex:0];
    CALayer *bgLayer = [CALayer layer];
    bgLayer.backgroundColor = [UIColor evBackgroundColor].CGColor;
    if ( IOS8_OR_LATER )
    {
        bgLayer.frame = CGRectMake(0, - 20, bgView.bounds.size.width, bgView.bounds.size.height + 20);
        [bgView.layer addSublayer:bgLayer];
    }
    else
    {
        bgLayer.frame = CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height + 20);
        [bgView.layer.sublayers[0] addSublayer:bgLayer];
    }
}

+ (instancetype)cc_SearchBar
{
    EVSearchBar *mysearchBar = [[EVSearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    return mysearchBar;
}


@end
