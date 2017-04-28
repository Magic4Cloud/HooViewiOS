//
//  EVShopLiveCell.h
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVVideoAndLiveModel;
@class EVWatchVideoInfo;
/**
 我的购买 视频直播cell
 */
@interface EVShopLiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellHotImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellTag1Button;
@property (weak, nonatomic) IBOutlet UIButton *cellTag2Button;

@property (nonatomic, strong)EVVideoAndLiveModel * liveModel;
@property (nonatomic, strong)EVWatchVideoInfo * watchModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageViewheightWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellViewCountLeadingConstant;

@end
