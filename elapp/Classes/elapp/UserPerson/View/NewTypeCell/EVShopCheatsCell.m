//
//  EVShopCheatsCell.m
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopCheatsCell.h"
#import "EVCheatsModel.h"
@implementation EVShopCheatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor evBackGroundLightGrayColor];
}

- (void)setCheatsModel:(EVCheatsModel *)cheatsModel
{
    if (!cheatsModel) {
        return;
    }
    _cheatsModel = cheatsModel;
    _cellDateLabel.text = [cheatsModel.date timeFormatter3];
    _cellBeansLabel.text = [NSString stringWithFormat:@"%@",cheatsModel.price];
    _cellTitleLabel.text = cheatsModel.title;
    _cellDetailLabel.text = cheatsModel.introduce;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
