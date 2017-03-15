//
//  EVEditTableViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVEditTableViewCell.h"

@interface EVEditTableViewCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *codeLabel;
@property (nonatomic, weak) UIButton *deleteBtn;


@end

@implementation EVEditTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(24, 10, ScreenWidth/2, 22);
    nameLabel.font = [UIFont textFontB2];
    [self addSubview:nameLabel];
    nameLabel.textColor = [UIColor evTextColorH1];
    self.nameLabel = nameLabel;
    
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.frame = CGRectMake(24, CGRectGetMaxY(nameLabel.frame), ScreenWidth/2, 20);
    codeLabel.font = [UIFont textFontB3];
    [self addSubview:codeLabel];
    codeLabel.textColor = [UIColor evTextColorH2];
    self.codeLabel = codeLabel;
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [self addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    [deleteBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:24];
    [deleteBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [deleteBtn autoSetDimensionsToSize:CGSizeMake(22, 22)];
    [deleteBtn setImage:[UIImage imageNamed:@"hv_delete"] forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.name];
    self.codeLabel.text = [NSString stringWithFormat:@"%@",stockBaseModel.symbol];
}
- (void)deleteClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTableCell:model:)]) {
        [self.delegate deleteTableCell:self model:self.stockBaseModel];
    }
}
@end
