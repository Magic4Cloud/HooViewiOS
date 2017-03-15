//
//  EVHVCenterImageLiveViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVUserModel.h"


@interface EVHVCenterImageLiveViewCell : UITableViewCell

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) EVUserModel *userModel;
@end
