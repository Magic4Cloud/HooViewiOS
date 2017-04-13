//
//  EVHVWatchTextViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVHVVipCenterView.h"


/**
 别人的图文直播间
 */
@interface EVHVWatchTextViewController : UIViewController
@property (nonatomic, strong) EVHVVipCenterView *vipCenterView;

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;
@property (nonatomic, strong) EVWatchVideoInfo *liveVideoInfo;
@end
