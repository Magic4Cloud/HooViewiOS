//
//  EVShopLiveCell.m
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVShopLiveCell.h"
#import "EVVideoAndLiveModel.h"

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
    _cellTitleLabel.text = liveModel.title;
    [NSString stringWithFormat:@"%@  %@",liveModel.nickname,liveModel.nickname];
    _cellDetailLabel.text = liveModel.nickname;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
