//
//  EVCSStockButton.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVCSStockButton.h"


@interface EVCSStockButton ()




@end


@implementation EVCSStockButton

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
    UILabel *lineLabel = [[UILabel alloc] init];
    [self addSubview:lineLabel];
    [lineLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [lineLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lineLabel autoSetDimensionsToSize:CGSizeMake(1, 49)];
    lineLabel.backgroundColor = [UIColor evLineColor];

    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor evAssistColor];
    nameLabel.font = [UIFont textFontB3];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 22)];
    
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [self addSubview:priceLabel];
    priceLabel.font = [UIFont topBarBigFont];
    self.priceLabel = priceLabel;
    self.priceLabel.textColor = [UIColor evAssistColor];
    [priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [priceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [priceLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 30)];
    
    
    UILabel *upLabel = [[UILabel alloc] init];
    [self addSubview:upLabel];
    upLabel.font = [UIFont textFontB3];
    self.upLabel = upLabel;
    upLabel.textColor = [UIColor evAssistColor];
    [upLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [upLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [upLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 22)];
    
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",stockBaseModel.close];
    NSString *floatMarked = @"%";
    NSString *addStr = @"+";
    float priceFloat =  (stockBaseModel.close - [stockBaseModel.preclose floatValue]);
    NSString *floatStr = stockBaseModel.changepercent > 0  ? [NSString stringWithFormat:@"%@%.2f[%@%.2f%@]",addStr,priceFloat,addStr,stockBaseModel.changepercent,floatMarked] : [NSString stringWithFormat:@"%.2f[%.2f%@]",priceFloat,stockBaseModel.changepercent,floatMarked];
    self.upLabel.text = [NSString stringWithFormat:@"%@",floatStr];
    self.nameLabel.textColor =  stockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
     self.priceLabel.textColor =  stockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
     self.upLabel.textColor =  stockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
}

@end
