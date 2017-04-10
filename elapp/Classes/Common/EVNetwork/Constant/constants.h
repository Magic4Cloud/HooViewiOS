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

#define EVAPPSTARTAPI               @"/api/ad/appstart"//App启动页广告。

#define EVVideoMobileRegisterAPI    @"/user/register"//用户注册
#define EVRegisterUserAPI           @"/user/login"//用户登录
#define EVVideoUserInfoAPI          @"/user/info"         /**< 用户的完整基本信息接口，个人中心使用 */
#define EVUserSettingInfo           @"/user/getparam"
#define EVUserEditSetting           @"/user/setparam"//设置直播室通知
#define EVVideoUserFollowsAPI       @"/user/followerlist"
#define EVVideoUserBind             @"/user/bind"//用户绑定
#define EVUserAuthUnbind            @"/user/unbind"//取消绑定
#define EVVideoUserLogoutAPI        @"/user/logout"
#define EVVideoUserEditInfoAPI      @"/user/edit"
#define EVUserBaseInfoAPI           @"/user/baseinfo"     /**< 用户的基本信息接口，除个人中心都用这个 */
#define EVVideoUserFansAPI          @"/user/fanslist"
#define EVVideoFollowUserAPI        @"/user/follow"
#define EVVideoUserPastVideoAPI     @"/user/videolist"//视频列表
#define EVVideoUploadIconAPI        @"/user/userlogo"
#define EVUserInfos                 @"/user/infos"
#define EVVideoResetPwdAPI          @"/user/resetpwd"//重置密码


#define EVUserInformAPI             @"/user/userinform"
#define EVAuthPhoneChangeAPI        @"/user/authphonechange"
#define EVModifyPasswordAPI         @"/user/modifypassword"

#define EVSmsSendAPI                @"/sms/send"//短信验证码
#define EVSmsVerfyAPI               @"/sms/verify"//短信验证

#define EVVideoToplistAPI           @"/video/recommendlist"//话题视频列表
#define EVTopicVideo                @"/video/recommendlist"

#define EVLiveVideosettitleAPI      @"/video/title"//更改视频标题
#define EVLiveStartAPI              @"/video/start"
#define EVVideoStopLiveAPI          @"/video/stop"
#define EVWatchUserstartwatchvideo  @"/video/watch"
#define EVFriendcircleAPI           @"/video/friend"
#define EVVideoDeletePastVideoAPI   @"/video/remove"
#define EVVideoLivePayAPI           @"/video/livepay"
#define EVVideoLogo                 @"/video/videologo"
#define EVVideoTopiclistAPI         @"/video/topiclist"
#define EVCarouselInfo              @"/video/carouselinfo"           // 轮播图接口

#define EVGetParamNewAPI            @"/sys/settings"

#define EVGoodsListAPI              @"/pay/goods"
#define EVBuyPresent                @"/pay/sendgift"
#define EVAssetsranklistAPI         @"/pay/assetsranklist" //排行榜
#define EVAnchorSendPacket          @"/pay/sendredpack"
#define EVCashinOptionAPI           @"/pay/cashinoption"
#define EVGetContributorAPI         @"/pay/getcontributor"
#define EVCashoutrecordAPI          @"/pay/cashoutrecord"
#define EVConsumeAPI                @"/pay/consume"
#define EVRechargerecordAPI         @"/pay/rechargerecord"
#define EVUserAssets                @"/pay/getuserasset"
#define EVVideoUserRedpack          @"/pay/openredpack"
#define EVAppleValidAPI             @"/pay/recharge"
#define EVOpenRedEnvelAPI           @"/pay/openredpack"

#define EVMessagegrouplistAPI       @"/msg/messagegrouplist"//获取招呼内的消息组列表
#define EVMessageitemlistAPI        @"/msg/messageitemlist"//获取招呼内的某个消息组内的消息列表
#define EVMessageunreadcountAPI     @"/msg/messageunreadcount"//获取招呼和好友的总未读个数

#define EVVideoShutupAPI            @"/interact/shutup" //禁言
#define EVVideoManagerAPI           @"/interact/setmanager"
#define EVVideoKickUserAPI          @"interact/kickuser"

