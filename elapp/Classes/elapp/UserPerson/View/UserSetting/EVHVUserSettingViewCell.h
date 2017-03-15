//
//  EVHVUserSettingViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUserSettingModel.h"

@interface EVHVUserSettingViewCell : UITableViewCell

@property (nonatomic, strong) EVUserSettingModel *userSettingModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UISwitch *liveSwitch;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) UIImageView *tipImageView;


@end
