//
//  EVHVVideoCoverView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVVideoCoverView.h"

@interface EVHVVideoCoverView ()


@property (nonatomic, weak) UIButton *coverBtn;


@property (nonatomic, strong) NSLayoutConstraint *widLayout;
@property (nonatomic, strong) NSLayoutConstraint *higLayout;
@property (nonatomic, strong) NSLayoutConstraint *xLayout;
@end


@implementation EVHVVideoCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor evTextColorH1];
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    self.coverBtn = button;
    button.titleLabel.font = [UIFont systemFontOfSize:16.];
    [button setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    self.widLayout = [button autoSetDimension:ALDimensionWidth toSize:207];
    self.higLayout = [button autoSetDimension:ALDimensionHeight toSize:60];
    self.xLayout =   [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    button.userInteractionEnabled = NO;
    [button setImage:[UIImage imageNamed:@"ic_gray_logo_live"] forState:(UIControlStateNormal)];
    [button setTitle:@"大v忙着诊股\n去看看其他直播吧" forState:(UIControlStateNormal)];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setTopImage:(UIImage *)topImage
{
    _topImage = topImage;
    [self.coverBtn setImage:topImage forState:(UIControlStateNormal)];
//    self.widLayout.constant = 16;
    self.higLayout.constant = 25;
//    self.xLayout.constant = - 50;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    [self.coverBtn setTitle:titleStr forState:(UIControlStateNormal)];
}

@end
