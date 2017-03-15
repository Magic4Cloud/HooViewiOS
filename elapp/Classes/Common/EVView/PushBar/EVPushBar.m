//
//  EVPushBar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//



#import "EVPushBar.h"

#define kCCPushBarHeiht 64
#define kCCPushLogolWH 20
#define kCCPushMargin 10
#define kCCPushAnimationTime 2

@interface EVPushBar ()

@end

@implementation EVPushBar

- (instancetype)initWithTitle:(NSString *)title {
    if ( self = [super init] ) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:EVAppIcon forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self setUpPan];
    }
    return self;
}

- (void)setUpPan{
    // 拖拽
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    if ( self.isPushBarRemove ) {
        return;
    }
    self.isPushBarRemove = YES;
    __block CGRect mFrame = self.frame;
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0;
        mFrame.origin.y = -mFrame.size.height;
        self.frame = mFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (instancetype)pushBarWithTitle:(NSString *)title{
    return [[self alloc] initWithTitle:title];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, keyWin.bounds.size.width, kCCPushBarHeiht);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    CGRect titleLabelBounds = self.titleLabel.frame;
    CGFloat imageViewX =  (self.bounds.size.width - titleLabelBounds.size.width - kCCPushMargin - kCCPushLogolWH) * 0.5;
    CGFloat imageViewY = (self.bounds.size.height - kCCPushLogolWH) * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, kCCPushLogolWH, kCCPushLogolWH);
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.y = self.imageView.center.y;
    CGRect labelFrame = self.titleLabel.frame;
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + kCCPushMargin;
    labelFrame.origin.x = labelX;
    self.titleLabel.frame = labelFrame;
}


@end
