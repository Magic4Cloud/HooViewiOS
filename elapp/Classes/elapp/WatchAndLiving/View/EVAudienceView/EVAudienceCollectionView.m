//
//  EVAudienceCollectionView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudienceCollectionView.h"

@interface EVAudienceCollectionView ()

@property (nonatomic, assign) BOOL animationHasStart;

@end

@implementation EVAudienceCollectionView

- (void)startAnimation
{
    if ( self.animationHasStart )
    {
        return;
    }
    self.animationHasStart = YES;
    
    CGRect frame = self.frame;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(ScreenWidth + 0.5 * frame.size.width, frame.origin.y +  frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x + 0.5 * frame.size.width ,frame.origin.y + frame.size.height)];
    animation.path = path.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.duration = 2.0;
    animation.repeatCount = 0;
    animation.removedOnCompletion = YES;
    [self.layer addAnimation:animation forKey:nil];
}

@end
