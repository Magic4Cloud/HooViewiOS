//
//  EVBaseToolManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVNetWorkManager.h"
#import "CCEnums.h"
#import "NSError+Extention.h"

@class ASIHTTPRequest, EVLoginInfo, CCLoginIMInfo, EMError;
@interface EVBaseToolManager : NSObject

@property (nonatomic, assign) BOOL syschronizedCache;

// 当前的请求列表
@property (nonatomic, strong) NSMapTable *requests;

// 停止当前所有操作
- (void)cancelAllOperation;

// 停止指定的URL请求
- (void)cancelOperataionWithURLString:(NSString *)urlString;

// 删除制定的URL请求
- (void)removeOperationWithURLString:(NSString *)urlString;

// 添加一个http请求
- (void)addRequest:(ASIHTTPRequest *)request
            forKey:(NSString *)urlString;


// 获取本地Session
+ (NSString *)userSessionIDFromLocal;

/** 获取设备唯一标识 */
+ (NSString *)getDeviceId;

// 保存本地session
+ (void)saveSessionId:(NSString *)sesseionId;

// 保存用户名称到本地
+ (void)saveUserDisPlaynameToLocal:(NSString *)dname;

// 从本地读取用户名称
+ (NSString *)userDisPlayNameFromLocal;

// 进行一次本地Session的有效性检查
+ (void)checkSessionID;

// 进行一次本地Session的有效性检查
+ (void)checkSession:(void(^)())start
           completet:(void(^)(BOOL expire))complete
                fail:(void(^)(NSError *error))fail;

// 清空Session信息
+ (void)resetSession;

// 用户是否已经登录
+ (BOOL)userHasLoginLogin;

// 检查指定的名称是否位当前的用户名称
+ (BOOL)isCurrUserName:(NSString *)name;

// 检查摄像头和麦克风是否可用
+ (BOOL)checkCameraAndMicoAuth;

// IM账号是否登录
+ (BOOL)imAccountHasLogin;

// 设置IM账号的登录状态
+ (void)setIMAccountHasLogin:(BOOL)login;

// 设置用户名称
+ (void)setUserNameToLocal:(NSString *)name;

// 获取本地用户名称
+ (NSString *)userNameFromLocal;

// IM是否注册
+ (BOOL)imHasRegist;

// 设置IM的注册状态
+ (void)setIMHasRegist:(BOOL)regist;

// 通知登录视图消失
+ (void)notifyLoginViewDismiss;

/** 用于环信登录的 */
+ (void)imLoginWithLoginInfo:(EVLoginInfo *)login
                     success:(void(^)(CCLoginIMInfo *imInfo))success
                        fail:(void(^)(EMError *error))fail
               sessionExpire:(void(^)())sessionExpire;

/** 环信注销登录 */
+ (void)imLogoutUnbind:(BOOL)unbind
               success:(void(^)(NSDictionary *info))success
                  fail:(void(^)(EMError *error))fail;


@end


@interface EVBaseToolManager (SMSVerify)


/* 验证验证码 **/
- (void)getSmsverifyWithSmd_id:(NSString *)sms_id
                      sms_code:(NSString *)sms_code
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)())successBlock;

/* 验证验证码 **/
- (void)smsverifyWithSmd_id:(NSString *)sms_id
                   sms_code:(NSString *)sms_code
                   authType:(NSString *)authType
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)())successBlock;

@end

@interface EVBaseToolManager ( Common )

// 请求指定URL的内容
- (NSString *)requestWithURLString:(NSString *)urlString
                             start:(void (^)())startBlock
                              fail:(void (^)(NSError *))failBlock
                           success:(void (^)(NSData *data))successBlock;

// 同步请求
- (ASIHTTPRequest *)startSynchronousRequestWithURLString:(NSString *)urlString;

/**
 *  @author shizhiang, 16-01-18 18:01:42
 *
 *  上拉、下拉刷新请求
 *
 *  @param url          请求路径
 *  @param startBlock   开始请求
 *  @param failBlock    请求失败
 *  @param successBlock 请求成功
 
 *  @return 网络请求路径
 */
- (NSString *)refreshRequestWithUrl:(NSString *)url
                              start:(void (^)())startBlock
                               fail:(void (^)(NSError *))failBlock
                            success:(void (^)(NSData *data))successBlock;

// 发送一条Post指令
- (NSString *)postWithURLString:(NSString *)urlString
                    contentType:(NSString *)contentType
                         params:(NSMutableDictionary *)params
                       fileData:(NSData *)data
                   fileMineType:(NSString *)fileMineType
                       fileName:(NSString *)fileName
                          start:(void (^)())startBlock
                           fail:(void (^)(NSError *))failBlock
                        success:(void (^)(NSData *data))successBlock;

// 发送一条Post指令 contentType: application/json
- (NSString *)jsonPostWithURLString:(NSString *)urlString
                             params:(NSDictionary *)params
                              start:(void (^)())startBlock
                               fail:(void (^)(NSError *))failBlock
                            success:(void (^)(NSData *data))successBlock;

// 获取SessionID
- (NSString *)getSessionIdWithBlock:(void(^)())sessionExpireBlock;

// 获得推送信息字典
- (void)getPushParamsWithParams:(NSMutableDictionary *)params;

// 获取gps信息
- (void)getGPSInfo:(NSMutableDictionary *)params;

// 获得推送信息字典
- (void)getPushInfo:(NSMutableDictionary *)params;

@end

@interface EVBaseToolManager ( Notification)

+ (void)turnNotificationOff:(BOOL)off;
+ (BOOL)pushNotificationIsOff;

@end
