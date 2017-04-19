//
//  EVShopLiveCell.h
//  elapp
//
//  Created by 唐超 on 4/18/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVVideoAndLiveModel;
/**
 我的购买 视频直播cell
 */
@interface EVShopLiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellHotImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTagLabel;

@property (nonatomic, strong)EVVideoAndLiveModel * liveModel;
@end
