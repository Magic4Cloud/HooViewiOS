//
//  EVHVStockTextView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVStockTextView.h"

@interface EVHVStockTextView ()


@property (nonatomic, weak) UIButton *searchBtn;
@end


@implementation EVHVStockTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
    }
    return self;
}


- (void)addUpViewFrame:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor evLineColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lineView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
    
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    contentView.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
    contentView.layer.borderWidth = 1.f;
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [contentView autoSetDimension:ALDimensionHeight toSize:40];
    
    UITextField *stockTextFiled = [[UITextField alloc] init];
    [self addSubview:stockTextFiled];
    self.stockTextFiled = stockTextFiled;
    [stockTextFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
    [stockTextFiled autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [stockTextFiled autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 20, 24)];
    stockTextFiled.placeholder = @"请输入股票代码/简称";
    stockTextFiled.font = [UIFont textFontB2];
    stockTextFiled.textColor = [UIColor evTextColorH1];
    
//    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [contentView addSubview:searchBtn];
//    searchBtn.backgroundColor = [UIColor whiteColor];
//    self.searchBtn = searchBtn;
//    [searchBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [searchBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [searchBtn autoSetDimensionsToSize:CGSizeMake(54, 40)];
//    [searchBtn setImage:[UIImage imageNamed:@"btn_market_search_n"] forState:(UIControlStateNormal)];
//    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    UIView *hLineView = [[UIView alloc]init];
//    [searchBtn addSubview:hLineView];
//    [hLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [hLineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [hLineView autoSetDimensionsToSize:CGSizeMake(2, 32)];
//    hLineView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    
                        
}

- (void)searchClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButton)]) {
        [self.delegate searchButton];
    }
    
}
@end
