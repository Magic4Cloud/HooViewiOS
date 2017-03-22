//
//  EVVipCenterViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVHVVipCenterView.h"

/**
 个人主页
 */
@interface EVVipCenterViewController : UIViewController

@property (nonatomic, strong) EVHVVipCenterView *vipCenterView;

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, assign) BOOL isFollow;

@end
