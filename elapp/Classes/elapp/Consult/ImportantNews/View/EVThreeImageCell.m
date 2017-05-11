//
//  EVThreeImageCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVThreeImageCell.h"
#import "EVNewsModel.h"
@implementation EVThreeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setNewsModel:(EVNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    _cellDateLabel.text = newsModel.time;
    
    _cellDateLabel.text = newsModel.time;
    
    _cellTitleLabel.text = newsModel.title;
    _cellTitleLabel.textColor = newsModel.haveRead?[UIColor evBackGroundDeepGrayColor] : [UIColor blackColor];
    _cellViewCountLabel.text = [newsModel.viewCount thousandsSeparatorStringNoMillion];
    
    [_cellImageView1 cc_setImageWithURLString:newsModel.cover[0] placeholderImage:nil];
    [_cellImageView2 cc_setImageWithURLString:newsModel.cover[1] placeholderImage:nil];
    [_cellImageView3 cc_setImageWithURLString:newsModel.cover[2] placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