#define EVRequestLinkAPI            @"/video/callrequest"
#define EVAcceptLinkAPI             @"/video/callaccept"
#define EVEndLinkAPI                @"/video/callend"
#define EVCancelLinkAPI             @"/video/callcancel"

#define WeixinPaySuccessNotification          @"WeixinPaySuccessNotification"
#define WeixinPayFailedNotification           @"WeixinPayFailedNotification"

#define kUserLocationServiceEnableTagKey      @"kUserLocationServiceEnableTagKey"

#define kEVDeviceTokenKey                     @"kEVDeviceTokenKey"

// 用来标识用户是否第一次启动应用
#define EVHasLoginTag                         @"EVHasLoginTag"
#define EVNoNeedToAlertNotificationSettingTag @"EVNoNeedToAlertNotificationSettingTag"

#define kContactListAuthorize                 @"kContactListAuthorize"
#define kContactListPrepareNotification       @"kContactListPrepareNotification"

#define kIMAccountHasLogin                    @"kIMAccountHasLogin"
#define kIMAccountHasRegist                   @"kIMAccountHasRegist"

#define kNotificationOffKey                   @"pushNotificationIsOff"

#define CCColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]



#define EVCollectListAPI            @"/user/collectlist"
#define EVCollectAPI                @"/user/collect"
#define EVHistoryAPI                @"/user/history"
#define EVHistoryList               @"/user/historylist"
#define EVSearchVideoAPI            @"https://dev.yizhibo.tv/hooview/appgw/video/search"

#define EVGoodVideoListAPI          @"/video/vodlist"
#define EVVideoInfosAPI             @"/video/infos"

#define EVUserTagsListAPI           @"/user/tags"
#define EVALLUserTagsAPI            @"/sys/taglist"
#define EVUserTagsSetAPI            @"/user/tagset"





#ifdef STATE_DEV

//#define EVMarketQuotesAPI           @"http://openapi.hooview.com/tushare/get_index"           //大盘详情
#define EVMarketQuotesAPI           @"http://dev.hooview.com/api/stock/market"           //大盘详情
//#define EVAllTodayAPI               @"http://openapi.hooview.com/tushare/get_today_all"       //涨幅榜
#define EVAllTodayAPI               @"http://dev.hooview.com/api/stock/changelist"
//#define EVQueryQuotesAPI            @"http://dev.hooview.com/tushare/get_realtime_quotes"
#define EVQueryQuotesAPI            @"http://dev.hooview.com/api/stock/realtime"
#define EVHVNewsConstantAPI         @"http://dev.hooview.com/api/news/gethomeNews"
#define EVHVFastNewsAPI             @"http://dev.hooview.com/api/news/getnewsflash"
#define EVHVEyesDetailNewsAPI       @"http://dev.hooview.com/api/news/getlist"
#define EVStockComment              @"http://dev.hooview.com/api/bbs/stockpost"
#define EVNewsComment               @"http://dev.hooview.com/api/bbs/newspost"
#define EVSearchNews                @"http://dev.hooview.com/api/search/news"
#define EVSearchStock               @"http://dev.hooview.com/api/search/stock"
#define EVVideoCommentAPI           @"http://dev.hooview.com/api/bbs/videopost"
#define EVVideoCommentListAPI       @"http://dev.hooview.com/api/bbs/videoconversatons"
#define EVConsultNewsAPI            @"http://dev.hooview.com/api/news/customnews"
#define EVNewsDetailAPI             @"http://dev.hooview.com/api/news/getnews"
#define EVNewsUserNewsAPI           @"http://dev.hooview.com/api/news/usernews"

#define EVMarketGlobalAPI           @"http://dev.hooview.com/api/stock/globalindex"

#define EVCreatTextLiveAPI          @"http://dev.hooview.com/api/textlive/owner"
#define EVTextLiveHomeAPI           @"http://dev.hooview.com/api/textlive/home"
#define EVTextLiveChatUploadAPI     @"http://dev.hooview.com/api/textlive/chat" //POST

#define EVTextLiveHistiryAPI        @"http://dev.hooview.com/api/textlive/history"

#define EVStockListAPI              @"http://dev.hooview.com/api/user/stocks"//自选股列表

