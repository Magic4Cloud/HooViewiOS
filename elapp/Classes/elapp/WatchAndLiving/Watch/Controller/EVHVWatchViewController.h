//
//  EVHVWatchViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"
#import "EVWatchVideoInfo.h"
#import "EVVideoAndLiveModel.h"

/**
 视频直播详情页
 */
@interface EVHVWatchViewController : EVViewController

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

/**
 新版model
 */
@property (nonatomic, strong) EVVideoAndLiveModel * videoAndLiveModel;

@property (nonatomic, copy) void(^paidSuccessCallbackBlock)();
@end
