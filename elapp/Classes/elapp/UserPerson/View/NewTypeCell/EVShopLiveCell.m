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
    
    UIView * coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_cellImageView insertSubview:coverView atIndex:0];
    [coverView autoPinEdgesToSuperviewEdges];
    
    if (ScreenWidth == 320) {
        _cellDetailLabel.font = [UIFont systemFontOfSize:_cellDetailLabel.font.pointSize-2];
        _cellTitleLabel.font = [UIFont systemFontOfSize:_cellTitleLabel.font.pointSize-1];
        _cellViewCountLabel.font = [UIFont systemFontOfSize:_cellViewCountLabel.font.pointSize-1];
        [_cellImageView removeConstraint:_cellImageViewheightWidth];
        CGFloat multiplier = 110.0/67.f;
        NSLayoutConstraint * widthHeightScale = [NSLayoutConstraint constraintWithItem:_cellImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellImageView attribute:NSLayoutAttributeHeight multiplier:multiplier constant:0];
        [_cellImageView addConstraint:widthHeightScale];
        
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
    
    
    
    

    _cellViewCountLabel.text = [NSString stringWithFormat:@"%@人观看",[liveModel.watch_count thousandsSeparatorString]];

    
    if ([liveModel.living boolValue]) {
        _cellTag1Button.backgroundColor = [UIColor evOrangeBgColor];
        
        [_cellTag1Button setTitle:@"直播中" forState:UIControlStateNormal];
        _cellDetailLabel.text = [NSString stringWithFormat:@"%@",liveModel.nickname];
    }
    else
    {
        _cellTag1Button.backgroundColor = [UIColor evBackGroundDeepGrayColor];
        [_cellTag1Button setTitle:@"回放" forState:UIControlStateNormal];
        _cellDetailLabel.text = [NSString stringWithFormat:@"%@  %@",liveModel.nickname,[liveModel.live_start_time timeFormatter]];
    }
    if ([liveModel.mode integerValue] == 2) {
        //精品视频
        [_cellTag1Button setTitle:@"精品" forState:UIControlStateNormal];
        _cellTag1Button.backgroundColor = [UIColor evBackGroundDeepRedColor];
    }
    if ([liveModel.permission integerValue] == 7) {
        //付费
        _cellTag2Button.hidden = NO;
    }
    else
    {
        _cellTag2Button.hidden = YES;
    }
    
    if (liveModel.isHot) {
        _cellHotImageView.hidden = NO;
        _cellViewCountLeadingConstant.constant = 120;
    }
    else
    {
        _cellHotImageView.hidden = YES;
        _cellViewCountLeadingConstant.constant = 8;
    }

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
    _cellViewCountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)watchModel.watch_count];
//    _cellTagLabel.text = watchModel.living_status;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
