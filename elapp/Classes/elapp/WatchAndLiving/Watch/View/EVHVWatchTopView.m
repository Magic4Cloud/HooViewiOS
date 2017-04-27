//
//  EVHVWatchTopView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchTopView.h"
#import "EVRecordControlView.h"
#import "EVVideoFunctions.h"

#define normalAlpha   0.8

@interface EVHVWatchTopView ()




@end

@implementation EVHVWatchTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addUpView];
    }
    return self;
}


- (void)addUpView
{
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(10, 10, 40, 40);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.alpha = normalAlpha;
    [self addSubview:backButton];
    backButton.layer.masksToBounds  = YES;
    backButton.layer.cornerRadius = 20;
    backButton.tag = EVHVWatchViewTypeBack;
    [backButton setImage:[UIImage imageNamed:@"btn_return_watch_n"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *fullButton = [[UIButton alloc] init];
    [self addSubview:fullButton];
    _fullButton = fullButton;
    fullButton.backgroundColor = [UIColor clearColor];
    fullButton.alpha = normalAlpha;
    fullButton.tag = EVHVWatchViewTypeFull;
    fullButton.layer.masksToBounds  = YES;
    [fullButton setImage:[UIImage imageNamed:@"btn_full-screen_n"] forState:(UIControlStateNormal)];
    [fullButton setImage:[UIImage imageNamed:@"btn_half-screen_n"] forState:(UIControlStateSelected)];
    fullButton.layer.cornerRadius = 20;
    [fullButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [fullButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [fullButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [fullButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    
    
    UIButton *shareButton = [[UIButton alloc] init];
    [self addSubview:shareButton];
    _shareButton = shareButton;
    shareButton.backgroundColor = [UIColor clearColor];
    shareButton.alpha = normalAlpha;
    shareButton.tag = EVHVWatchViewTypeShare;
    shareButton.layer.masksToBounds  = YES;
    shareButton.layer.cornerRadius = 20;
    [shareButton setImage:[UIImage imageNamed:@"btn_share_watch_n"] forState:(UIControlStateNormal)];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [shareButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [shareButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:fullButton withOffset:-10];
    [shareButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    
    UIButton *pauseButton = [[UIButton alloc] init];
    [self addSubview:pauseButton];
    self.pauseButton = pauseButton;
    pauseButton.backgroundColor = [UIColor clearColor];
    pauseButton.alpha = normalAlpha;
    pauseButton.tag = EVHVWatchViewTypePause;
    pauseButton.layer.masksToBounds = YES;
    pauseButton.layer.cornerRadius = 20;
    [pauseButton setImage:[UIImage imageNamed:@"btn_pause_n"] forState:(UIControlStateNormal)];
    [pauseButton setImage:[UIImage imageNamed:@"btn_play_live"] forState:(UIControlStateSelected)];
    [pauseButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [pauseButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [pauseButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [pauseButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *reportButton = [[UIButton alloc] init];
    [self addSubview:reportButton];
    reportButton.tag = EVHVWatchViewTypeReport;
    [reportButton setImage:[UIImage imageNamed:@"btn_report_n"] forState:(UIControlStateNormal)];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [reportButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [reportButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAppearView:)];
    [self addGestureRecognizer:singleTap];
    
}

- (void)gestureAppearView:(UITapGestureRecognizer *)sender
{
    self.hidden = YES;
}

- (void)gestureHideView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == EVHVWatchViewTypeReport) {
        [EVVideoFunctions handleReportAction];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchButttonClickType:button:)]) {
        [self.delegate watchButttonClickType:btn.tag button:btn];
    }
}


- (void)setPause:(BOOL)pause
{
    _pause = pause;
    self.pauseButton.selected = pause;
}


@end
