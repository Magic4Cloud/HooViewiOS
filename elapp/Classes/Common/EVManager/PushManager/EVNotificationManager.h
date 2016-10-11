//
//  EVNotificationManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GPSingleTon.h"

@interface EVLocalNotification : NSObject

/** 出发时间,默认为立刻出发 */
@property (nonatomic, strong) NSDate *fireDate;
/** 启动图片名称,如果不指定默认为程序启动图片 */
@property (nonatomic, copy) NSString *alertLaunchImage;
/** 默认为 UILocalNotificationDefaultSoundName */
@property (nonatomic, retain) NSString *soundName;
/** 默认为0 */
@property (nonatomic, assign) NSInteger applicationIconBadgeNumber;
/** 额外的信息默认为空 */
@property (nonatomic, strong) NSDictionary *userInfo;
/** 锁屏状态下通知的文字*/
@property (nonatomic, copy) NSString *alertAction;
/** 提示信息 */
@property (nonatomic, copy) NSString *alertBody;

- (instancetype)initWithAlertBody:(NSString *)alertBody AlertAction:(NSString *)alertAction;
+ (instancetype)localNotificationWithAlertBody:(NSString *)alertBody AlertAction:(NSString *)alertAction;
/** 获取本地直播信息 */
- (UILocalNotification *)localNotification;
@end


@interface EVNotificationManager : NSObject<NSCopying>

singtonInterface(NotificationManager)

// @property (nonatomic, assign) NSInteger unReadMessageCount;

/** 对于 iOS 8.0以上的系统需要在 以下方法中授权
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 */
- (void)registForLocalNotificationFor_iOS8;

/** 发送一条本地通知 */
- (void)performLocalNotification:(EVLocalNotification *)notification;

//- (void)addApplicationBadgeNumber;
//
//- (void)reduceApplicationBadgeNumber;

@end
