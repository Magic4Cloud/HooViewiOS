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
    self.lineLabel = lineLabel;
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
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 22)];
    
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [self addSubview:priceLabel];
    priceLabel.font = [UIFont topBarBigFont];
    self.priceLabel = priceLabel;
    self.priceLabel.textColor = [UIColor evAssistColor];
    [priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [priceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [priceLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 30)];
    
    
    UILabel *upLabel = [[UILabel alloc] init];
    [self addSubview:upLabel];
    upLabel.font = [UIFont textFontB4];
    self.upLabel = upLabel;
    upLabel.textColor = [UIColor evAssistColor];
    [upLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [upLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [upLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth/3, 22)];
    
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockMarketModel
{
    _stockBaseModel = stockMarketModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",stockMarketModel.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",stockMarketModel.close] ;

    float priceFloat =  stockMarketModel.close  - [stockMarketModel.open floatValue];
    
    NSString *floatStr;
    if (stockMarketModel.changepercent > 0) {
        floatStr = [NSString stringWithFormat:@"%.2f[%.2f%%]",priceFloat,stockMarketModel.changepercent];
      self.priceLabel.textColor = self.upLabel.textColor = self.nameLabel.textColor = [UIColor evAssistColor];
    }
    else
    {
        floatStr = [NSString stringWithFormat:@"%.2f[%.2f%%]",priceFloat,stockMarketModel.changepercent];
        self.priceLabel.textColor = self.upLabel.textColor = self.nameLabel.textColor = [UIColor evSecondColor];
    }
    
    self.upLabel.text = floatStr;
    
}

@end
