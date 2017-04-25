//
//  EVNormalPersonCenterController.h
//  elapp
//
//  Created by 周恒 on 2017/4/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVVipDetailCenterView.h"
#import "EVWatchVideoInfo.h"


@interface EVNormalPersonCenterController : UIViewController
@property (nonatomic, strong) EVVipDetailCenterView *vipCenterView;
@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, assign) BOOL isFollow;

@end
