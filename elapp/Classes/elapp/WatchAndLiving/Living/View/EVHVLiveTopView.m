//
//  EVHVLiveTopView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVLiveTopView.h"

@implementation EVHVLiveTopView

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
    NSArray *tagArray = @[@(EVHVLiveTopViewTypeMute),@(EVHVLiveTopViewTypeTurn),@(EVHVLiveTopViewTypeShare)];
    NSArray *imageArray = @[@"btn_voiced_n",@"btn_turnover_n",@"btn_share_w_n"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(ScreenHeight - 132 + (i * 46), 0, 30, 30);
        button.tag = [tagArray[i] integerValue];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.9;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15.f;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"btn_mute_n"] forState:(UIControlStateSelected)];
        }
    }
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    closeButton.frame = CGRectMake(10, 0, 30, 30);
    [self addSubview:closeButton];
    closeButton.tag = EVHVLiveTopViewTypeClose;
    closeButton.backgroundColor = [UIColor blackColor];
    closeButton.alpha = 0.9;
    closeButton.layer.masksToBounds = YES;
    [closeButton setImage:[UIImage imageNamed:@"btn_off_n"] forState:(UIControlStateNormal)];
    closeButton.layer.cornerRadius = 15;
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveTopViewButtonType:button:)]) {
        [self.delegate liveTopViewButtonType:btn.tag button:btn];
    }
}
@end