//api/news/banners/
#define EVAddSelfStockAPI           @"http://dev.hooview.com/api/user/modifystocks"//添加 & 修改自选股
#define EVGetChooseStockNewsAPI     @"http://dev.hooview.com/api/user/stocknews"//自选新闻
#define EVIsAddSelfStockAPI         @"http://dev.hooview.com/api/user/collect/stock"//是否已添加自选

#define EVHoovviewNewsBannersAPI    @"http://dev.hooview.com/api/news/banners"
#define EVTextLiveHaveAPI           @"http://dev.hooview.com/api/textlive/streaminfo"

//支付成功回调给服务器
#define EVSuccessPayToService       @"https://appgw.hooview.com/easyvaas/service/service/payecoin"
#endif



// 友盟事件开关
#ifdef STATE_RELEASE
#define EVTextLiveHaveAPI           @"http://openapi.hooview.com/api/textlive/streaminfo"

//#define EVMarketQuotesAPI           @"http://openapi.hooview.com/tushare/get_index"           //大盘详情
#define EVMarketQuotesAPI           @"http://openapi.hooview.com/api/stock/market"           //大盘详情
//#define EVAllTodayAPI               @"http://openapi.hooview.com/tushare/get_today_all"       //涨幅榜
#define EVAllTodayAPI               @"http://openapi.hooview.com/api/stock/changelist"
//#define EVQueryQuotesAPI            @"http://openapi.hooview.com/tushare/get_realtime_quotes"
#define EVQueryQuotesAPI            @"http://openapi.hooview.com/api/stock/realtime"
//#define EVHVNewsConstantAPI         @"http://openapi.hooview.com/api/news/gethomeNews"
//改版
#define EVHVNewsConstantAPI         @"http://dev.hooview.com/api/v2/news/home"

#define EVHVFastNewsAPI             @"http://openapi.hooview.com/api/news/getnewsflash"
#define EVHVEyesDetailNewsAPI       @"http://openapi.hooview.com/api/news/getlist"
#define EVStockComment              @"http://openapi.hooview.com/api/bbs/stockpost"
#define EVNewsComment               @"http://openapi.hooview.com/api/bbs/newspost"
#define EVSearchNews                @"http://openapi.hooview.com/api/search/news"
#define EVSearchStock               @"http://openapi.hooview.com/api/search/stock"
#define EVVideoCommentAPI           @"http://openapi.hooview.com/api/bbs/videopost"
#define EVVideoCommentListAPI       @"http://openapi.hooview.com/api/bbs/videoconversatons"
#define EVConsultNewsAPI            @"http://openapi.hooview.com/api/news/customnews"
#define EVNewsDetailAPI             @"http://openapi.hooview.com/api/news/getnews"
#define EVNewsUserNewsAPI           @"http://openapi.hooview.com/api/news/usernews"
#define EVStockListAPI              @"http://openapi.hooview.com/api/user/stocks"//自选股列表
#define EVAddSelfStockAPI           @"http://openapi.hooview.com/api/user/modifystocks"//添加 & 修改自选股
#define EVGetChooseStockNewsAPI     @"http://openapi.hooview.com/api/user/stocknews"//自选新闻
#define EVIsAddSelfStockAPI         @"http://openapi.hooview.com/api/user/collect/stock"//是否已添加自选

#define EVMarketGlobalAPI           @"http://openapi.hooview.com/api/stock/globalindex"

#define EVCreatTextLiveAPI          @"http://openapi.hooview.com/api/textlive/owner"
#define EVTextLiveHomeAPI           @"http://openapi.hooview.com/api/textlive/home"
#define EVTextLiveChatUploadAPI     @"http://openapi.hooview.com/api/textlive/chat" //POST

#define EVTextLiveHistiryAPI        @"http://openapi.hooview.com/api/textlive/history"

//api/news/banners/
#define EVHoovviewNewsBannersAPI    @"http://openapi.hooview.com/api/news/banners"
#define EVTextLiveHaveAPI           @"http://openapi.hooview.com/api/textlive/streaminfo"

//支付成功回调给服务器
#define EVSuccessPayToService       @"https://appgw.hooview.com/easyvaas/service/service/payecoin"




#endif
#endif
