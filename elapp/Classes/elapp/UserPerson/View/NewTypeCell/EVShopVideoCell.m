//
//  EVShopVideoCell.m
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopVideoCell.h"
#import "EVVideoAndLiveModel.h"
@implementation EVShopVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellAvataerImageView.layer.cornerRadius = 11;
    _cellAvataerImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setVideoModel:(EVVideoAndLiveModel *)videoModel
{
    if (!videoModel) {
        return;
    }
    _videoModel = videoModel;
    _cellNameLabel.text = videoModel.nickname;
    [_cellAvataerImageView cc_setImageWithURLString:videoModel.logourl placeholderImage:nil];
    [_cellCoverImageView cc_setImageWithURLString:videoModel.thumb placeholderImage:nil];
    _cellDateLabel.text = [videoModel.live_start_time timeFormatter2];
    _cellDurationLabel.text = [videoModel.duration durationSeconsToHourAndMinute];
    
    _cellViewCountLabel.text = [NSString stringWithFormat:@"%@人观看",[videoModel.watch_count thousandsSeparatorString]];
    
    _cellIntroduceLabel.text = videoModel.title;
    if ([videoModel.permission integerValue] == 7) {
        _needPayLabel.hidden = NO;
    } else {
        _needPayLabel.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
