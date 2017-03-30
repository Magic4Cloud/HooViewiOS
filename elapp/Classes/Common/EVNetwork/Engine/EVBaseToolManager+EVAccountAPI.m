//
//  EVBaseToolManager+EVAccountAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVAccountAPI.h"
#import "constants.h"
#import "NSString+Extension.h"
#import "EVLoginInfo.h"
#import "AppDelegate.h"
#import "EVHttpURLManager.h"



#define kEUNAME @"E_USER_NOT_EXISTS"

#define kAccountExistNeedMerge @"E_AUTH_NEED_MERGE"
#define kAccountMergeConflict @"E_AUTH_MERGE_CONFLICTS"
#define kAccountUserPhoneFormatError @"E_USER_PHONE_FORMAT"
#define kAccountMergeEServer @"E_SERVER"
#define kAccountOK @"ok"

#define kAccountNoWeiBoAccountError @"kAccountNoWeiBoAccountError"
#define kAccountWeiBoServerError @"kAccountWeiBoServerError"


#define kNoWeiBoAccount @"E_AUTH_NO_WEIBO"
#define kGetWeiBoAccountInfo @"E_SERVICE_WEIBO"
#define IMREGIST_TRY_MAX_COUNT  5



@implementation EVBaseToolManager (EVAccountAPI)




- (void)GETSmssendWithAreaCode:(NSString *)areaCode
                         Phone:(NSString *)phone
                          type:(SMSTYPE)type
                 phoneNumError:(void(^)(NSString *numError))phoneNumError
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary  *info))successBlock
{
    if (!phone || [phone isEqualToString:@""] || phone.length == 0 )
    {
        if (phoneNumError) {
            phoneNumError(kE_GlobalZH(@"fail_phone_num"));
        }
        return;
    }
    NSString *phoneStr;
    if (areaCode.length == 0 || [areaCode isEqualToString:@""] || areaCode == nil) {
        phoneStr = [NSString stringWithFormat:@"%@", phone];
    }else{
       phoneStr = [NSString stringWithFormat:@"%@_%@",areaCode, phone];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPhone] = phoneStr;
    params[kType] = @(type);
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVSmsSendAPI  params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];

}


- (void)GETNewUserRegistMessageWithParams:(NSMutableDictionary *)params
                                    start:(void(^)())startBlock
                                     fail:(void(^)(NSError *error))failBlock
                                  success:(void(^)(EVLoginInfo *loginInfo))successBlock
{
    if ([(NSString *)params[kAuthType] isEqualToString:kPhone])
    {
        [params setValue:params[kToken]
                  forKey:kPhone];
    }
    
    NSString *passwordmd5 = params[kPassword];
    [params removeObjectForKey:kPassword];
    [params removeObjectForKey:kPhone];
    [params setValue:passwordmd5 forKey:kPassword];
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoMobileRegisterAPI
                                                   params:params];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *postParams = nil;
//    if ( passwordmd5 )
//    {
//        postParams = @{ kPassword : passwordmd5 };
//    }
//    [EVBaseToolManager POSTNotSessionWithUrl:urlString params:postParams fileData:nil fileMineType:nil fileName:nil success:^(NSDictionary *successDict) {
//                                 EVLoginInfo *loginInfo = [EVLoginInfo objectWithDictionary:successDict];
//                                 if ( successBlock )
//                                 {
//                                     successBlock(loginInfo);
//                                 }
//                                 [app_delegate_engine checkIMInfoWithLoginInfo:loginInfo];
//    } failError:failBlock];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:nil success:^(NSDictionary *successDict) {
                         EVLoginInfo *loginInfo = [EVLoginInfo objectWithDictionary:successDict];
                         if ( successBlock )
                         {
                             successBlock(loginInfo);
                         }
                         [app_delegate_engine checkIMInfoWithLoginInfo:loginInfo];
       
    } sessionExpireBlock:nil fail:failBlock];
    

}


#pragma mark - Userlogin
// http://115.29.109.121/mediawiki/index.php?title=Userlogin
- (void)GETPhoneUserPhoneLoginWithAreaCode:(NSString *)areaCode
                                     Phone:(NSString *)phone
                                  password:(NSString *)password
                             phoneNumError:(void(^)(NSString *numError))phoneNumError
                                     start:(void(^)())startBlock
                                      fail:(void(^)(NSError *error))failBlock
                                   success:(void(^)(EVLoginInfo *loginInfo))successBlock
{
    if ( phone.length == 0 || password.length == 0 )
    {
        if (phoneNumError) {
            phoneNumError(kE_GlobalZH(@"phone_and_password_not_nil"));
        }
        return;
    }
    
    NSString *pnoneNum = [NSString stringWithFormat:@"%@_%@",areaCode,phone];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self getPushParamsWithParams:params];
    params[kAuthType] = @"phone";
    
    password = [password md5String];
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVRegisterUserAPI
                                                   params:nil];
    if (password || pnoneNum) {
        
        [params setValue:password forKey:kPassword];
        [params setValue:pnoneNum forKey:kToken];
    }
    

    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:^(NSDictionary *successDict)
    {
        EVLoginInfo *loginInfo = [EVLoginInfo objectWithDictionary:successDict];
                         loginInfo.loginTag = kCCPhoneLoginTag;
                         for ( NSUInteger i = 0; i < ((NSArray *)successDict[kAuth]).count; i++ )
                         {
                             if ( [successDict[kToken] isEqualToString:@"phone"] )
                             {
                                 loginInfo.phone = successDict[kPhone];
                             }
                         }
        
                         // 注册IM账号检查是否需要登录
                         // 使用全局接口对象访问,  如果改对象被销毁了
                         // fix by 高沛荣
                         [app_delegate_engine checkIMInfoWithLoginInfo:loginInfo];
        
        
                         if ( successBlock )
                         {
                             successBlock(loginInfo);
                         }
    } sessionExpireBlock:nil
                                fail:failBlock];

}

