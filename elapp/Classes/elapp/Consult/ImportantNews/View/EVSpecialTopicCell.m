//
//  EVSpecialTopicCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVSpecialTopicCell.h"
#import "EVNewsModel.h"
@implementation EVSpecialTopicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _cellTitleLabel.numberOfLines = 2;
    UIView * coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [_cellBgimageView addSubview:coverView];
    [coverView autoPinEdgesToSuperviewEdges];
}

- (void)setSpeciaModel:(EVNewsModel *)speciaModel
{
    _speciaModel = speciaModel;
    _cellTitleLabel.text = speciaModel.title;
    if (speciaModel.cover && speciaModel.cover.count>0) {
        if (![speciaModel.cover[0] isEqual:[NSNull null]]) {
            [_cellBgimageView cc_setImageWithURLString:speciaModel.cover[0] placeholderImage:nil];
        }
    }
    _cellViewCountLabel.text = speciaModel.viewCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
