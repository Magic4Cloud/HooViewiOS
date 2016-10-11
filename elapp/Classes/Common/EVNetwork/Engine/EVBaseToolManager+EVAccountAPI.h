//
//  EVBaseToolManager+EVAccountAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"

//电话号码请求
typedef enum : NSUInteger {
    PHONE = 0,  //手机号注册
    RESETPWD = 1, //重置密码
    THIRDPARTBIND = 2,
} SMSTYPE;

// 定义登录的类型
typedef NS_ENUM(NSInteger, CCUseLoginAuthtype)
{
    CCUseLoginSina,
    CCUseLoginQQ,
    CCUseLoginWeixin
};



#define CCGroupInformAPI            @"groupinform"

@interface EVBaseToolManager (EVAccountAPI)


/**
 *  获取短信验证码
 *
 *  @param areaCode      手机区号(例如86)
 *  @param phone         手机号码
 *  @param type          类型  注册  更换手机号
 *  @param phoneNumError 手机号格式错误  手机号不能为空
 *  @param startBlock    开始
 *  @param failBlock     错误
 *  @param successBlock  成功
 */
- (void)GETSmssendWithAreaCode:(NSString *)areaCode
                         Phone:(NSString *)phone
                          type:(SMSTYPE)type
                 phoneNumError:(void(^)(NSString *numError))phoneNumError
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary  *info))successBlock;







/** 重置手机密码 */
- (void)GETUserResetPassword:(NSString *)password
                       phone:(NSString *)phone
                       start:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(BOOL success))successBlock;

/** 授权后第三方登录 */
- (void)GETThirdPartLoginWithType:(CCUseLoginAuthtype)type
                           params:(NSDictionary *)param
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(EVLoginInfo *loginInfo))successBlock;


/**
 *新用户注册的
 *  phone：手机号，手机号注册必填
 password：用户密码，手机号注册必填
 logourl：用户头像，三方注册必填
 *  @param params       需要传入一个用户数据的字典 模仿该项目的LoginInfo 会储存
 *  @param startBlock   开始请求
 *  @param failBlock    错误参数
 *  @param successBlock 成功
 */
- (void)GETNewUserRegistMessageWithParams:(NSMutableDictionary *)params
                                    start:(void(^)())startBlock
                                     fail:(void(^)(NSError *error))failBlock
                                  success:(void(^)(EVLoginInfo *loginInfo))successBlock;

/** 手机登录 */
- (void)GETPhoneUserPhoneLoginWithAreaCode:(NSString *)areaCode
                                     Phone:(NSString *)phone
                                  password:(NSString *)password
                             phoneNumError:(void(^)(NSString *numError))phoneNumError
                                     start:(void(^)())startBlock
                                      fail:(void(^)(NSError *error))failBlock
                                   success:(void(^)(EVLoginInfo *loginInfo))successBlock;



@end
