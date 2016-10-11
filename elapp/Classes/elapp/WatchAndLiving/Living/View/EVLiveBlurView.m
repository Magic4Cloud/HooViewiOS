//
//  EVLiveBlurView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveBlurView.h"

@implementation EVLiveBlurView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [UIScreen mainScreen].bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:244.0/ 255 green:82.0/255 blue:9.0/255 alpha:0.9].CGColor,
                       (id)[UIColor colorWithRed:178.0/255 green:0 blue:164.0/255 alpha:0.9].CGColor,nil];
    gradient.startPoint = CGPointMake(0.3, 0);
    gradient.endPoint = CGPointMake(0.7, 1);
    gradient.opacity = 1.0;
    [self.layer addSublayer:gradient];
}

@end
