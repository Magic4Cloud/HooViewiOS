//
//  EVPushManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

// 接口
// http://118.192.7.107:8800/app/deviceonline?device=android&push_id=628689231303729375&channel_id=1&app_id=2&dev_token=ccc

#import <UIKit/UIKit.h>
#import "GPSingleTon.h"

#define invalid_latitude_longitude -720.0

@interface EVPushUserInfo : NSObject

/** app_id */
@property (nonatomic, copy) NSString *app_id;
/** 频道 id */
@property (nonatomic, copy) NSString *channel_id;
/** 错误信息码 */
@property (nonatomic ,assign) NSInteger error_code;
/** 请求 id */
@property (nonatomic, copy) NSString *request_id;
/** 其实就是 user_id */
@property (nonatomic, copy) NSString *push_id;
/** 设备的id */
@property (nonatomic, copy) NSString *dev_token;

@property (nonatomic,copy) NSString *devid;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)pushUserInfoWithDictionary:(NSDictionary *)dict;

@end

@interface EVPushManager : NSObject<NSCopying>

/** 服务器返回的用户信息 */
@property (nonatomic ,strong) EVPushUserInfo *userInfo;

/** 纬度 */
@property (nonatomic, assign) double latitude;
/** 经度 */
@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) void(^willPresentNotificationBlock)(NSDictionary *userInfo);
@property (nonatomic, copy) void(^didReceiveNotificationResponseBlock)(NSDictionary *userInfo);


- (BOOL)gpsAuth;

/**
 * 1.
 * 初始化推送配置, 此方法放在 (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *
 */
- (void)setUpWithOptions:(NSDictionary *)launchOptions;

/**
 // 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
 - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
 {
 //注册应用的标志
 [application registerForRemoteNotifications];
 }
 */

/**
 *  2.
 *  绑定 device_token 如果 失败 dev_token 为空
 *  在 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 *  绑定 device_token
 */
- (void)bindWithDeviceToken:(NSData *)token_data;

/**
 *  3.
 *  处理用户数据
 *  在
 *  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 */
- (void)handleWithUserInfo:(NSDictionary *)userInfo;

/** 配置当前图标上显示的气泡数，并同步到JPush服务端 */
+ (void)setCurrentBadge:(NSInteger)badge;
- (void)resetJpushBadge;
singtonInterface(PushManager);

@end
