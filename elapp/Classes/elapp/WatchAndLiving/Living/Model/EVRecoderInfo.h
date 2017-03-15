//
//  EVRecoderInfo.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"
#import "EVEnums.h"
#import "EVTopicItem.h"

@class CCForeShowItem;

// 标示当前的直播模式
typedef NS_ENUM(NSInteger, CCLiveMode)
{
    CCLiveModeVideo = 0,
    CCLiveModeAudio
};

typedef NS_ENUM(NSInteger, CCLiveVideoStatus)
{
    CCLiveVideoStatusNormal = 0,
    CCLiveVideoStatusSharing,
    CCLiveVideoStatusUnNative,
    CCliveVideoStatusStop
};

@interface EVLiveViedeoStatus : EVBaseObject

@property (nonatomic, assign) BOOL live;
@property (nonatomic, assign) CCLiveVideoStatus status;

@end

@interface EVLiveVideoInfo : EVBaseObject

@property (nonatomic, assign) NSUInteger watching_count;
@property (nonatomic, assign) NSUInteger watch_count;
@property (nonatomic, assign) NSUInteger like_count;
@property (nonatomic, assign) NSUInteger comment_count;
@property (nonatomic, copy) NSString *city;


@end

@interface EVLiveUserInfo : EVBaseObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userlogo;
@property (nonatomic, assign) BOOL is_guest;

/** 官方认证vip */
@property (nonatomic, assign) NSInteger vip;

@property (nonatomic, assign) BOOL reconnect;

@property (nonatomic, strong) EVLiveVideoInfo *video_info;

@property (nonatomic, strong) EVLiveViedeoStatus *video_status;

@property (nonatomic, strong) NSArray *watching_list;
@property (nonatomic, strong) NSArray *comments;

+ (instancetype)liveUserInfoWithJSONString:(NSString *)jsonString;

@end

@interface EVRecoderInfo : EVBaseObject

/**
 *  直播密码，只在 permission = CCLivePermissionPassWord 生效
 */
@property (nonatomic, copy) NSString *password;

/**
 *  付费直播金额，只在 permission = CCLivePermissionPay 生效
 */
@property (nonatomic, copy) NSString *payPrice;

/**
 *  用来标示是否已经请求过直播的第一个请求
 */
@property (nonatomic, assign) BOOL recordRequested;
@property (nonatomic, assign) EVLivePermission permission;

/**
 *  是否选择陪伴
 */
@property (nonatomic, assign) BOOL accompany;
// 标示摄像头是否正在切换中
@property (nonatomic, assign) BOOL totogling;

/** vid,直播重要参数 */
@property (nonatomic, copy) NSString *vid;

/** 续播背景图 */
@property (nonatomic, copy) NSString *bgpic;

@property (nonatomic, assign) int certification;


@property (nonatomic, assign) BOOL fontCamera;
@property (nonatomic, assign) BOOL lighton;
@property (nonatomic, assign) BOOL mute;

@property (nonatomic, copy) NSString *liveid;
@property (nonatomic, copy) NSString *live_url;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, assign) BOOL liveReady;                /**< 直播是否准备好 */

@property (nonatomic, assign) BOOL renderViewPrepare;
@property (nonatomic, assign) BOOL needToReconnect;
@property (nonatomic, assign) NSInteger reconnectCount;
@property (nonatomic, assign) BOOL hasConnected;
@property (nonatomic, assign) double lastReconnectTime;
@property (nonatomic, assign) BOOL reconnecting;

@property (nonatomic, copy) NSString *play_url;
@property (nonatomic, assign) BOOL userRequestStop;
@property (nonatomic, assign) BOOL callIsConnected;

@property (nonatomic, assign) BOOL startCountTime;
@property (nonatomic, assign) BOOL stopCountTime;
@property (nonatomic, assign) NSInteger currSecond;

#pragma mark - userInfo

@property (nonatomic, copy) NSString *title;
@property (assign, nonatomic) BOOL isDefaultTitle;
@property (nonatomic, strong) EVTopicItem *topic;
@property (nonatomic, assign) BOOL shareLocation;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) BOOL thumb;
@property (nonatomic, assign) CCLiveMode mode;


@property (nonatomic,assign) BOOL forceRequest;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic,strong) EVLiveUserInfo *liveUserInfo;

@property (assign, nonatomic) BOOL noCanSaveVideo; /**< 视频是否可以保存(默认可以为NO) */
@property (nonatomic, assign) long long videoLength; /**< 已经成功上传的视频时长(单位：ms) */
@property (nonatomic, assign) long long audioLength; /**< 已经成功上传的音频时长(单位：ms) */

- (NSMutableDictionary *)liveStartParams;

@end
