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
    
    NSString * followString = recommendModel.fellow;
    NSString * newstring  = [followString thousandsSeparatorString];
    
    NSMutableAttributedString * attributeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人关注",newstring]];
    
    [attributeText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor hvPurpleColor]} range:NSMakeRange(0, newstring.length)];
    _cellFollowLabel.attributedText = attributeText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellBgView.layer.cornerRadius = 5;
    _cellBgView.layer.masksToBounds = NO;
    _cellImageView.layer.cornerRadius = 40;
    _cellImageView.layer.masksToBounds = YES;
    _cellImageView.backgroundColor = [UIColor evLineColor];
    
    _cellBgView.layer.shadowColor = [UIColor blackColor].CGColor;
    _cellBgView.layer.shadowRadius = 1;
    _cellBgView.layer.shadowOpacity = 0.2;
    _cellBgView.layer.shadowOffset = CGSizeMake(1, 1);
    // Initialization code
}

@end
