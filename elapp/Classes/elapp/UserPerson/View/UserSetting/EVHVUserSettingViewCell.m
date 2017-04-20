//
//  EVHVUserSettingViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHVUserSettingViewCell.h"

@implementation EVHVUserSettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = [UIColor evTextColorH1];
    UIImageView *nextImageView = [[UIImageView alloc] init];
    [self addSubview:nextImageView];
    self.tipImageView = nextImageView;
    [nextImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:24];
    [nextImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [nextImageView autoSetDimensionsToSize:CGSizeMake(40, 40)];
    self.tipImageView.image = [UIImage imageNamed:@"btn_next_n"];
    self.tipImageView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserSettingModel:(EVUserSettingModel *)userSettingModel
{
    self.nameLabel.text = userSettingModel.nameLabel;
    switch (userSettingModel.cellType) {
        case EVSettingCellTypeImage:
            self.liveSwitch.hidden = YES;
            self.tipLabel.hidden = YES;
            self.tipImageView.hidden = NO;
            break;
        case EVSettingCellTypeLabel:
            self.liveSwitch.hidden = YES;
            self.tipLabel.hidden = NO;
            self.tipImageView.hidden = YES;
            break;
            
        case EVSettingCellTypeSwitch:
            self.liveSwitch.hidden = NO;
            self.tipLabel.hidden = YES;
            self.tipImageView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
