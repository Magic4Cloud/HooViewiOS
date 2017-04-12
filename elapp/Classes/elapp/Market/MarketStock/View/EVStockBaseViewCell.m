//
//  EVStockBaseViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockBaseViewCell.h"
#import <PureLayout.h>


@interface EVStockBaseViewCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *codeLabel;
@property (nonatomic, weak) UILabel *changeLabel;
@property (nonatomic, weak) UILabel *changeFloatLabel;
@property (nonatomic, strong) UIImageView *flagImageViwe;
@end


@implementation EVStockBaseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(24, 10, ScreenWidth/3, 22);
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    nameLabel.textColor = [UIColor evTextColorH1];
    nameLabel.text = @"上证";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.frame = CGRectMake(24, CGRectGetMaxY(nameLabel.frame), ScreenWidth/3, 20);
    codeLabel.font = [UIFont systemFontOfSize:14.f];
    codeLabel.textColor = [UIColor evTextColorH2];
    [self addSubview:codeLabel];
    codeLabel.text = @"ZX0078";
    self.codeLabel = codeLabel;
    
    
    UILabel *changeLabel = [[UILabel alloc] init];
    changeLabel.frame = CGRectMake(154, 20, 120, 22);
    changeLabel.textAlignment = NSTextAlignmentLeft;
    changeLabel.font = [UIFont systemFontOfSize:16.f];
    changeLabel.textColor = [UIColor evTextColorH3];
    [self addSubview:changeLabel];
    changeLabel.text = @"19.89";
    self.changeLabel = changeLabel;
    
    UILabel *changeFloatLabel = [[UILabel alloc] init];
    [self addSubview:changeFloatLabel];
    changeFloatLabel.textAlignment = NSTextAlignmentCenter;
    changeFloatLabel.textColor = [UIColor evTextColorH3];
    changeFloatLabel.font = [UIFont systemFontOfSize:16.f];
    [changeFloatLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [changeFloatLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [changeFloatLabel autoSetDimensionsToSize:CGSizeMake(80, 30)];
    changeFloatLabel.text = @"+44.33%";
    self.changeFloatLabel = changeFloatLabel;
    changeFloatLabel.backgroundColor = [UIColor redColor];
    
    UILabel *rankLabel = [[UILabel alloc] init];
    [self addSubview:rankLabel];
    rankLabel.textColor = [UIColor whiteColor];
    rankLabel.font = [UIFont textFontB2];
    [rankLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [rankLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:nameLabel];
    [rankLabel autoSetDimensionsToSize:CGSizeMake(14.f, 24.f)];
    self.rankLabel = rankLabel;
    
    UIImageView *flagImageViwe = [[UIImageView alloc] init];
    flagImageViwe.frame = CGRectMake(22, 26, 18, 12);
    flagImageViwe.backgroundColor = [UIColor orangeColor];
    self.flagImageViwe = flagImageViwe;
    flagImageViwe.hidden = YES;
    [self addSubview:flagImageViwe];
    
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [self addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [lineLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:22.f];
    [lineLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.f];
    [lineLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lineLabel autoSetDimension:ALDimensionHeight toSize:1];
    lineLabel.hidden = YES;
    self.lineLabel = lineLabel;

}

- (void)setRankColor:(UIColor *)rankColor
{
    _rankColor = rankColor;
    self.rankLabel.backgroundColor = rankColor;
}

- (void)setStockBaseModel:(EVTodayFloatModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.nameLabel.text = stockBaseModel.name;
    self.codeLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.symbol];
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f",stockBaseModel.close];
    //float changeF = (([stockBaseModel.low floatValue] - [stockBaseModel.pre_close floatValue])/[stockBaseModel.pre_close floatValue])*100;
    NSString *floatMarked = @"%";
    self.changeFloatLabel.text = stockBaseModel.changepercent > 0 ? [NSString stringWithFormat:@"+%.2f%@",stockBaseModel.changepercent,floatMarked] : [NSString stringWithFormat:@"%.2f%@",stockBaseModel.changepercent,floatMarked];
    self.changeFloatLabel.textColor = stockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
     self.changeLabel.textColor = stockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
    
}

- (void)setCellType:(EVStockBaseViewCellType)cellType
{
    _cellType = cellType;
    switch (cellType) {
        case EVStockBaseViewCellTypeSock:
            _changeFloatLabel.backgroundColor = [UIColor clearColor];
            break;

        case EVStockBaseViewCellTypeSelfSock:
            _changeFloatLabel.layer.cornerRadius = 4.f;
            _changeFloatLabel.layer.masksToBounds = YES;
            break;
            
        case EVStockBaseViewCellTypeGlobalSock:
            _changeFloatLabel.backgroundColor = [UIColor clearColor];
            break;
            
        default:
            break;
    }
}

- (void)setUpStockBaseModel:(EVStockBaseModel *)upStockBaseModel
{
    //自选
    _upStockBaseModel = upStockBaseModel;
    self.nameLabel.text = upStockBaseModel.name;
    self.codeLabel.text = [NSString stringWithFormat:@"%@",upStockBaseModel.symbol];
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f",upStockBaseModel.close];
    NSString *floatMarked = @"%";
    self.changeFloatLabel.text = upStockBaseModel.changepercent > 0 ? [NSString stringWithFormat:@"+%.2f%@",upStockBaseModel.changepercent,floatMarked] : [NSString stringWithFormat:@"%.2f%@",upStockBaseModel.changepercent,floatMarked];
    self.changeFloatLabel.backgroundColor = upStockBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
    self.changeFloatLabel.textColor = [UIColor whiteColor];
    self.changeLabel.textColor = [UIColor  evTextColorH1];
}

-(void)setGlobalBaseModel:(EVStockBaseModel *)globalBaseModel
{
    //全球
    _globalBaseModel = globalBaseModel;
    self.nameLabel.frame = CGRectMake(44, 20, 130, 22);
    self.changeLabel.frame = CGRectMake(170, 20, 120, 22);
    self.codeLabel.hidden = YES;
    self.rankLabel.hidden = YES;
    self.flagImageViwe.hidden = NO;
    
    self.nameLabel.text = globalBaseModel.name;
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f",globalBaseModel.close];
    NSString *floatMarked = @"%";
    self.changeFloatLabel.text = globalBaseModel.changepercent > 0 ? [NSString stringWithFormat:@"+%.2f%@",globalBaseModel.changepercent,floatMarked] : [NSString stringWithFormat:@"%.2f%@",globalBaseModel.changepercent,floatMarked];
    self.changeFloatLabel.textColor = globalBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];
    self.changeLabel.textColor = globalBaseModel.changepercent > 0 ? [UIColor evAssistColor] : [UIColor evSecondColor];

    
}

- (void)setSearchBaseModel:(EVStockBaseModel *)searchBaseModel
{
    _searchBaseModel = searchBaseModel;
    
    self.changeLabel.hidden = YES;
    self.changeFloatLabel.hidden = YES;
    self.rankLabel.hidden = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",searchBaseModel.name];
    self.codeLabel.text = [NSString stringWithFormat:@"%@",searchBaseModel.symbol];
}
@end
