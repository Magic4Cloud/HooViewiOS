//
//  EVLoginInfo.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

#define kCCPhoneLoginTag @"kCCPhoneLoginTag"
#define kCCQQLoginTag @"kCCQQLoginTag"
#define kCCWeiXinLoginTag @"kCCWeiXinLoginTag"
#define kCCWeiBoLoginTag @"kCCWeiBoLoginTag"

@interface EVLoginIMInfo : EVBaseObject <NSCoding>

@property (nonatomic, assign) long LastLoginTime;
@property (nonatomic,copy) NSString *jid;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *resource;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *username;

@end

@interface EVLoginInfo : EVBaseObject <NSCoding>

@property (nonatomic, assign) BOOL registeredSuccess;   // 注册成功

@property (nonatomic, strong) NSArray *auth;            // 第三方授权信息

@property (nonatomic, copy) NSString *sexStr;         // 性别

// 环信 账号、密码
@property (nonatomic,copy) NSString *imuser;
@property (nonatomic,copy) NSString *impwd;
@property (nonatomic,strong) EVLoginIMInfo *imLoginInfo;

@property (nonatomic, copy) NSString *loginTag;         // 三方登陆类型
@property (nonatomic, assign) BOOL hasLogin;            // 是否已经登陆

/** 云播号 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic,copy) NSString *username;          // 用户姓名
@property (nonatomic, copy) NSString *sessionid;        // 登陆标识
@property (nonatomic, copy) NSString *gender;         // 性别

@property (nonatomic, copy) NSString *authtype;         // 授权类型
@property (nonatomic, copy) NSString *birthday;         // 生日

@property (nonatomic, copy) NSString *nickname;         // 昵称

@property (nonatomic, copy) NSString *location;         // 位置
@property (nonatomic, copy) NSString *signature;      // 个性签名

@property (nonatomic, copy) NSString *logourl;          // 头像地址

@property (nonatomic, copy) NSString *access_token;     //
@property (nonatomic, copy) NSString *refresh_token;    //
@property (nonatomic, copy) NSString *expires_in;       //

/** 手机时为手机号码，三方时为三方账号 */
@property (nonatomic, copy) NSString *token;            //
@property (nonatomic, copy) NSString *phone;            // 手机号

@property (nonatomic, copy) NSString *password;         // 密码

@property (nonatomic, strong) UIImage *selectImage;     // 头像

@property (nonatomic, copy) NSString *unionid;          /**< 微信的unionid */

@property (nonatomic, assign) NSInteger barley;              /**< 薏米数 */
@property (nonatomic, assign) NSInteger ecoin;               /**< 火眼豆数 */

@property (nonatomic, assign) NSInteger vip;

@property (nonatomic, copy) NSString *practiceNum;
@property (nonatomic, copy) NSString *credentials;          /**< 执业证号 */
@property (nonatomic, copy) NSString *introduce;          /**< 详细介绍 */


/**
 *  同步登陆模型信息
 */
- (void)synchronized;

/**
 *  本地存储的模型
 */
+ (EVLoginInfo *)localObject;

/**
 *  通过name检查当前用户
 *
 *  @param name 当前登陆的用户
 *
 *  @return YES表示当前登陆的用户与本地存储的用户信息相同，否则不同
 */
+ (BOOL)checkCurrUserByName:(NSString *)name;

/**
 *  获取手机用户信息
 *
 *  @return 用户信息字典
 */
- (NSMutableDictionary *)userInfoParams;

/**
 *  获取第三方注册用户信息
 *
 *  @return 用户信息字典
 */
- (NSMutableDictionary *)userRegistParams;

/**
 *  清除本地缓存
 */
+ (void)cleanLoginInfo;

/** 是否处于登录状态 */
+ (BOOL)hasLogged;


@end
