//
//  EVHVLiveView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVLiveView.h"


@interface EVHVLiveView ()

@property (nonatomic, weak) UIButton *liveButton;

@property (nonatomic, weak) UIButton *videoButton;

@property (nonatomic, weak) UIButton *picButton;

@property (nonatomic, weak) NSLayoutConstraint *liveWid;
@property (nonatomic, weak) NSLayoutConstraint *liveHig;

@property (nonatomic, weak) NSLayoutConstraint *videoBottom;

@property (nonatomic, weak) NSLayoutConstraint *picRight;


@end

@implementation EVHVLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
//    self.userInteractionEnabled = NO;
    UIButton *videoButton =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:videoButton];
    self.videoButton = videoButton;
    videoButton.tag = EVLiveButtonTypeVideo;
    [videoButton setImage:[UIImage imageNamed:@"btn_video_n"] forState:(UIControlStateNormal)];
    [videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [videoButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.videoBottom = [videoButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    videoButton.hidden = YES;
    [videoButton autoSetDimensionsToSize:CGSizeMake(58, 58)];
    
    
    UIButton *picButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:picButton];
    self.picButton = picButton;
    picButton.hidden = YES;
    picButton.tag = EVLiveButtonTypePic;
    [picButton setImage:[UIImage imageNamed:@"btn_word_n"] forState:(UIControlStateNormal)];
    [picButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.picRight = [picButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [picButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [picButton autoSetDimensionsToSize:CGSizeMake(58, 58)];
    
    
    UIButton *liveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:liveButton];
    liveButton.tag = EVLiveButtonTypeLive;
    self.liveButton = liveButton;
    [liveButton setImage:[UIImage imageNamed:@"btn_launch_n"] forState:(UIControlStateNormal)];
    [liveButton setImage:[UIImage imageNamed:@"btn_cancel_n"] forState:(UIControlStateSelected)];
    [liveButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [liveButton autoSetDimensionsToSize:CGSizeMake(58, 58)];
    
}

- (CABasicAnimation *)getAnmationWithdirection:(BOOL)isClockwise
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if(isClockwise)
    {
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    }
    else
    {
        animation.fromValue = [NSNumber numberWithFloat:M_PI *2];
        animation.toValue =  [NSNumber numberWithFloat: 0.f];
    }
    
    animation.duration  = 0.5;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1;
    return animation;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 1.判断下窗口能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
    // 2.判断下点在不在窗口上
    // 不在窗口上
    if ([self pointInside:point withEvent:event] == NO) return nil;
    // 3.从后往前遍历子控件数组
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--)     {
        // 获取子控件
        UIView *childView = self.subviews[i];
        // 坐标系的转换,把窗口上的点转换为子控件上的点
        // 把自己控件上的点转换成子控件上的点
        CGPoint childP = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childP withEvent:event];
        if (fitView) {
            // 如果能找到最合适的view
            return fitView;
        }
    }
    // 4.没有找到更合适的view，也就是没有比自己更合适的view
    return nil;
}



- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == EVLiveButtonTypeLive)
    {
        btn.selected = !btn.selected;
        if (btn.selected)
        {
            self.videoButton.hidden = NO;
            self.picButton.hidden = NO;
            [_videoButton.layer addAnimation:[self getAnmationWithdirection:YES] forKey:nil];
            [_picButton.layer addAnimation:[self getAnmationWithdirection:YES] forKey:nil];
            [UIView animateWithDuration:0.4 animations:^{
                self.videoBottom.constant = -68;
                self.picRight.constant = -68;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [_videoButton.layer addAnimation:[self getAnmationWithdirection:NO] forKey:nil];
            [_picButton.layer addAnimation:[self getAnmationWithdirection:NO] forKey:nil];
            [UIView animateWithDuration:0.4 animations:^{
                self.videoBottom.constant = 0;
                self.picRight.constant = 0;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.videoButton.hidden = YES;
                self.picButton.hidden = YES;
            }];
            
        }
        
    }
    if (self.buttonBlock) {
        self.buttonBlock(btn.tag,btn);
    }
}
@end
