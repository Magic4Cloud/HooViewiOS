//
//  EVLiveTipsLabel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveTipsLabel.h"

#define LABEL_ANIMATION_TIME 0.5

@interface EVLiveTipsLabel ()

@property (nonatomic, assign) NSInteger points;

@end

@implementation EVLiveTipsLabel

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
    self.backgroundColor = [UIColor evMainColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:11];
}

- (void)showWithAnimationText:(NSString *)text
{
    self.text = text;
    if ( !self.hidden )
    {
        return;
    }
    self.hidden = YES;
    CGRect  frame = self.frame;
    __weak typeof(self) wself = self;
    frame.origin.y = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:LABEL_ANIMATION_TIME animations:^{
        wself.frame = frame;
    }];
}

- (void)hiddenWithAnimation
{
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    __weak typeof(self) wself = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:LABEL_ANIMATION_TIME animations:^{
        wself.frame = frame;
    } completion:^(BOOL finished) {
        wself.hidden = YES;
    }];
}

- (void)showConnecting
{
    NSString *title = nil;
    switch ( self.points )
    {
        case 0:
            title = kE_GlobalZH(@"optimization_link");
            break;
            
        case 1:
            title = kE_GlobalZH(@"optimization_link");
            break;
            
        case 2:
            title = kE_GlobalZH(@"optimization_link");
            break;
            
        default:
            break;
    }
    [self showWithAnimationText:title];
    self.points++;
    if ( self.points == 3 )
    {
        self.points = 0;
    }
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LABEL_ANIMATION_TIME + 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself showConnecting];
    });
}

@end
