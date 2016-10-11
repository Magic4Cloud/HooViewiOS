//
//  EVCenterPresentView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCenterPresentView.h"
#import <PureLayout/PureLayout.h>
#import "NSString+Extension.h"

@interface EVCenterPresentView ()

@property (nonatomic,weak) UIImageView *imageView;

@property (nonatomic,strong) CAAnimationGroup *portraitUpAnimation;
@property (nonatomic,strong) CAAnimationGroup *portraitDownAnimation;
@property (nonatomic,strong) CAAnimationGroup *horizonalLeftAnimation;
@property (nonatomic,strong) CAAnimationGroup *horizonalRightAnimation;
@property (nonatomic,strong) NSArray *animations;

@end

@implementation EVCenterPresentView

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
    self.userInteractionEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView autoCenterInSuperview];
    [imageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
    _imageView = imageView;
    imageView.alpha = 0;
}

- (void)dealloc
{
    CCLog(@"CCCenterPresentView dealloc");
    [_imageView.layer removeAllAnimations];
    [_imageView removeFromSuperview];
    _imageView = nil;
}

- (void)startAnimationWithPresent:(EVStartGoodModel *)present
{
    if ( present.anitype == CCPresentAniTypeStaticImage )
    {
        NSString *imageStr = [NSString stringWithFormat:@"%@", [present.ani md5String]];
        UIImage *image = [UIImage imageWithContentsOfFile:PRESENTFILEPATH(imageStr)];
        _imageView.image = image;
        [_imageView.layer addAnimation:self.horizonalRightAnimation forKey:nil];
    }
}

- (CAAnimationGroup *)horizonalRightAnimation
{
    if ( _horizonalRightAnimation == nil )
    {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        CGPoint leftOutSidePoint = CGPointMake(-0.5 * width, 0.5 * height );
        CGPoint rightOutSidePoint = CGPointMake(1.0 * width, 0.5 * height );
        
        _horizonalRightAnimation = [self animtionFromStart:leftOutSidePoint transitionPoint:_imageView.center endPoint:rightOutSidePoint];
    }
    return _horizonalRightAnimation;
}

- (CAAnimationGroup *)animtionFromStart:(CGPoint)startPoint
                        transitionPoint:(CGPoint)transitionPoint
                               endPoint:(CGPoint)endPoint
{
    CAKeyframeAnimation *keyPath = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:transitionPoint];
    [path addLineToPoint:transitionPoint];
    [path addLineToPoint:transitionPoint];
    [path addLineToPoint:endPoint];
    keyPath.path = path.CGPath;
    keyPath.keyTimes = @[@0, @0.3, @0.5, @0.7, @1];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @1.0;
    opacity.toValue = @1.0;
    
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@1.0, @1.0, @2.0, @1.0, @2.0, @1.0, @2.0, @1.0, @1.0];
    scale.keyTimes = @[@0, @0.3, @0.36, @0.42, @0.48, @0.54, @0.62, @0.7, @1];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[keyPath, opacity, scale];
    group.duration = DEFAULT_ANIMTION_TIME;
    group.removedOnCompletion = YES;
    group.delegate = self;
    
    return group;
}

@end
