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
    _cellTag1Label.layer.cornerRadius = 3;
    _cellTag1Label.layer.masksToBounds = YES;
    
    _cellTag2Label.layer.cornerRadius = 3;
    _cellTag2Label.layer.masksToBounds = YES;
    if (ScreenWidth == 320) {
        _cellDetailLabel.font = [UIFont systemFontOfSize:12];
    }
    
}

- (void)setLiveModel:(EVVideoAndLiveModel *)liveModel
{
    if (!liveModel) {
        return;
    }
    _liveModel = liveModel;
    [_cellImageView cc_setImageWithURLString:liveModel.thumb placeholderImage:nil];
    _cellTitleLabel.text = liveModel.title;
    
    _cellDetailLabel.text = [NSString stringWithFormat:@"%@ %@",liveModel.nickname,liveModel.live_start_time];
    
    _cellViewCountLabel.text = [NSString stringWithFormat:@"%@观看",[liveModel.watch_count thousandsSeparatorString]];
//    if (liveModel.isHot) {
//        _cellHotImageView.hidden = NO;
//        _cellViewCountLeadingConstant.constant = 120;
//    }
//    else
//    {
        _cellHotImageView.hidden = YES;
        _cellViewCountLeadingConstant.constant = 8;
//    }
    
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
