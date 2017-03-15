//
//  EVStockBaseButton.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockBaseButton.h"

@interface EVStockBaseButton ()
@property (nonatomic, weak) UILabel *topNameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *floatLabel;
@end


@implementation EVStockBaseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self addUpViewSuperFrame:frame];
    }
    return self;
}

- (void)addUpViewSuperFrame:(CGRect)frame
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    UILabel *topNameLabel = [[UILabel alloc] init];
    topNameLabel.frame = CGRectMake(10, 3, frame.size.width -10, 22);
    topNameLabel.textColor = [UIColor whiteColor];
    topNameLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:topNameLabel];
    topNameLabel.text = @"上证";
    self.topNameLabel = topNameLabel;
    
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(10, CGRectGetMaxY(topNameLabel.frame), CGRectGetWidth(topNameLabel.frame), 28);
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:priceLabel];
    priceLabel.text = @"3242.35";
    self.priceLabel = priceLabel;
    
    
    UILabel *floatLabel = [[UILabel alloc] init];
    floatLabel.frame = CGRectMake(10, CGRectGetMaxY(priceLabel.frame), CGRectGetWidth(topNameLabel.frame), 17);
    floatLabel.textColor = [UIColor whiteColor];
    floatLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:floatLabel];
    self.floatLabel = floatLabel;
    
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.backgroundColor = [stockBaseModel.open floatValue] > [stockBaseModel.preclose floatValue] ? [UIColor evAssistColor] : [UIColor evSecondColor];
    self.topNameLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.close];
    float priceFloat =  ([stockBaseModel.open floatValue] - [stockBaseModel.preclose floatValue]);
    NSString *floatStr = stockBaseModel.change > 0 ? [NSString stringWithFormat:@"+%.2f[+%.2f%]",priceFloat,stockBaseModel.change] : [NSString stringWithFormat:@"%.2f[-%.2f%]",priceFloat,stockBaseModel.change];
    self.floatLabel.text = [NSString stringWithFormat:@"%@",floatStr];
}
@end
