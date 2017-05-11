//
//  EVOnlyTextCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVOnlyTextCell.h"
#import "EVNewsModel.h"
@implementation EVOnlyTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setNewsModel:(EVNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    _cellDateLabel.text = newsModel.time;
    _cellContentLabel.text = newsModel.title;
    _cellContentLabel.textColor = newsModel.haveRead?[UIColor evBackGroundDeepGrayColor] : [UIColor blackColor];
    _cellViewCountLabel.text = [newsModel.viewCount thousandsSeparatorString];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
