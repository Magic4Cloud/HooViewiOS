//
//  EVLikeOrNotCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLikeOrNotCell.h"

@implementation EVLikeOrNotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _likeButton.layer.cornerRadius = 4;
    _likeButton.layer.borderWidth = 1;
    _likeButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    _likeButton.layer.masksToBounds = YES;
    
    _notLikeButton.layer.cornerRadius = 4;
    _notLikeButton.layer.borderWidth = 1;
    _notLikeButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    _notLikeButton.layer.masksToBounds = YES;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
