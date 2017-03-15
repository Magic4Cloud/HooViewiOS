//
//  EVSearchStockViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSearchStockViewCell.h"
#import "EVLineView.h"


@interface EVSearchStockViewCell ()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *codeLabel;

@property (nonatomic, weak) UIButton *addButton;

@property (nonatomic, weak) UILabel *addLabel;

@end


@implementation EVSearchStockViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [EVLineView addCellTopDefaultLineToView:self];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.frame = CGRectMake(24, 19, ScreenWidth - 100, 22);
    nameLabel.font = [UIFont textFontB2];
    nameLabel.textColor = [UIColor evTextColorH1];
    
    
    
    UILabel *codeLabel = [[UILabel alloc] init];
    [self addSubview:codeLabel];
    self.codeLabel = codeLabel;
    codeLabel.frame = CGRectMake(24, CGRectGetMaxY(nameLabel.frame), ScreenWidth - 100, 22);
    codeLabel.font = [UIFont textFontB2];
    codeLabel.textColor = [UIColor evTextColorH2];
    
    
    
    UIButton *addButton = [[UIButton alloc] init];
    [self addSubview:addButton];
    self.addButton = addButton;
    [addButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [addButton autoSetDimensionsToSize:CGSizeMake(22, 22)];
    [addButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    [addButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [addButton setImage:[UIImage imageNamed:@"hv_normal_add_stock"] forState:(UIControlStateNormal)];
    
    
    UILabel *addLabel = [[UILabel alloc] init];
    [self addSubview:addLabel];
    self.addLabel = addLabel;
    addLabel.textAlignment = NSTextAlignmentRight;
    addLabel.textColor = [UIColor hvPurpleColor];
    addLabel.font = [UIFont textFontB2];
    addLabel.text = @"已添加";
    [addLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    [addLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [addLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClickCell:)]) {
        [self.delegate buttonClickCell:self];
    }
}

- (void)changeButtonStatus
{
    self.addButton.hidden = YES;
    self.addLabel.hidden = NO;
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.nameLabel.text = stockBaseModel.name;
    self.codeLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.symbol];
    self.addButton.hidden = NO;
    self.addLabel.hidden = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
