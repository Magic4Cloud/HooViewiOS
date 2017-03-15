//
//  EVNewsCollectTableViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsCollectTableViewCell.h"



@interface EVNewsCollectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchLabel;

@end


@implementation EVNewsCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
