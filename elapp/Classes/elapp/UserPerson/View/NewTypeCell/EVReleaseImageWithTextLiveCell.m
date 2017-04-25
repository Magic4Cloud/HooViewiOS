//
//  EVReleaseImageWithTextLiveCell.m
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVReleaseImageWithTextLiveCell.h"

@implementation EVReleaseImageWithTextLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)setUserModel:(EVUserModel *)userModel {
    if (!userModel) {
        return;
    }
    _userModel = userModel;
    _namelabel.text = userModel.name;
    _followNumberLabel.text = [NSString stringWithFormat:@"%ld人参与",userModel.viewcount];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
