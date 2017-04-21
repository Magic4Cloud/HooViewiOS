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
    _cellTag1Button.layer.cornerRadius = 3;
    _cellTag1Button.layer.masksToBounds = YES;
    _cellTag1Button.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
    _cellTag1Button.enabled = NO;
    
    _cellTag2Button.layer.cornerRadius = 3;
    _cellTag2Button.layer.masksToBounds = YES;
    [_cellTag2Button setTitle:@"付费" forState:UIControlStateNormal];
    _cellTag2Button.enabled = NO;
    _cellTag2Button.backgroundColor = [UIColor evBackGroundDeepBlueColor];
    _cellTag2Button.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
    if (ScreenWidth == 320) {
        _cellDetailLabel.font = [UIFont systemFontOfSize:_cellDetailLabel.font.pointSize-2];
    }
    
}

- (void)setLiveModel:(EVVideoAndLiveModel *)liveModel
{
    if (!liveModel) {
        return;
    }
    _liveModel = liveModel;
    
    _cellTag2Button.hidden = YES;
    
    [_cellImageView cc_setImageWithURLString:liveModel.thumb placeholderImage:nil];
    _cellTitleLabel.text = liveModel.title;
    
    _cellDetailLabel.text = [NSString stringWithFormat:@"%@  %@",liveModel.nickname,[liveModel.live_start_time timeFormatter]];
    

    _cellViewCountLabel.text = [NSString stringWithFormat:@"%@人观看",[liveModel.watch_count thousandsSeparatorString]];

    
    if ([liveModel.living boolValue]) {
        _cellTag1Button.backgroundColor = [UIColor evOrangeBgColor];
        
        [_cellTag1Button setTitle:@"直播中" forState:UIControlStateNormal];
    }
    else
    {
        _cellTag1Button.backgroundColor = [UIColor evBackGroundDeepGrayColor];
        [_cellTag1Button setTitle:@"回放" forState:UIControlStateNormal];
        
    }
    if ([liveModel.mode integerValue] == 2) {
        //精品视频
        [_cellTag1Button setTitle:@"精品" forState:UIControlStateNormal];
        _cellTag1Button.backgroundColor = [UIColor evBackGroundDeepRedColor];
    }
    if ([liveModel.permission isEqualToString:@"PayLive"]) {
        //付费
        _cellTag2Button.hidden = NO;
    }
    
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
