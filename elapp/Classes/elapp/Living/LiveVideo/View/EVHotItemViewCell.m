//
//  EVHotItemViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHotItemViewCell.h"

@interface EVHotItemViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation EVHotItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
}

@end
