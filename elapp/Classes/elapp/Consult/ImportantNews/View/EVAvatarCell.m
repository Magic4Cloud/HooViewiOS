//
//  EVAvatarCell.m
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVAvatarCell.h"

@implementation EVAvatarCell

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
