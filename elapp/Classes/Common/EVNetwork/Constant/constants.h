//
//  constants.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#ifndef CCVideo_constants_h
#define CCVideo_constants_h

#define WEIBO_APP_RE_DIRECT_URI     @"https://api.weibo.com/oauth2/default.html"
#define WeiboBaseURL                @"https://api.weibo.com/2/users/show.json"
#define QQBaseURL                   @"https://graph.qq.com/user/get_user_info"

#define EVVideoMobileRegisterAPI    @"user/register"//用户注册
#define EVRegisterUserAPI           @"user/login"//用户登录
#define EVVideoUserInfoAPI          @"user/info"         /**< 用户的完整基本信息接口，个人中心使用 */
#define EVUserSettingInfo           @"user/getparam"
#define EVUserEditSetting           @"user/setparam"//设置直播室通知
#define EVVideoUserFollowsAPI       @"user/followerlist"
#define EVVideoUserBind             @"user/bind"//用户绑定
#define EVUserAuthUnbind            @"user/unbind"//取消绑定
#define EVVideoUserLogoutAPI        @"user/logout"
#define EVVideoUserEditInfoAPI      @"user/edit"
#define EVUserBaseInfoAPI           @"user/baseinfo"     /**< 用户的基本信息接口，除个人中心都用这个 */
#define EVVideoUserFansAPI          @"user/fanslist"
#define EVVideoFollowUserAPI        @"user/follow"
#define EVVideoUserPastVideoAPI     @"user/videolist"//视频列表
#define EVVideoUploadIconAPI        @"user/userlogo"
#define EVUserInfos                 @"user/infos"
#define EVVideoResetPwdAPI          @"user/resetpwd"//重置密码
#define EVSearchInfosAPI            @"user/search"

#define EVUserInformAPI             @"user/userinform"
#define EVAuthPhoneChangeAPI        @"user/authphonechange"
#define EVModifyPasswordAPI         @"user/modifypassword"

#define EVSmsSendAPI                @"sms/send"//短信验证码
#define EVSmsVerfyAPI               @"sms/verify"//短信验证

#define EVVideoToplistAPI           @"video/hotlist"//话题视频列表
#define EVTopicVideo                @"video/topicvideo"
#define EVLiveVideosettitleAPI      @"video/title"//更改视频标题
#define EVLiveStartAPI              @"video/start"
#define EVVideoStopLiveAPI          @"video/stop"
#define EVWatchUserstartwatchvideo  @"video/watch"
#define EVFriendcircleAPI           @"video/friend"
#define EVVideoDeletePastVideoAPI   @"video/remove"
#define EVVideoLivePayAPI           @"video/livepay"
#define EVVideoLogo                 @"video/videologo"
#define EVVideoTopiclistAPI         @"video/topiclist"
#define EVCarouselInfo              @"video/carouselinfo"           // 轮播图接口

#define EVGetParamNewAPI            @"sys/settings"

#define EVGoodsListAPI              @"pay/goods"
#define EVBuyPresent                @"pay/sendgift"
#define EVAssetsranklistAPI         @"pay/assetsranklist" //排行榜
#define EVAnchorSendPacket          @"pay/sendredpack"
#define EVCashinOptionAPI           @"pay/cashinoption"
#define EVGetContributorAPI         @"pay/getcontributor"
#define EVCashoutrecordAPI          @"pay/cashoutrecord"
#define EVRechargerecordAPI         @"pay/rechargerecord"
#define EVUserAssets                @"pay/getuserasset"
#define EVVideoUserRedpack          @"pay/openredpack"
#define EVAppleValidAPI             @"pay/applevalid"
#define EVOpenRedEnvelAPI           @"pay/openredpack"

#define EVMessagegrouplistAPI       @"msg/messagegrouplist"//获取招呼内的消息组列表
#define EVMessageitemlistAPI        @"msg/messageitemlist"//获取招呼内的某个消息组内的消息列表
#define EVMessageunreadcountAPI     @"msg/messageunreadcount"  //  获取招呼和好友的总未读个数

#define EVVideoShutupAPI            @"interact/shutup" //禁言

//#define SinaWeiboLoginNotification @"sinaWeiboLoginNotification"
//#define SinaWeiboLoginFailedNotification @"SinaWeiboLoginFailedNotification"
//
//#define QQLoginNotification @"qqLoginNotification"
//#define QQLoginFailedNotification @"QQLoginFailedNotification"
//#define WeixinLoginNotification @"WeixinLoginNotification"
//#define WeixinLoginFailedNotification @"WeixinLoginFailedNotification"
#define WeixinPaySuccessNotification @"WeixinPaySuccessNotification"
#define WeixinPayFailedNotification @"WeixinPayFailedNotification"

#define kUserLocationServiceEnableTagKey @"kUserLocationServiceEnableTagKey"

#define kCCDeviceTokenKey @"kCCDeviceTokenKey"


#define CCColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

// 用来标识用户是否第一次启动应用
#define CCHasLoginTag @"CCHasLoginTag"
#define CCNoNeedToAlertNotificationSettingTag @"CCNoNeedToAlertNotificationSettingTag"

#pragma mark - account binding

#define kContactListAuthorize @"kContactListAuthorize"
#define kContactListPrepareNotification @"kContactListPrepareNotification"


#define kIMAccountHasLogin  @"kIMAccountHasLogin"
#define kIMAccountHasRegist @"kIMAccountHasRegist"

#define kNotificationOffKey @"pushNotificationIsOff"
#endif

