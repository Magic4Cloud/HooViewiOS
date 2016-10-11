//
//  CCAppSetting.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSystemPublic.h"

typedef NS_ENUM(NSInteger, CCAppSettingVersion)
{
    CCAppSettingVersion_2_0_0,
    CCAppSettingVersion_2_0_1
};

typedef NS_ENUM(NSInteger, CCAppStyleChangeState)
{
    CCAppStyleChangeNone,
    CCAppStyleChangeAll,
    CCAppStyleChangeFontFamilyName,
    CCAppStyleChangeMainColor
};

#ifdef STARTE_SWITCH_SERVER_MANUAL
typedef NS_ENUM(NSInteger, CCAPPServerState)
{
    CCAPPServerStateDEV,
    CCAPPServerStateINNERTEST,
    CCAPPServerStateRC,
    CCAPPServerStateRELEASE
};
#endif

typedef NS_ENUM(NSInteger,CCEasyvaasAppState)
{
    CCEasyvaasAppStateDefault,           // 普通状态
    CCEasyvaasAppStateLiving             // 直播或者观看视频状态
};

#define CCAppScheme @"elapp"

#define templateReviewURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID"
#define templateReviewURLiOS7 @"itms-apps://itunes.apple.com/app/idAPP_ID"
#define templateReviewURLiOS8 @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

// 系统版本号，浮点型，用于根据系统版本进行的判断
#define CCSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define FOLDERPATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"elapp"]




// app的版本号，例如版本号20150911
#define CCAppVersion [[CCAppSetting shareInstance] appVersion]
#define CCAppVersionCode  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CCAppMainColor [[CCAppSetting shareInstance] appMainColor]
#define CCBackgroundColor [[CCAppSetting shareInstance] appBgColor]
#define CCTextBlackColor [[CCAppSetting shareInstance] textBlackColor]
#define CCButtonDisableColor [UIColor colorWithHexString:kGlobalGreenColor alpha:0.5]
#define CCAppMainFont(size)   [[CCAppSetting shareInstance] normalFontWithSize:size]
// 加粗字体
#define CCBoldFont(fontSize) [UIFont boldSystemFontOfSize:(fontSize)]
#define CCNormalFont(fontSize) [UIFont systemFontOfSize:(fontSize)]
// 描边颜色
#define CCBorderCGColor ([UIColor colorWithHexString:@"#fb6655"].CGColor);
#define CCBackViewColor  [UIColor colorWithHexString:@"#fb6655"]

#define CCAppFontWithSize(size) [[CCAppSetting shareInstance] normalFontWithSize:(size)]
#define CCAppBlodFontWithSize(size) [[CCAppSetting shareInstance] blodFontWithSize:(size)]
#define CCAppIcon [CCAppSetting shareInstance].appIcon

#define CCAppCrashLogSubmitURLString [[CCAppSetting shareInstance] crashLogSubmitURLString]
#define CCAppCrashLogIdentifier [[CCAppSetting shareInstance] crashLogIndentifier]

#define CCAppCacheFilePath [[CCAppSetting shareInstance] appCacheFilePath]

// 通用返回错误信息
#define CCAPP_GLOBAL_PLACEHOLDER kE_GlobalZH(@"request_fail_again")
#define CCAPP_APPID @"917569085"

// 用于首页浮标动画
#define CCLiveHasExperienceCount            @"CCLiveHasExperienceCount"
// 用户预告时间
#define CCUpdateForecastTime                @"updateforecasttime"


//一些简单的记忆功能
#define CCShareHide                        @"shareHidde"

extern NSString *const CCAppSettingVersionDidChangedNotification;
extern NSString *const CCAppSettingChangeKey;

@interface CCAppSetting : NSObject

@property (nonatomic, assign) BOOL isLogining;   //记录当前是否处于登录状态

@property (nonatomic, assign) CCAppSettingVersion version;
@property (copy, nonatomic, readonly) NSString *appVersion;
@property (nonatomic,strong, readonly) NSString *appMainColorString;
@property (copy, nonatomic) UIColor *appMainColor;
@property (copy, nonatomic) UIColor *appBgColor;
@property (nonatomic, copy) UIColor *textBlackColor;
@property (nonatomic, copy) NSString *normalFontFamilyName;
@property (nonatomic, copy) NSString *blodFontFamilyName;
@property (nonatomic,strong) UIImage *appIcon;
@property (nonatomic,strong, readonly) NSString *openUUID;
@property (nonatomic,strong, readonly) UIColor *titleColor;

#ifdef STARTE_SWITCH_SERVER_MANUAL
@property (nonatomic, assign) CCAPPServerState serverState;
@property (nonatomic,copy, readonly) NSString *serverURLString;
@property (nonatomic,copy, readonly) NSString *serverAGENT;
@property (nonatomic, copy, readonly) NSString *httpsServerUrlString;
#endif

/** app状态 */
@property (nonatomic, assign) CCEasyvaasAppState appstate;

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

+ (instancetype)shareInstance;

- (UIFont *)normalFontWithSize:(CGFloat)size;
- (UIFont *)systemBoldFontWithSize:(CGFloat)size;
- (UIFont *) systemFontOfSize:(CGFloat)size;

+ (void)broadcastAppStyleChangeWith:(CCAppStyleChangeState)state;
+ (void)broadcastAppMainColorChage;
+ (void)broadcastAppMainFontStyleChage;

//- (NSString *)defaultLiveTitle;

@end
