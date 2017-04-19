//
//  EVShopVideoCell.h
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的购买   精品视频
 */
@interface EVShopVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellAvataerImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellViewCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellHotImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellIntroduceLabel;

@end
