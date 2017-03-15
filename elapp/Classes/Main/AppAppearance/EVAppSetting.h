//
//  EVAppSetting.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSystemPublic.h"

typedef NS_ENUM(NSInteger, EVAppSettingVersion)
{
    EVAppSettingVersion_2_0_0,
    EVAppSettingVersion_2_0_1
};

typedef NS_ENUM(NSInteger, EVAppStyleChangeState)
{
    EVAppStyleChangeNone,
    EVAppStyleChangeAll,
    EVAppStyleChangeFontFamilyName,
    EVAppStyleChangeMainColor
};

#ifdef STARTE_SWITCH_SERVER_MANUAL
typedef NS_ENUM(NSInteger, EVAPPServerState)
{
    EVAPPServerStateDEV,
    EVAPPServerStateINNERTEST,
    EVAPPServerStateRC,
    EVAPPServerStateRELEASE
};
#endif

typedef NS_ENUM(NSInteger,EVEasyvaasAppState)
{
    EVEasyvaasAppStateDefault,           // 普通状态
    EVEasyvaasAppStateLiving             // 直播或者观看视频状态
};


#define FOLDERPATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"elapp"]




// app的版本号，例如版本号20150911
#define EVAppVersion [[EVAppSetting shareInstance] appVersion]
#define EVAppVersionCode  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define EVButtonDisableColor [UIColor mainColorAlpha:0.5]

// 加粗字体
#define EVBoldFont(fontSize) [UIFont boldSystemFontOfSize:(fontSize)]
#define EVNormalFont(fontSize) [UIFont systemFontOfSize:(fontSize)]




#define EVAppIcon [EVAppSetting shareInstance].appIcon

#define EVAppCacheFilePath [[EVAppSetting shareInstance] appCacheFilePath]


// 用于首页浮标动画
#define EVLiveHasExperienceCount            @"EVLiveHasExperienceCount"
// 用户时间
#define EVUpdateTime                @"updateforecasttime"


//一些简单的记忆功能
#define EVShareHide                        @"shareHidde"

extern NSString *const EVAppSettingVersionDidChangedNotification;
extern NSString *const EVAppSettingChangeKey;
extern NSString * const NotifyOfLogout;
extern NSString * const NotifyOfLogin;

@interface EVAppSetting : NSObject

@property (nonatomic, assign) BOOL isLogining;   //记录当前是否处于登录状态

@property (nonatomic, assign) EVAppSettingVersion version;
@property (copy, nonatomic, readonly) NSString *appVersion;
@property (nonatomic,strong, readonly) NSString *appMainColorString;
@property (nonatomic, copy) NSString *normalFontFamilyName;
@property (nonatomic, copy) NSString *blodFontFamilyName;
@property (nonatomic,strong) UIImage *appIcon;
@property (nonatomic,strong, readonly) NSString *openUUID;
@property (nonatomic,strong, readonly) UIColor *titleColor;

#ifdef STARTE_SWITCH_SERVER_MANUAL
@property (nonatomic, assign) EVAPPServerState serverState;
@property (nonatomic,copy, readonly) NSString *serverURLString;
@property (nonatomic,copy, readonly) NSString *serverAGENT;
@property (nonatomic, copy, readonly) NSString *httpsServerUrlString;
#endif
/** app状态 */
@property (nonatomic, assign) EVEasyvaasAppState appstate;


+ (instancetype)shareInstance;
/**
 *  创建 app 缓存文件夹
 */
- (void)createCacheAppFolder;

/**
 *  app 缓存文件夹路径 cache/oupai
 *
 *  @return
 */
- (NSString *)appCacheFilePath;


/**
 *  分享的默认标题
 *
 *  @param nickName
 *  @param title
 *  @param isLive
 *
 *  @return
 */
+ (NSString *)liveTitleWithNickName:(NSString *)nickName
                       CurrentTitle:(NSString *)title
                             isLive:(BOOL)isLive;

/**
 *  直播的默认标题
 *
 *  @param audioOnly
 *
 *  @return
 */
+ (NSString *)defaultLiveTitleWithMode:(BOOL)audioOnly;


- (UIFont *)normalFontWithSize:(CGFloat)size;
- (UIFont *)systemBoldFontWithSize:(CGFloat)size;
- (UIFont *) systemFontOfSize:(CGFloat)size;

+ (void)broadcastAppStyleChangeWith:(EVAppStyleChangeState)state;
+ (void)broadcastAppMainColorChage;
+ (void)broadcastAppMainFontStyleChage;

@end
