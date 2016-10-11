//
//  CCEnums.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//

#ifndef oupai_CCEnums_h
#define oupai_CCEnums_h



typedef NS_ENUM(NSInteger, CCLiveShareButtonType) {
    CCLiveShareQQButton = 200,
    CCLiveShareWeiXinButton,
    CCLiveShareSinaWeiBoButton,
    CCLiveShareFriendCircleButton,
    CCLiveShareQQZoneButton,
    CCLiveShareCopyButton
};


typedef enum : NSUInteger {
    FANS = 0,                 // fans is shown
    FOCUSES,                  // focuses is shown
} controllerType;             // what kind of content is showing here


#define EVLivePermissionKey @"EVLivePermissionKey"
/** 视频权限信息 */
typedef NS_ENUM(NSInteger, EVLivePermission)
{
    EVLivePermissionSquare = 0,         // 所以好友可见
    EVLivePermissionPrivate = 2,            // 自己可见
    EVLivePermissionPassWord = 6,             // 密码直播
    EVLivePermissionPay = 7
};



typedef NS_ENUM(NSUInteger, CCTextVCType) {
    CCTermOfService = 1,
    CCPrivacyPolicy
};

typedef enum : NSUInteger {
    DEFUALTRECOMMEND = 0,
    INTERESTINGRECOMMEND = 1,
} RECOMMENDTYPE;

/**< 推荐列表枚举：推荐直播或者推荐预告 */
typedef NS_ENUM(NSUInteger, CCRecommandTableViewType) {
    CCLiveShowTableView,
    CCForeShowTableView
};

/**< 预告左下角按钮类型：订阅、删除、已订阅 */
typedef NS_ENUM(NSUInteger, CCForeShowSubscribeType) {
    CCForeShowBtnSubscribe,             /**< 订阅 */
    CCForeShowBtnSubscribed,            /**< 已订阅 */
    CCForeShowBtnDelete                 /**< 删除 */
};

/**< 预告类型：推荐、个人、他人 */
typedef NS_ENUM(NSUInteger, CCForeShowType) {
    CCForeShowRecommand,
    CCForeShowMine,
    CCForeShowOther
};

/**< 分享类型：视频、预告, 注册分享 */
typedef NS_ENUM(NSUInteger, CCShareType) {
    CCShareVideo,
    CCShareForecast,
    CCShareActivity,
    CCShareInviterRegist
};

// 活动的种类
typedef NS_ENUM(NSInteger, CCActivityType)
{
    CCActivityTypeUnknow            = -1,
    CCActivityTypeNormal            = 0,
    CCActivityTypeH5                = 1
};


// 礼物类型
typedef NS_ENUM(NSInteger, CCPresentType) {
    CCPresentTypeEmoji,          // 0 表情
    CCPresentTypeYiMi,           // 1 薏米
    CCPresentTypePresent         // 2 礼物
};

#endif
