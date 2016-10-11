//
//  EVWatchViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVVideoViewController.h"
#import "EVLiveShareView.h"
#import "EVReportReasonView.h"

@class EVWatchVideoInfo;

@interface EVWatchViewController : EVVideoViewController


/**
 *  vid 必传
 *  密码直播填写 passowrd
 */
@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

/**
 *  @author gaopeirong
 *
 *  强制退出当前观看页，session过期时需要这样处理
 *
 *  @param complete 退出完成
 */
- (void)foreceToPopCurrentWatchPage:(void(^)())complete;






@end
