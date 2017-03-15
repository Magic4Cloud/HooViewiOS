//
//  EVEnums.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//

#ifndef oupai_EVEnums_h
#define oupai_EVEnums_h



typedef NS_ENUM(NSInteger, EVLiveShareButtonType) {
    EVLiveShareQQButton = 200,
    EVLiveShareWeiXinButton,
    EVLiveShareSinaWeiBoButton,
    EVLiveShareFriendCircleButton,
    EVLiveShareQQZoneButton,
    EVLiveShareCopyButton
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



typedef NS_ENUM(NSUInteger, EVTextVCType) {
    EVTermOfService = 1,
    EVPrivacyPolicy
};

typedef enum : NSUInteger {
    DEFUALTRECOMMEND = 0,
    INTERESTINGRECOMMEND = 1,
} RECOMMENDTYPE;


// 礼物类型
typedef NS_ENUM(NSInteger, EVPresentType) {
    EVPresentTypeEmoji,          // 0 表情
    EVPresentTypeYiMi,           // 1 薏米
    EVPresentTypePresent         // 2 礼物
};

#endif
