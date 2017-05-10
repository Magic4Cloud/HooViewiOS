//
//  EVNewsAuthorsCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsAuthorsCell.h"

@implementation EVNewsAuthorsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _authorBackView.layer.cornerRadius = 4;
    _authorImage.image = [UIImage imageNamed:@"Account_bitmap_user"];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
