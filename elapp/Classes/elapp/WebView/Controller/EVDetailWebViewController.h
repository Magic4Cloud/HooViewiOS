//
//  EVDetailWebViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

@interface EVDetailWebViewController : EVViewController

/** 必填参数 */
@property (nonatomic,copy) NSString *url;               /**< h5地址*/
@property (nonatomic,copy) NSString *activityTitle;     /**< 活动标题 */
@property (nonatomic,strong) UIImage *image;            /**< 活动封面图 */
@property (nonatomic, copy) NSString *imageStr;         /**< 活动封面链接 */
@property (nonatomic, assign) BOOL isEnd;               /**< 活动是否已经结束，结束的视频不能被分享 */
@property (nonatomic, copy) NSString *activityId;       /**< 活动id */
@property (nonatomic,copy) NSString *shareurl;          /**< 用于普通活动中投票 */

+ (instancetype)activityDetailWebViewControllerWithURL:(NSString *)url;

/**
 *  @author shizhiang, 16-01-08 16:01:29
 *
 *  h5的活动详情页开始直播
 */
- (void)startLiveWithActivityId:(NSString *)activityId;

@end
