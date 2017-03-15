//
//  EVRefreshSuccessView.m
//  elapp
//
//  Created by Lcrnice on 17/1/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVRefreshSuccessView.h"

@interface EVRefreshSuccessView ()

@property (nonatomic, strong) UILabel *successLab;

- (void)p_configNewsCount:(NSUInteger)count;

@end

@implementation EVRefreshSuccessView

+ (void)showRefreshSuccessViewTo:(UIView *)view newsCount:(NSUInteger)count {
    [EVRefreshSuccessView showRefreshSuccessViewTo:view newsCount:count offsetY:0];
}

+ (void)showRefreshSuccessViewTo:(UIView *)view newsCount:(NSUInteger)count offsetY:(CGFloat)offsetY {
    NSAssert(view, @"刷新成功视图不能为空");
    
    static BOOL showing = NO;
    if (showing) {
        return;
    }
    showing = YES;
    
    EVRefreshSuccessView *successView = [EVRefreshSuccessView new];
    [view addSubview:successView];
    [successView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [successView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [successView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:offsetY];
    [successView autoSetDimension:ALDimensionHeight toSize:20];
    [successView p_configNewsCount:count];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        successView.alpha = 0;
        [successView removeFromSuperview];
        showing = NO;
    });
}

#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *successView = [[UIView alloc] init];
        [self addSubview:successView];
        successView.frame = CGRectMake(0, 0, ScreenWidth, 20);
        successView.backgroundColor = [UIColor evMainColor];
        successView.alpha = 0.7;
        
        UILabel *successLabel = [[UILabel alloc] init];
        [successView addSubview:successLabel];
        successLabel.frame = CGRectMake(0, 0, ScreenWidth, 20);
        successLabel.textColor = [UIColor whiteColor];
        successLabel.backgroundColor = [UIColor clearColor];
        successLabel.font   = [UIFont systemFontOfSize:14];
        successLabel.textAlignment = NSTextAlignmentCenter;
        self.successLab  = successLabel;
    }
    return self;
}

- (void)p_configNewsCount:(NSUInteger)count {
    self.successLab.text = [NSString stringWithFormat:@"本次更新%ld条新闻", count];
}

#pragma mark - getter 💤


@end
