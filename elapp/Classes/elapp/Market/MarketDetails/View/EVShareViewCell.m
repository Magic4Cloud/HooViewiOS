//
//  EVShareViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVShareViewCell.h"

@implementation EVShareViewCell

//分享按钮的点击事件
- (void)shareBtnOnClick:(UIButton *)sender {
    if (self.shareBtnClickBlock) {
        self.shareBtnClickBlock(sender);
    }
}

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
    UIButton * shareWayBtn  = [[UIButton alloc] init];
    [self addSubview:shareWayBtn];
    self.shareWayBtn = shareWayBtn;
    [shareWayBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
    [shareWayBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shareWayBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [shareWayBtn addTarget:self action:@selector(shareBtnOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *shareWayNameLabel = [[UILabel alloc] init];
    shareWayNameLabel.textColor = [UIColor evTextColorH2];
    shareWayNameLabel.font = [UIFont textFontB2];
    [self addSubview:shareWayNameLabel];
    shareWayNameLabel.textAlignment = NSTextAlignmentCenter;
    self.shareWayNameLabel = shareWayNameLabel;
    [shareWayNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:shareWayBtn withOffset:10];
    [shareWayNameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shareWayNameLabel autoSetDimensionsToSize:CGSizeMake(70, 30)];
}

@end
