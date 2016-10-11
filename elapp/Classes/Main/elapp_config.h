//
//  elapp_config.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#ifndef elapp_config_h
#define elapp_config_h

///////////////////////////////////// 服务器地址 //////////////////////////////////////
#error FIXME: Need to change to yours
#define CCURL_RELEASE                       @"http://"
#define CCURL_HTTPS_RELEASE                 @"http://"
#define CCURL_STATTE_RELEASE                @"release"

#define CCURL_DEV                           @"https://"
#define CCURL_HTTPS_DEV                     @"https://"
#define CCURL_STATTE_DEV                    @"dev"
/////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// 第三方key //////////////////////////////////////
//----------------------------------- 极光推送 ----------------------------------//
#error FIXME: Need to change to yours
#define J_PUSH_APP_KEY                      @""
#define J_PUSH_APP_CHANNEL                  @"App Store"
//----------------------------------- 环信推送 ----------------------------------//
#error FIXME: Need to change to yours
#define EASEMOBAPP_KEY_RELEASE              @""
#define EASEMOBAPP_KEY_DEV                  @""
#define EASEMOBAPP_CER_RELEASE              @""
#define EASEMOBAPP_CER_DEV                  @""
//----------------------------------- BUGLY崩溃上报 -----------------------------//
#error FIXME: Need to change to yours
#define BUGLY_APP_ID                        @""
//----------------------------------- 友盟数据统计 -------------------------------//
#error FIXME: Need to change to yours
#define UMENG_APP_KEY                       @""
//----------------------------------- 阿里百川反馈 -------------------------------//
#error FIXME: Need to change to yours
#define ALI_FEEDBACK_APP_KEY                @""
//----------------------------------- 微博 -------------------------------------//
#error FIXME: Need to change to yours
#define WEIBO_APP_KEY                       @""
//----------------------------------- QQ --------------------------------------//
#error FIXME: Need to change to yours
#define QQ_APP_ID                           @""
//----------------------------------- 微信 -------------------------------------//
#error FIXME: Need to change to yours
#define WEIXIN_APP_KEY                      @""
#define WEIXIN_SECRET_KEY                   @""
//----------------------------------- 易视云服务 --------------------------------//

/////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// APP 状态 //////////////////////////////////////
// 开发状态
#define STATE_DEV

// 发布状态
//#define STATE_RELEASE


// 手动切换服务器
// #define STARTE_SWITCH_SERVER_MANUAL
/////////////////////////////////////////////////////////////////////////////////////


// 易视云服务 开发线上区分
#ifdef STATE_RELEASE
#error FIXME: Need to change to yours
#define EV_APP_KEY                          @""
#define EV_ACCESS_KEY                       @""
#endif

#ifdef STATE_DEV
#error FIXME: Need to change to yours
#define EV_APP_KEY                          @""
#define EV_ACCESS_KEY                       @""
#endif

#error FIXME: Need to change to yours
#define EV_SECRET_KEY                       @""

// 开启日志全局开关e
#ifdef STATE_DEV
 #define CCDEBUG
#endif

// 友盟事件开关
#ifdef STATE_RELEASE
#define CCMOBCLICK
#define CCBugly_tag
#endif

// 环信推送 appkey
#ifdef STATE_RELEASE
#define EaseMobAPPKey                       EASEMOBAPP_KEY_RELEASE
#endif

#ifdef STATE_DEV
#define EaseMobAPPKey                       EASEMOBAPP_KEY_DEV
#endif

#ifdef STARTE_SWITCH_SERVER_MANUAL
#define EaseMobAPPKey                       EASEMOBAPP_KEY_DEV
#endif

// 环信证书名字
#ifdef STATE_RELEASE
#define EaseMobCerName                      EASEMOBAPP_CER_RELEASE
#endif

#ifdef STATE_DEV
#define EaseMobCerName                      EASEMOBAPP_CER_DEV
#endif

#ifdef STARTE_SWITCH_SERVER_MANUAL
#define EaseMobCerName                      EASEMOBAPP_CER_DEV
#endif

// 环信消息通讯是否加密
#define MESSAGE_Encrypt YES

// 服务器地址
#ifdef STATE_RELEASE
#define CCVideoBaseURL                          CCURL_RELEASE
#define CCVideoBaseHTTPSURL                     CCURL_HTTPS_RELEASE
#define CCAppState                              CCURL_STATTE_RELEASE
#endif

#ifdef STATE_DEV
#define CCAppState                              CCURL_STATTE_DEV
#define CCVideoBaseHTTPSURL                     CCURL_HTTPS_DEV
#define CCVideoBaseURL                          CCURL_DEV
#endif

#ifdef STARTE_SWITCH_SERVER_MANUAL
#define CCVideoBaseURL                          [[CCAppSetting shareInstance] serverURLString]
#define CCAppState                              [[CCAppSetting shareInstance] serverAGENT]
#define CCVideoBaseHTTPSURL                     [[CCAppSetting shareInstance] httpsServerUrlString]
#endif

// 全局log
#ifdef CCDEBUG
#define CCLog(...) NSLog(__VA_ARGS__)
#else
#define CCLog(...)
#endif


#endif
