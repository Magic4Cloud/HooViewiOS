//
//  EVReleaseImageWithTextLiveCell.h
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUserModel.h"
#import "EVTextLiveModel.h"

@interface EVReleaseImageWithTextLiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@property (weak, nonatomic) IBOutlet UILabel *followNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (nonatomic, strong) EVUserModel *userModel;

@end
