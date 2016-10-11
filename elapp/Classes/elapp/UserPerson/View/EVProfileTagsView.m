//
//  EVProfileTagsView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVProfileTagsView.h"
#import <PureLayout.h>

@interface EVProfileTagsView ()

@property (nonatomic, strong) NSLayoutConstraint *spaceConstraint;

@end

@implementation EVProfileTagsView

- (void)dealloc
{
    for ( UIButton *btn  in self.subviews )
    {
        if ( [btn isKindOfClass:[UIButton class]] )
        {
            [btn.imageView.layer removeAllAnimations];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    NSArray *leftArray = @[@(200. / 320 * ScreenWidth),@(10. / 320 * ScreenWidth),@(140. / 320 * ScreenWidth),@(230. / 320 * ScreenWidth),@(70. / 320 * ScreenWidth)];
    
    for (int i = 0; i < 5; i ++)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
        animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 2, 2)], [NSValue valueWithCGRect:CGRectMake(0, 0, 8, 8)], [NSValue valueWithCGRect:CGRectMake(0, 0, 2, 2)]];
        animation.keyTimes = @[@(0), @(0.6), @(1)];
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@0.9, @0.05, @0.9];
        opacityAnimation.keyTimes = @[@(0), @(0.6), @(1)];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[animation,opacityAnimation];
        group.duration = 2.f;
        group.repeatCount = 10000;
        group.removedOnCompletion = NO;

        NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
        CGFloat x = [[leftArray objectAtIndex:i] doubleValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage animatedImageWithImages:images duration:0.5] forState:UIControlStateNormal];
        [self addSubview:button];
        button.hidden = YES;
        button.titleLabel.font = CCNormalFont(12);
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:x];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:i * 20];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(3.5, 14, 3.5, 10)];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.3]];
        [button setImage:[UIImage imageNamed:@"personal_image_flashpoint3"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        
        CALayer *layer = button.imageView.layer;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC * i)), dispatch_get_main_queue(), ^{
            [layer addAnimation:group forKey:@""];
        });
    }
}


@end
