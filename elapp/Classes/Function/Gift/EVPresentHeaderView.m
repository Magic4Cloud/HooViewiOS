//
//  EVPresentHeaderView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPresentHeaderView.h"
#import "EVHeaderView.h"
#import <PureLayout.h>

@interface EVPresentHeaderView ()<CAAnimationDelegate>

@end

@implementation EVPresentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.isAnimating = NO;
    }
    return self;
}

- (void)setUpView
{
    // 头像
    EVHeaderImageView *logoImageView = [[EVHeaderImageView alloc] init];
    [self addSubview:logoImageView];
    [logoImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    [logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:logoImageView];
    logoImageView.border = YES;
    _logoImageView = logoImageView;
    
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc ] init];
    nickNameLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    nickNameLabel.textColor = [UIColor evAssistColor];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nickNameLabel];
    [nickNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:logoImageView withOffset:5];
    [nickNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:logoImageView withOffset:5];
    _nickNameLabel = nickNameLabel;
    
    // 内容
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.font = [[EVAppSetting shareInstance] normalFontWithSize:12];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.text = kE_GlobalZH(@"send_num_gift");
    contentLable.textColor = [UIColor whiteColor];
    contentLable.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLable];
    [contentLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:logoImageView withOffset:5];
    [contentLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:logoImageView withOffset:-5];
    _contentLabel = contentLable;
    
    // 礼物图片
    UIImageView *presentImageView = [[UIImageView alloc] init];
    [self addSubview:presentImageView];
    [presentImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3];
    [presentImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-15];
    [presentImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1];
    [presentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:contentLable withOffset:2];
    _presentImageView = presentImageView;
    [presentImageView autoMatchDimension:ALDimensionWidth
                             toDimension:ALDimensionHeight
                                  ofView:presentImageView
                          withMultiplier:7/6.0];
    
    [nickNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:presentImageView withOffset:-2];
    
    // 个数
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont boldSystemFontOfSize:17];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = [NSString stringWithFormat:@"×1"];
    [self addSubview:numLabel];
    [numLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self withOffset:-5];
    [numLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-10];
    _numLabel = numLabel;
    
    EVCornerView * cornerBack = [[EVCornerView alloc] init];
    cornerBack.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
    [self insertSubview:cornerBack atIndex:0];
    [cornerBack autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGFloat corner = 4;
    [cornerBack setRadiusTopLeft:corner topRight:corner bottomLeft:corner bottomRight:corner];
    self.cornerBack = cornerBack;
}

- (CAKeyframeAnimation *)scaleAnimation
{
    if ( !_scaleAnimation )
    {
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.delegate = self;
        scaleAnimation.values = @[@1, @3, @1, @1.5, @1];
        scaleAnimation.keyTimes = @[@0, @0.1, @0.5, @0.8, @1];
        scaleAnimation.duration = 0.5;
        scaleAnimation.repeatCount = 1;
        scaleAnimation.removedOnCompletion = YES;
        [scaleAnimation setValue:ScaleAnimationId forKey:@"id"];
        _scaleAnimation = scaleAnimation;
    }
    return _scaleAnimation;
}

- (CABasicAnimation *)moveInAnimation
{
    if ( !_moveInAnimation )
    {
        CABasicAnimation *moveInAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        moveInAnimation.fromValue = @(OutX);
        moveInAnimation.toValue = @(80);
        moveInAnimation.delegate = self;
        moveInAnimation.duration = InAndOutTime;
        [moveInAnimation setValue:MoveInAnimationId forKey:@"id"];
        _moveInAnimation = moveInAnimation;
    }
    return _moveInAnimation;
}

- (CABasicAnimation *)moveOutAnimation
{
    if ( !_moveOutAnimation )
    {
        CABasicAnimation *moveOutAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        moveOutAnimation.fromValue = @(20);
        moveOutAnimation.toValue = @(OutX);
        moveOutAnimation.delegate = self;
        moveOutAnimation.duration = InAndOutTime;
        [moveOutAnimation setValue:MoveOutAnimationId forKey:@"id"];
        moveOutAnimation.removedOnCompletion = NO;
        moveOutAnimation.fillMode = kCAFillModeForwards;
        _moveOutAnimation = moveOutAnimation;
    }
    
    return _moveOutAnimation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:headerView:)] )
    {
        [self.delegate animationDidStop:anim headerView:self];
    }
}

- (void)dealloc
{
    [self.layer removeAllAnimations];
    [self.numLabel.layer removeAllAnimations];
    _numLabel = nil;
}

@end
