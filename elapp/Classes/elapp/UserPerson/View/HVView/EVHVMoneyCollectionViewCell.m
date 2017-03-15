//
//  EVHVMoneyCollectionViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVMoneyCollectionViewCell.h"

@interface EVHVMoneyCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *douLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end


@implementation EVHVMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    
    self.backView.backgroundColor = [UIColor clearColor];
    
}

- (void)setProductInfoModel:(EVProductInfoModel *)productInfoModel
{
    _productInfoModel = productInfoModel;
    self.douLabel.text = [NSString stringWithFormat:@"%ld豆",productInfoModel.ecoin];
    NSString *money = nil;
    if ( productInfoModel.rmb % 100 )
    {
        money = [NSString stringWithFormat:@"%.2f元", productInfoModel.rmb / 100.0f];
    }
    else
    {
        money = [NSString stringWithFormat:@"%ld元", productInfoModel.rmb / 100];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",money];
    
    self.backView.backgroundColor =  productInfoModel.isSelected == YES ? [UIColor evOrangeColor] : [UIColor clearColor];
    self.backView.alpha = productInfoModel.isSelected == YES ? 0.3: 0;
    self.layer.borderColor =  productInfoModel.isSelected == YES ? [UIColor evOrangeColor].CGColor : [UIColor evGlobalSeparatorColor].CGColor;
//    self.layer.borderWidth =  productInfoModel.isSelected == YES ? 1: 0;
}

@end
