//
//  EVHVTLWatchBtnView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/25.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVTLWatchBtnView.h"

@implementation EVHVTLWatchBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    NSArray *imageArr = @[@"btn_sreenshot_n",@"btn_gift_n_s"];
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, (40 * i) + (16 * i), 40, 40);
        [self addSubview:button];
        button.tag = 9000+i;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonTag:)]) {
        [self.delegate buttonTag:btn];
    }
}
@end
