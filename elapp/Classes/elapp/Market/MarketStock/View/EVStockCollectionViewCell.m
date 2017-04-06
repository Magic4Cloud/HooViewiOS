//
//  EVStockCollectionViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockCollectionViewCell.h"
#import "EVStockBaseButton.h"

#define NS_CELL_BUTTON_TAG       500

@interface EVStockCollectionViewCell ()
@property (nonatomic, weak) UILabel *topNameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *floatLabel;
@property (nonatomic, weak) UIView  *backView;
@end

@implementation EVStockCollectionViewCell

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
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor evMainColor];
    backView.frame = CGRectMake(5, 16, (ScreenWidth-30)/3, 74);
    [self addSubview:backView];
    self.backView = backView;
    
    self.backView.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 3;//阴影半径，默认3
    
    float backViewWidth = backView.frame.size.width;
    
//    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4.f;
    UILabel *topNameLabel = [[UILabel alloc] init];
    topNameLabel.frame = CGRectMake(10, 19, backViewWidth -10, 22);
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
    self.backView.backgroundColor = stockBaseModel.changepercent  > 0? [UIColor evAssistColor] : [UIColor evSecondColor];
    self.backView.layer.shadowColor = stockBaseModel.changepercent  > 0 ? [UIColor colorWithHexString:@"#B42424"].CGColor : [UIColor colorWithHexString:@"#508F28"].CGColor;//shadowColor阴影颜色
    
    self.topNameLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",stockBaseModel.close];
    NSString *floatMarked = @"%";
    NSString *addStr = @"+";
    float priceFloat =  (stockBaseModel.close- [stockBaseModel.preclose floatValue]);
    NSString *floatStr = stockBaseModel.changepercent > 0 ? [NSString stringWithFormat:@"%@%.2f[%@%.2f%@]",addStr,priceFloat,addStr,stockBaseModel.changepercent,floatMarked] : [NSString stringWithFormat:@"%.2f[%.2f%@]",priceFloat,stockBaseModel.changepercent,floatMarked];
    self.floatLabel.text = [NSString stringWithFormat:@"%@",floatStr];
}

- (void)updateCellItems:(NSInteger)items
{
//    for (UIView* subView in self.subviews) {
//        //do something ...
//        [subView removeFromSuperview];
//    }
//    for (NSInteger i = 0; i < items; i++) {
//        EVStockBaseButton *stockButton = [[EVStockBaseButton alloc] initWithFrame:CGRectMake((i * ScreenWidth/3)+5, 0, (ScreenWidth-30)/3, 74)];
//        stockButton.backgroundColor = [UIColor evAssistColor];
//        stockButton.tag = 500 + i;
//        [self addSubview:stockButton];
//    }
}


//- (void)setDataArray:(NSMutableArray *)dataArray
//{
//    _dataArray = dataArray;
//
//    for (NSInteger i = 0 ; i < dataArray.count;   i++) {
//       EVStockBaseButton *stockBase =  (EVStockBaseButton *)[self viewWithTag:i+500];
//        stockBase.stockBaseModel = dataArray[i];
//        
//    }
//    
//}



@end