- (void)checkIMInfoWithLoginInfo:(EVLoginInfo *)login
{
    if ( login.impwd.length == 0 || login.imuser.length == 0 )
    {
//        static int try = 0;
//        __weak typeof(self) wself = self;
//        [self GETUseriminfoStart:nil
//                            fail:^(NSError *error)
//         {
//             if ( try < IMREGIST_TRY_MAX_COUNT )
//             {
//                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                                {
//                                    [wself checkIMInfoWithLoginInfo:login];
//                                });
//                 try++;
//             }
//             //            else
//             //            {
//             //                try = 0;
//             //            }
//             [[wself class] setIMHasRegist:NO];
//         }
//                         success:^(NSDictionary *imInfo)
//         {
//             EVLog(@"####-----%d,----%s-----login = %@ iminfo = %@---####",__LINE__,__FUNCTION__,login, imInfo);
//             
//             login.imuser = imInfo[kImuser];
//             login.impwd = imInfo[kImpwd];
//             [wself imLoginWithLoginInfo:login];
//             [[wself class] setIMHasRegist:YES];
//             try = 0;
//         }
//                   sessionExpire:^
//         {
//             [[wself class] resetSession];
//             try = 0;
//         }];
    }
    else
    {
        [self imLoginWithLoginInfo:login];
    }
}

- (void)imLoginWithLoginInfo:(EVLoginInfo *)login
{
    __weak typeof(self) wself = self;
    [[self class] imLoginWithLoginInfo:login
                               success:nil
                                  fail:nil
                         sessionExpire:^
     {
         [[wself class] resetSession];
     }];
}



/**
 第三方登录需要额外传其他参数
 dname
 用户第三方昵称信息
 logourl
 用户第三方头像信息
 access_token
 用户第三方access_token
 refresh_token
 用户第三方refresh_token
 expires_in
 用户第三方token失效时间
 http://115.29.109.121/mediawiki/index.php?title=Userlogin
 */

- (void)GETThirdPartLoginWithType:(EVUseLoginAuthtype)type
                           params:(NSDictionary *)param
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(EVLoginInfo *loginInfo))successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [self getPushParamsWithParams:params];
    
    NSString *authtype = nil;
    NSString *loginTag = nil;
    switch (type)
    {
        case EVUseLoginSina:
            authtype = kAuthTypeSina;
            loginTag = kCCWeiBoLoginTag;
            break;
        case EVUseLoginQQ:
            authtype = kAuthTypeQQ;
            loginTag = kCCQQLoginTag;
            break;
        case EVUseLoginWeixin:
            authtype = kAuthTypeWeixin;
            loginTag = kCCWeiXinLoginTag;
            break;
        default:
            break;
    }
    params[kAuthType] = authtype;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVRegisterUserAPI
                                                   params:nil];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:^(NSDictionary *successDict) {
                EVLoginInfo *loginInfo = [EVLoginInfo objectWithDictionary:successDict];
                loginInfo.loginTag = loginTag;
                loginInfo.hasLogin = YES;
                if ( successBlock )
                {
                    successBlock(loginInfo);
                }
        
                         // 注册IM账号检查是否需要登录
                [app_delegate_engine checkIMInfoWithLoginInfo:loginInfo];
    } sessionExpireBlock:^{
        
    } fail:^(NSError *error) {
        NSDictionary *dict = error.userInfo;
        if (dict) {
            if ([dict[kRetvalKye] isEqualToString:@"E_USER_NOT_EXISTS"]) {
                        EVLoginInfo *loginInfo = [[EVLoginInfo alloc] init];
                        loginInfo.authtype = authtype;
                        loginInfo.loginTag = loginTag;
                        EVLog(@"%@",params);
                        loginInfo.hasLogin = NO;
                
                        loginInfo.nickname = params[kNickName];
                        loginInfo.logourl = params[kLogourl];
                        loginInfo.gender = params[kGender];
                        loginInfo.birthday = params[kBirthday];
                        loginInfo.location = params[kLocation];
                        NSString *access_token = params[kAccess_token];
                        NSString *refresh_token = params[kRefresh_token];
                        NSString *expires_in = params[kExpires_in];
                        if ( access_token )
                        {
                            loginInfo.access_token = access_token;
                        }
                        if ( refresh_token )
                        {
                            loginInfo.refresh_token = refresh_token;
                        }
                        if ( expires_in )
                        {
                            loginInfo.expires_in = expires_in;
                        }
                        if (params[kUnionid])
                        {
                            loginInfo.unionid = params[kUnionid];
                        }
                        loginInfo.token = params[kToken];
                        loginInfo.signature = params[kSignature];
                        if ( successBlock )
                        {
                            successBlock(loginInfo);
                        }
            }
        }
    }];

}

// http://115.29.109.121/mediawiki/index.php?title=Userresetpassword
- (void)GETUserResetPassword:(NSString *)password
                       phone:(NSString *)phone
                       start:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(BOOL success))successBlock
{
    if ( password == nil )
    {
        if ( failBlock )
        {
            failBlock(nil);
        }
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPhone] = phone;
    [params setValue:[password md5String] forKey:kPassword];
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoResetPwdAPI
                                                   params:params];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            successBlock(YES);
        }
    } sessionExpireBlock:nil fail:failBlock];
 }



@end
