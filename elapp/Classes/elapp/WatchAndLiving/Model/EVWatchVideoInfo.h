//
//  EVWatchVideoInfo.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@class EVLiveUserInfo,EVTopicItem;

typedef NS_ENUM(NSInteger, CCLiveStatus) {
    CCLivePreParing = 0,
    CCLiving,
    CCLiveEnd
};

#define CCRtmpProtocol @"rtmp"
#define CCHttProtocol @"http"
#define CCAmqpProtocol @"amqp"

#define LIVE_MODE           0
#define AUDIO_MODE          1

@interface EVWatchVideoInfo : EVBaseObject

#pragma mark - chatserver
@property (nonatomic,copy) NSString *hcs_ip;
@property (nonatomic,copy) NSString *hcs_port;
@property (nonatomic,copy) NSString *horizontal;

// MARK: 语音相关
/** 语音直播背景 id */
@property (nonatomic, assign) NSInteger bgpid;
/** 语音背景图 */
@property (nonatomic,copy) NSString *bgpic;
/** 直播模式  */
@property (nonatomic, assign) NSInteger mode;
/** 视频播放地址 ,选填 作用是用来加速播放器加载的速度 */
@property (nonatomic,copy) NSString *play_url;

/** 启动播放器的必填参数 */
@property (nonatomic,copy) NSString *vid;
//必传
@property (nonatomic,copy) NSString *uri;

@property (nonatomic, copy) NSString *live_start_time;

@property (nonatomic, assign) NSInteger status;
/**
 *  permission = 6的时候必填参数
 */
@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *name;
/** 主播环信帐号, 在获得 云播号之后才会获取调用 userInfo 来获得 环信帐号 */
@property (nonatomic,copy) NSString *imuser;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *remarks;

@property (nonatomic,assign) NSUInteger comment_count;

@property (nonatomic,assign) NSUInteger like_count;

@property (nonatomic,assign) NSUInteger watching_count;

@property (nonatomic,assign) NSUInteger watch_count;

@property (nonatomic, assign) double live_start_time_span;

@property (nonatomic, copy) NSString *signature;
/** 官方认证vip */
@property (nonatomic, assign) NSInteger vip;

@property (nonatomic, assign) NSInteger certification;

@property (nonatomic, assign) BOOL followed;

@property (nonatomic, assign) NSInteger follow_count;

@property (nonatomic, copy) NSString *logourl;   /*< 用户头像url */

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, assign) BOOL playing;

@property (nonatomic, assign) NSInteger bufferCount;

@property (nonatomic, assign) NSInteger living;

@property (nonatomic, assign) CCLiveStatus living_status;

@property (nonatomic, strong) EVTopicItem *topic;

@property (nonatomic, copy) NSString *topic_id;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, copy) NSString *host;

@property (nonatomic, assign) int port;

@property (nonatomic, copy) NSString *protocol;

@property (nonatomic, copy) NSString *watchid;

@property (nonatomic, copy) NSString *share_thumb_url; // 用于分享的图片
// 主播信息
@property (nonatomic, strong) EVLiveUserInfo *liveUserInfo;

@property (nonatomic, strong) NSArray *observerKeyPaths;
#pragma mark - 2.0.1
@property (nonatomic, assign) NSInteger currSecond;

@property (nonatomic, strong) NSArray *tags;

//新的直播间model
@property (nonatomic, assign) NSInteger roomstatus;// 1表示房间直播 0表示房间未直播

@property (nonatomic, copy) NSString *room; //房间号

//@property (nonatomic, assign) NSInteger horizontal; //是否是横屏 1是横屏 0是竖屏

@property (nonatomic, assign) NSInteger duration;

// vr 相关 (mode == 2 为 vr)
@property (assign, nonatomic) BOOL isGlassesMode; /**< 是否是双眼3D模式 */
@property (assign, nonatomic) BOOL isHandSwitchMode; /**< 是否手动转动全景 */
@property (assign, nonatomic) BOOL isClearMode; /**< 是否是清屏模式 */

//图文直播
@property (nonatomic, copy) NSString  *liveID;
@property (nonatomic, copy) NSString *ownerid;
@property (nonatomic, assign) NSInteger viewcount;
@property (nonatomic, assign) NSInteger fans_count;



@end
