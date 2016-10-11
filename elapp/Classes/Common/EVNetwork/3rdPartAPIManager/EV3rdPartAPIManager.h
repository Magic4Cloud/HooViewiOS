//
//  EV3rdPartAPIManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

//公共参数
extern NSString *const kErrorInfo;
extern NSString *const kUserRequestFail;

extern NSString *const kWeiBoAuthCancel;
extern NSString *const kWeiBoAuthDeny;
extern NSString *const kWeiBoAuthFail;

extern NSString *const kWeixinAuthFail;
extern NSString *const kWeiXinAuthCancel;
extern NSString *const kWeiXinPayCancel;
extern NSString *const kWeiXinPayFailed;

extern NSString *const kQQAuthFail;
extern NSString *const kQQAuthCancel;
extern NSString *const kQQAuthNoNetWork;


extern NSString *const k_WeiBo_ExpireInKey;
extern NSString *const k_WeiXin_ExpireInKey;
extern NSString *const k_QQ_ExpireInKey;

extern NSString *const k_AccessToken_WeiBo_Key;
extern NSString *const k_AccessToken_WeiXin_Key;
extern NSString *const k_AccessToken_QQ_Key;


@class EVShareManager,EVThirdPartUserInfo;

typedef NS_ENUM(NSInteger, EVShareManagerAuthType) {
    EVShareManagerAuthNone,
    EVShareManagerAuthWeibo,
    EVShareManagerAuthWeixin,
    EVShareManagerAuthTecent,
    EVPayManagerAuthWeixin,
};


typedef NS_ENUM(NSInteger, EVThirdPartUserInfoType) {
    EVThirdPartUserInfoSina,
    EVThirdPartUserInfoQQ,
    EVThirdPartUserInfoWeixin
};

@interface EVThirdPartUserInfo : NSObject

/** QQ weixin */
@property (nonatomic, copy) NSString *openID;

/** sina */
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) EVThirdPartUserInfoType type;

@property (nonatomic, copy) NSString *dname;
@property (nonatomic, copy) NSString *logourl;

@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *signature;

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *unionid;

- (NSMutableDictionary *)userLoginParams;

@end

@interface EV3rdPartAPIManager : NSObject

@property (nonatomic, copy) void(^qqLoginSuccess    )(NSDictionary *successDic);   /**< QQ登录成功回调 */
@property (nonatomic, copy) void(^qqLoginFailure    )(NSDictionary *failureDic);   /**< QQ登录失败回调 */
@property (nonatomic, copy) void(^sinaLoginSuccess  )(NSDictionary *successDic);   /**< 微博登录成功回调 */
@property (nonatomic, copy) void(^sinaLoginFailure  )(NSDictionary *failureDic);   /**< 微博登录失败回调 */
@property (nonatomic, copy) void(^wechatLoginSuccess)(NSDictionary *successDic);   /**< 微信登录成功回调 */
@property (nonatomic, copy) void(^wechatLoginFailure)(NSDictionary *failureDic);   /**< 微信登录失败回调 */
@property (nonatomic, copy) void(^payWechatSuccess  )(NSDictionary *successDic);   /**< 微信支付成功回调 */
@property (nonatomic, copy) void(^payWechatFailure  )(NSDictionary *failureDic);   /**< 微信支付失败回调 */

@property (nonatomic, assign) EVShareManagerAuthType authType;
/**
 *  管理三方接口的单例
 */
+ (instancetype)sharedManager;

/**
 *  第三方平台的注册
 *
 *  @param weiXinKey 注册微信登录的APPKEY
 *  @param weiBoKey  微博 key
 *  @param QQKey     QQ KEY
 */
- (void)registForAppWeiXinKey:(NSString *)weiXinKey weiBoKey:(NSString *)weiBoKey QQkey:(NSString *)QQKey;

/**
 *  获取网址
 *
 *  @param url 获取地址
 *
 *  @return YES 成功 NO 失败
 */
- (BOOL)handleURL:(NSURL *)url;

#pragma  mark -qq
- (void)qqLogin;

#pragma mark - weixin
- (void)weixinLoginWithViewController:(UIViewController *)viewController;
//+ (BOOL)weixinInstall;

#pragma mark - weibo
//+ (BOOL)weiBoInstall;
- (void)weiboLogin;

- (void)getTirdPartUserInfo:(EVThirdPartUserInfo *)userInfo
                      start:(void(^)())startBlock
                    success:(void(^)(EVThirdPartUserInfo *userInfo))successBlock
                       fail:(void(^)(NSError *error))failBlock;

@end
