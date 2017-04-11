//
//  EVAvatarCell.m
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVAvatarCell.h"
#import "EVRecommendModel.h"
@implementation EVAvatarCell
- (void)setRecommendModel:(EVRecommendModel *)recommendModel
{
    _recommendModel = recommendModel;
    [_cellImageView cc_setImageWithURLString:recommendModel.avatar placeholderImage:nil];
    _cellNameLabel.text = recommendModel.nickname;
    _cellFollowLabel.text = recommendModel.fellow;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _cellBgView.layer.cornerRadius = 5;
    _cellBgView.layer.masksToBounds = YES;
    _cellImageView.layer.cornerRadius = 40;
    _cellImageView.layer.masksToBounds = YES;
    _cellImageView.backgroundColor = [UIColor evLineColor];
    // Initialization code
}

@end
