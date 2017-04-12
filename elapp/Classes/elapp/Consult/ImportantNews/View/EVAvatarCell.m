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
    
    long count = followString.length;
    
    NSMutableString *string = [NSMutableString stringWithString:followString];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    
    NSMutableAttributedString * attributeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人关注",newstring]];
    
    [attributeText addAttribute:NSForegroundColorAttributeName value:[UIColor hvPurpleColor] range:NSMakeRange(0, newstring.length)];
    _cellFollowLabel.attributedText = attributeText;
//    _cellFollowLabel.text = recommendModel.fellow;
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
