//
//  EVVipCenterView.h
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVUserModel.h"



@interface EVVipDetailCenterView : UIView

@property (nonatomic, strong) EVUserModel *userModel;
@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@end
