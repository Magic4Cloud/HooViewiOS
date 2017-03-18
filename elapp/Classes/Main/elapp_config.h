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
#define EVURL_RELEASE                       @"http://appgw.hooview.com/easyvaas/appgw"
#define EVURL_HTTPS_RELEASE                 @"https://appgw.hooview.com/easyvaas/appgw"
#define EVURL_STATTE_RELEASE                @"release"

#define EVURL_DEV                           @"http://dev.yizhibo.tv/hooview/appgw"
#define EVURL_HTTPS_DEV                     @"http://dev.yizhibo.tv/hooview/appgw"
#define EVURL_STATTE_DEV                    @"dev"
/////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// 第三方key //////////////////////////////////////
//----------------------------------- 极光推送 ----------------------------------//
#define J_PUSH_APP_KEY                      @"4c4d83df3f8d7af82900182c"
#define J_PUSH_APP_CHANNEL                  @"App Store"
//----------------------------------- 环信推送 ----------------------------------//
#define EASEMOBAPP_KEY_RELEASE              @"1150160929178497#hooview"
#define EASEMOBAPP_KEY_DEV                  @"cloudfocus#elapp"
#define EASEMOBAPP_CER_RELEASE              @"online_push_service_private"
#define EASEMOBAPP_CER_DEV                  @"dev_push_service_private"
//----------------------------------- BUGLY崩溃上报 -----------------------------//
#define BUGLY_APP_ID                        @"07e49351e9"
//----------------------------------- 友盟数据统计 -------------------------------//
#define UMENG_APP_KEY                       @"5881698d07fe656834000505"
//----------------------------------- 阿里百川反馈 -------------------------------//
#define ALI_FEEDBACK_APP_KEY                @"23468184"
//----------------------------------- 微博 -------------------------------------//
#define WEIBO_APP_KEY                       @"3385195966"
//----------------------------------- QQ --------------------------------------//
#define QQ_APP_ID                           @"1105885323"
//----------------------------------- 微信 -------------------------------------//
#define WEIXIN_APP_KEY                      @"wx89d62b0eec9c1d9c"
#define WEIXIN_SECRET_KEY                   @"ffb4c8f18145bbf1d19ddd99bef72749"
//----------------------------------- 火眼财经服务 --------------------------------//

/////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// APP 状态 //////////////////////////////////////
// 开发状态
//#define STATE_DEV

// 发布状态
#define STATE_RELEASE

// 手动切换服务器
// #define STARTE_SWITCH_SERVER_MANUAL
/////////////////////////////////////////////////////////////////////////////////////


// 火眼财经服务 开发线上区分
#ifdef STATE_RELEASE
#define EV_APP_KEY                          @"r7Mun6JpcwHiSdIh"
#define EV_ACCESS_KEY                       @"hdxLQK1jMMRRQlST"
#endif

#ifdef STATE_DEV
#define EV_APP_KEY                          @"yizhibo"
#define EV_ACCESS_KEY                       @"yizhibo"
#endif


#ifdef STATE_RELEASE
#define EV_SECRET_KEY                       @"S6HQDY9M4LKnaosPrR7CZWQnsEvFgHWy"
#endif

#ifdef STATE_DEV
#define EV_SECRET_KEY                       @"helloworld"
#endif

// 开启日志全局开关e
#ifdef STATE_DEV
 #define EVDEBUG
 #define webNewsUrl @"http://dev.yizhibo.tv/hooview/stock/"
 #define webMarketUrl @"http://dev.yizhibo.tv/hooview/stock/"
#endif



// 友盟事件开关
#ifdef STATE_RELEASE
#define webNewsUrl   @"https://appgw.hooview.com/easyvaas/webapp2/"
#define webMarketUrl @"https://appgw.hooview.com/easyvaas/webapp2/"
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
#define EVVideoBaseURL                          EVURL_RELEASE
#define EVVideoBaseHTTPSURL                     EVURL_HTTPS_RELEASE
#define EVAppState                              EVURL_STATTE_RELEASE
#endif

#ifdef STATE_DEV
#define EVAppState                              EVURL_STATTE_DEV
#define EVVideoBaseHTTPSURL                     EVURL_HTTPS_DEV
#define EVVideoBaseURL                          EVURL_DEV
#endif

#ifdef STARTE_SWITCH_SERVER_MANUAL
#define EVVideoBaseURL                          [[EVAppSetting shareInstance] serverURLString]
#define EVAppState                              [[EVAppSetting shareInstance] serverAGENT]
#define EVVideoBaseHTTPSURL                     [[EVAppSetting shareInstance] httpsServerUrlString]
#endif

// 全局log
#ifdef EVDEBUG
#define EVLog( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define EVLog(...)
#endif


#endif
