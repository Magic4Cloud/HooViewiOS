//
//  EVShopLiveCell.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopLiveCell.h"
#import "EVVideoAndLiveModel.h"
#import "EVWatchVideoInfo.h"

@implementation EVShopLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLiveModel:(EVVideoAndLiveModel *)liveModel
{
    if (!liveModel) {
        return;
    }
    _liveModel = liveModel;
    [_cellImageView cc_setImageWithURLString:liveModel.logoUrl placeholderImage:nil];
    _cellTitleLabel.text = liveModel.title;
    [NSString stringWithFormat:@"%@  %@",liveModel.nickname,liveModel.nickname];
    _cellDetailLabel.text = liveModel.nickname;
}


- (void)setWatchModel:(EVWatchVideoInfo *)watchModel
{
    if (!watchModel) {
        return;
    }
    _watchModel = watchModel;
    [_cellImageView cc_setImageWithURLString:watchModel.thumb placeholderImage:nil];
    _cellTitleLabel.text = watchModel.title;
    [NSString stringWithFormat:@"%@  %@",watchModel.nickname,watchModel.live_start_time];
    _cellDetailLabel.text = [NSString stringWithFormat:@"%@  %@",watchModel.nickname,watchModel.live_start_time];
    _cellViewCountLabel.text = [NSString stringWithFormat:@"%ld",watchModel.watch_count];
//    _cellTagLabel.text = watchModel.living_status;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
