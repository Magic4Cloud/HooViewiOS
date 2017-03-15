//
//  EVUserVideoModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"
#import "EVEnums.h"

@interface EVUserVideoModel : EVBaseObject

/** 视频 ID */
@property (copy, nonatomic) NSString *vid;

/** 视频的 title */
@property (copy, nonatomic) NSString *title;

/** 音频直播背景图 */
@property (nonatomic,copy) NSString *bgpic;

/** 视频截图的 URL */
@property (copy, nonatomic) NSString *thumb;

/** 云播号 */
@property (copy, nonatomic) NSString *username;

/** 昵称 */
@property (copy, nonatomic) NSString *nickname;

/** 视频是否是直播 0:录播 1:直播*/
@property (assign, nonatomic) NSInteger living;

/** 总观看数 */
@property (assign, nonatomic) NSUInteger watch_count;

/** 点赞数 */
@property (assign, nonatomic) NSUInteger like_count;

/** 评论数 */
@property (assign, nonatomic) NSUInteger comment_count;

/** 正在观看的人数 */
@property (strong, nonatomic) NSNumber *watching_count;

/** 直播开始时刻 */
@property (copy, nonatomic) NSString *live_start_time;

/** 直播结束时刻 */
@property (copy, nonatomic) NSString *live_stop_time;

/** 直播开始距离现在的时长（以秒为单位） */
@property (assign, nonatomic) NSUInteger live_start_time_span;

/** 直播开始距离现在的时长（以秒为单位） */
@property (assign, nonatomic) NSUInteger live_stop_time_span;

/** 直播时的地理经度 */
@property (assign, nonatomic) CGFloat gps_latitude;

/** 直播时的地理纬度 */
@property (assign, nonatomic) CGFloat gps_longitude;

/** 直播时的地理位置 */
@property (copy, nonatomic) NSString *location;

/** 视频是否公开了地理位置信息 0:未公开 1:公开 */
@property (strong, nonatomic) NSNumber *gps;

/** 直播者与登录用户距离 */
@property (assign, nonatomic) CGFloat distance;

/** 视频权限信息，即公开程度 */
@property (assign, nonatomic) EVLivePermission permission;
/** 当前视频的分享 URL 路径 */
@property (copy, nonatomic) NSString *share_url;

/** 当前视频缩略图的分享 URL 路径 */
@property (copy, nonatomic) NSString *share_thumb_url;

/** 用户的备注信息，主要用于备注用户的姓名 */
@property (copy, nonatomic) NSString *remarks;

@property (assign, nonatomic) NSUInteger duration; /**< 视频时长 */
@property (copy, nonatomic) NSString *living_device;  /**< 视频直播设备，android/ios/unknown */
@property (copy, nonatomic) NSString *network_type;  /**< 视频直播的网络类型，2G/3G/4G/wifi/other */

@property (assign, nonatomic) NSInteger mode; /**< 音视频模式，1为音频，0为视频，int */

/** 视频播放地址 */
@property (nonatomic,copy) NSString *play_url;

@property (copy, nonatomic) NSString *password;  /**< 如果是自己的，并且permission为6，则表示视频的密码，否则不存在 */

/** 视频的话题id */
@property (nonatomic, assign) NSInteger topic_id;

@property (nonatomic, assign) NSInteger status;

@end
