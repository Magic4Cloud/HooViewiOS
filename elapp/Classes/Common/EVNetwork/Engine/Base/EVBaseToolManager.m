//
//  EVBaseToolManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"
#import "constants.h"
#import "EVPushManager.h"
#import "EVLoginInfo.h"
#import "OpenUDID.h"
#import "NSObject+Extension.h"
#import "EVStreamer+Extension.h"
#import  "AFHTTPSessionManager.h"
#import "EVNetWorkManager.h"


#define kSessionActionCheckAction @"/user/sessioncheck"

@interface EVBaseToolManager ()


@end


@implementation EVBaseToolManager
// 检查摄像头和麦克风
+ (BOOL)checkCameraAndMicoAuth
{
    BOOL cameraAuthed = [CCUserDefault boolForKey:kCameraAuthed];
    BOOL videoAuthed = [CCUserDefault boolForKey:kAudioAuthed];
    return (cameraAuthed && videoAuthed);
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _syschronizedCache = NO;
    }
    return self;
}

- (void)cancelAllOperation
{
    if ( _syschronizedCache )
    {
        @synchronized( self )
        {
            [self _cancelAllOperation];
        }
    }
    else
    {
        [self _cancelAllOperation];
    }
}

// 停止所有的网络请求
- (void)_cancelAllOperation
{

    
    
}

// 设置Session的检查状态
static BOOL sessioncheck = NO;
+ (void)setSessionCheck:(BOOL)check
{
    sessioncheck = check;
}

// 检查Session的有效性
+ (void)checkSessionID
{
    // 已经检查成功直接返回
    if ( sessioncheck )
    {
        return;
    }
    
    // 设置当前为没有登录
    [self setIMAccountHasLogin:NO];
    
    // 如果本地SessionID不可用,则复位Session状态并返回
    if ( [self userSessionIDFromLocal] == nil )
    {
        [self resetSession];
        return;
    }
    
    // 获取本地Session
    NSString *sessionId = [self userSessionIDFromLocal];
    
    // 生成Url校验字符串
    NSString *urlString = [NSString stringWithFormat:@"%@%@?sessionid=%@",EVVideoBaseURL,kSessionActionCheckAction,sessionId];
    
    // 发起校验请求
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:nil success:^(NSDictionary *successDict) {
        // Session信息OK
        EVLoginInfo *login = [EVLoginInfo localObject];
        if ( login.impwd.length == 0 || login.imuser.length == 0 )
        {
            // 设置为当前未登录(这句话是否多余? -- 周锋)
            [self setIMAccountHasLogin:NO];
        }
        else
        {
            // 更新登录状态
            [self imLoginWithLoginInfo:login
                               success:nil
                                  fail:nil
                         sessionExpire:nil];
            sessioncheck = YES;
        }

    } sessionExpireBlock:^{
        
            // Session信息失效
            [self resetSession];
        
    } fail:^(NSError *error) {
        // 网络失败则3秒钟之后重新尝试校验
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self checkSessionID];
                       });
    }];
}


// 检查Session有效性
+ (void)checkSession:(void(^)())start
           completet:(void(^)(BOOL expire))complete
                fail:(void(^)(NSError *error))fail
{
    // 如果本地Session为空,则无需进行检查
    if ( [self userSessionIDFromLocal] == nil )
    {
        if ( complete )
        {
            complete(YES);
        }
        return;
    }
    
    // 获取本地Session
    NSString *sessionId = [self userSessionIDFromLocal];
    
    // 生成Url校验字符串
    NSString *urlString = [NSString stringWithFormat:@"%@%@?sessionid=%@",EVVideoBaseURL,kSessionActionCheckAction,sessionId];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:nil success:^(NSDictionary *successDict) {
        // 登录成功
        if ( complete )
        {
            complete(NO);
        }
    } sessionExpireBlock:^{
        [self resetSession];
        if ( complete )
        {
            complete(YES);
        }
    } fail:^(NSError *error) {
        // 获得服务器反馈失败
        [self resetSession];
        if ( fail )
        {
            fail(error);
        }
    }];
}

// 环信账号是否登陆
+ (BOOL)imAccountHasLogin
{
    return [CCUserDefault boolForKey:kIMAccountHasLogin];
}

// 设置环信账号登陆状态
+ (void)setIMAccountHasLogin:(BOOL)login
{
    [CCUserDefault setBool:login
                    forKey:kIMAccountHasLogin];
    [CCUserDefault synchronize];
}

// 环信账号是否注册
+ (BOOL)imHasRegist
{
    return [CCUserDefault boolForKey:kIMAccountHasRegist];
}

// 设置环信账号是否注册
+ (void)setIMHasRegist:(BOOL)regist
{
    [CCUserDefault setBool:regist
                    forKey:kIMAccountHasRegist];
    [CCUserDefault synchronize];
}

// 环信账号登录
+ (void)imLoginWithLoginInfo:(EVLoginInfo *)login
                     success:(void(^)(EVLoginIMInfo *imInfo))success
                        fail:(void(^)(EMError *error))fail
               sessionExpire:(void(^)())sessionExpire
{
    //用户校验
    if ( login.imuser == nil || login.impwd == nil )
    {
        [self setIMAccountHasLogin:NO];
        return;
    }
    if ( login.imuser.length == 0 || login.impwd.length == 0 )
    {
        [self setIMAccountHasLogin:NO];
        return;
    }
    EVLog(@"---------- im login");
//    // 登录环信
//    [[EVEaseMob cc_shareInstance] loginWithUserName:login.imuser
//                                           password:login.impwd
//                                            success:^(NSDictionary *loginInfo)
//     {
//         // 登录成功
//         EVLoginIMInfo *imInfo = [EVLoginIMInfo objectWithDictionary:loginInfo];
//         login.imLoginInfo = imInfo;
//         [login synchronized];
//         if ( success )
//         {
//             success(imInfo);
//         }
//         
//         // 标记已经成功登录
//         [self setIMAccountHasLogin:YES];
//         
//         //发送已经成功登录的通知
//         [EVNotificationCenter postNotificationName:CCIMAccountHasLoginNotifcation
//                                             object:nil userInfo:nil];
//         EVLog(@"---------- imlogin success usernickname: %@      password: %@", login.imuser, login.impwd);
//     }
//                                               fail:^(EMError *error)
//     {
//         // 登录失败
//         if ( [error.description isEqualToString:kE_GlobalZH(@"already_login_common")] )
//         {
//             // 已经登录过
//             [self setIMAccountHasLogin:YES];
//             EVLog(@"---------- imlogin success usernickname: %@      password: %@", login.imuser, login.impwd);
//         }
//         else
//         {
//             [self setIMAccountHasLogin:NO];
//             if ( fail )
//             {
//                 fail(error);
//             }
//         }
//     }];
}


// 注销环信
+ (void)imLogoutUnbind:(BOOL)unbind
               success:(void(^)(NSDictionary *info))success
                  fail:(void(^)(EMError *error))fail
{
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:unbind
//                                                                completion:^(NSDictionary *info, EMError *error)
//     {
//         if ( error )
//         {
//             EVLog(@"imlogoff fail - %@", error);
//             if ( fail )
//             {
//                 fail(error);
//             }
//         }
//         else
//         {
//             EVLog(@"imlogoff success - %@", info);
//             if ( success )
//             {
//                 success(info);
//             }
//             [self setIMAccountHasLogin:NO];
//         }
//     }
//                                                                   onQueue:dispatch_get_global_queue(0, 0)];
}

// 停止指定的网络请求
- (void)cancelOperataionWithURLString:(NSString *)urlString
{
    if ( _syschronizedCache )
    {
        @synchronized( self )
        {
            [self _cancelOperataionWithURLString:urlString];
        }
    }
    else
    {
        [self _cancelOperataionWithURLString:urlString];
    }
}

- (void)_cancelOperataionWithURLString:(NSString *)urlString
{

    
}


// 删除指定的网络请求节点
- (void)removeOperationWithURLString:(NSString *)urlString
{
    if ( _syschronizedCache )
    {
        @synchronized( self )
        {
            [self _removeOperationWithURLString:urlString];
        }
    }
    else
    {
        [self _removeOperationWithURLString:urlString];
    }
}

- (void)_removeOperationWithURLString:(NSString *)urlString
{
    [self.requests removeObjectForKey:urlString];
}

// 获得当前的请求列表
- (NSMapTable *)requests
{
    if ( _requests == nil )
    {
        @synchronized( self )
        {
            if ( _requests == nil )
            {
                _requests = [NSMapTable weakToWeakObjectsMapTable];
            }
        }
    }
    return _requests;
}

// 获取本地存储的Session
+ (NSString *)userSessionIDFromLocal
{
    return [CCUserDefault objectForKey:SESSION_ID_STR];
}

// 设置本地用户名
+ (void)setUserNameToLocal:(NSString *)name
{
    
    [CCUserDefault setValue:name
                      forKey:CCUSER_NAME];
    [CCUserDefault synchronize];
    

}

// 获取本地用户名
+ (NSString *)userNameFromLocal
{
    return [CCUserDefault objectForKey:CCUSER_NAME];
}

// 用户是否已经登录
+ (BOOL)userHasLoginLogin
{
    return [self userSessionIDFromLocal] != nil;
}

// 清空本地Session
+ (void)resetSession
{
    [CCUserDefault removeObjectForKey:SESSION_ID_STR];
    [CCUserDefault setObject:nil
                      forKey:USER_DNAME_STR];
    [CCUserDefault synchronize];
    [self setIMAccountHasLogin:NO];
    
    // 到主线程中执行下面这个block中的代码
    [self performBlockOnMainThreadInClass:^
     {
         [EVNotificationCenter postNotificationName:CCSessionDidCleanFromLocalNotification
                                             object:nil
                                           userInfo:nil];
     }];
}

// 保存Session
+ (void)saveSessionId:(NSString *)sesseionId
{
    NSString *preSession = [self userSessionIDFromLocal];
    [CCUserDefault setObject:sesseionId
                      forKey:SESSION_ID_STR];
    [CCUserDefault synchronize];
    if ( ![sesseionId isEqualToString:preSession] )
    {
        [EVNotificationCenter postNotificationName:CCSessionIdDidUpdateNotification
                                            object:nil
                                          userInfo:nil];
        // 清除续播的缓存
        [EVStreamer  saveLivePrepareInfo:nil];
    }
}

// 通知登录视图关闭
+ (void)notifyLoginViewDismiss
{
    [EVNotificationCenter postNotificationName:CCLoginPageDidDissmissNotification
                                        object:nil
                                      userInfo:nil];
}

// 判断指定用户是否当前用户
+ (BOOL)isCurrUserName:(NSString *)name
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    return [loginInfo.name isEqualToString:name];
}

// 获取本地存储的用户名称
+ (NSString *)userDisPlayNameFromLocal
{
    return [CCUserDefault objectForKey:USER_DNAME_STR];
}

// 设置用户名称到本地存储
+ (void)saveUserDisPlaynameToLocal:(NSString *)dname
{
    [CCUserDefault setObject:dname
                      forKey:USER_DNAME_STR];
    [CCUserDefault synchronize];
}

// 获取本地设备ID
+ (NSString *)getDeviceId
{
    NSString *devid = [EVPushManager sharePushManager].userInfo.devid;
    if ( devid == nil )
    {
        devid = [OpenUDID value];
    }
    return devid;
}

+ (void)GETNotVerifyRequestWithUrl:(NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(NSDictionary *successDict))success fail:(nullable void(^)(NSError  * error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task =  [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EVLog(@"url:%@\nresponseObject:%@",url,responseObject);
        if (responseObject) {
            if ( [[responseObject[kRetvalKye] lowercaseString] isEqualToString:kRequestOK] )
            {
                if ( success )
                {
                    success(responseObject[kRetinfoKey]);
                }
            }else {
                fail([NSError cc_errorWithDictionary:responseObject]);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        EVLog(@"url:%@\nerror.domain:%@error.code:%d",url,error.domain,error.code);
        if (fail) {
            fail(error);
        }
    }];
    EVLog(@"------- %@",task.currentRequest);
//    [task resume];
}

+ (void)GETRequestWithUrl:(nullable NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(NSDictionary *successDict))success sessionExpireBlock:(void(^)())sessionExpireBlock fail:(nullable void(^)(NSError  * error))fail
{
    if ( parameters[@"device"] == nil )
    {
        parameters[@"device"] = @"ios";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    NSURLSessionDataTask *task =  [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if ( [responseObject[kRetvalKye] isEqualToString:kRequestOK] )
            {
                if ( success )
                {
                    success(responseObject[kRetinfoKey]);
                }
            }
            else if ( [responseObject[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
            {
                if ( sessionExpireBlock )
                {
                    sessionExpireBlock();
                }
            }else if (fail) {
                fail([NSError cc_errorWithDictionary:responseObject]);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    EVLog(@"------- %@",task.currentRequest);
    [task resume];
}

+ (void)POSTRequestWithUrl:(NSString *)url params:(id)param fileData:(NSData *)fileData fileMineType:(NSString *)fileMineType fileName:(NSString *)filename success:(void (^)(NSDictionary *successDict))success sessionExpireBlock:(void(^)())sessionExpireBlock failError:(void(^)(NSError  * error))failError
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:filename fileName:@"file.jpg" mimeType:fileMineType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success (responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failError(error);
        }
        
    }];
}

+ (void)POSTNotSessionWithUrl:(NSString *)url params:(NSDictionary *)param fileData:(NSData *)fileData fileMineType:(NSString *)fileMineType fileName:(NSString *)filename success:(void (^)(NSDictionary *successDict))success failError:(void(^)(NSError  * error))failError
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript", @"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
   NSURLSessionDataTask *task =   [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
                    success (responseObject);
                }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (error) {
                    failError(error);
                }
    }];
    EVLog(@"------- %@",task.currentRequest);
}

+ (void)GETNoSessionWithUrl:(nullable NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(NSDictionary *successDict))success fail:(nullable void(^)(NSError  * error))fail
{
    if ( parameters[@"device"] == nil )
    {
        parameters[@"device"] = @"ios";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    NSURLSessionDataTask *task =  [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            if ( success )
            {
                success(responseObject);
            }
            else if (fail)
            {
                fail([NSError cc_errorWithDictionary:responseObject]);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
    EVLog(@"--- %@",task.currentRequest);
    [task resume];
}


@end

@implementation EVBaseToolManager ( SMSVerify )

// 使用sms_id进行验证
- (void)getSmsverifyWithSmd_id:(NSString *)sms_id
sms_code:(NSString *)sms_code
start:(void(^)())startBlock
fail:(void(^)(NSError *error))failBlock
success:(void(^)())successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sms_id != nil )
    {
        params[kSms_id] = sms_id;
    }
    params[kSms_code] = sms_code;
    NSString *urlString = [self fullURLStringWithURI:EVSmsVerfyAPI  params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}

// 使用sms_id进行验证 (带认证方式)
- (void)smsverifyWithSmd_id:(NSString *)sms_id
sms_code:(NSString *)sms_code
authType:(NSString *)authType
start:(void(^)())startBlock
fail:(void(^)(NSError *error))failBlock
success:(void(^)())successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSAssert(sms_id != nil, @"sms_id cannot be nil");
    if ( sms_id != nil )
    {
        params[kSms_id] = sms_id;
    }
    params[kSms_code] = sms_code;
    params[kAuthType] = authType;
    NSString *urlString = [self fullURLStringWithURI:EVSmsVerfyAPI
                                              params:nil];
   
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}


// 根据Uri获得完整url
- (NSString *)fullURLStringWithURI:(NSString *)uriString
params:(NSMutableDictionary *)params
{
    return [self urlStringWithHost:EVVideoBaseURL
                         uriString:uriString
                            params:params];
}

// https根据Uri获得完整url
- (NSString *)httpsFullURLStringWithURI:(NSString *)uriString
params:(NSMutableDictionary *)params
{
    return [self urlStringWithHost:EVVideoBaseHTTPSURL
                         uriString:uriString
                            params:params];
}

/**
 *  拼接URL
 *
 *  @param hostString 基URL
 *  @param uriString  追加部分
 *  @param params     参数
 *
 *  @return 拼接后的URL
 */
- (NSString *)urlStringWithHost:(NSString *)hostString
uriString:(NSString *)uriString
params:(NSMutableDictionary *)params
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostString, uriString];
    if ( params[@"device"] == nil )
    {
        params[@"device"] = @"ios";
    }
    EVNetWorkRequest *request = [EVNetWorkRequest netWorkRequestURLString:urlString];
    request.getParams = params;
    urlString = request.urlString;
#ifdef EVDEBUG
    if ( [urlString hasPrefix:@"https"] )
    {
        //        EVLog(@"https---%@",urlString);
    }
    else
    {
        //        EVLog(@"---%@",urlString);
    }
#endif
    return urlString;
}
@end


@implementation EVBaseToolManager ( Common )


// 获取Session
- (NSString *)getSessionIdWithBlock:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [[self class] userSessionIDFromLocal];
    if ( sessionID == nil )
    {
        if ( sessionExpireBlock )
        {
            sessionExpireBlock();
        }
    }
    return sessionID;
}






#pragma mark - 发送get请求

// 获得推送信息字典
- (void)getPushParamsWithParams:(NSMutableDictionary *)params
{
    
    NSString *push_id    = [EVPushManager sharePushManager].userInfo.push_id;
    NSString *channel_id = [EVPushManager sharePushManager].userInfo.channel_id;
    NSString *dev_token  = [EVPushManager sharePushManager].userInfo.dev_token;
    NSString *app_id     = [EVPushManager sharePushManager].userInfo.app_id;
    
    if ( push_id )
    {
        params[@"push_id"] = push_id;
    }
    
    if ( channel_id )
    {
        params[@"channel_id"] = channel_id;
    }
    
    if ( dev_token )
    {
        params[@"dev_token"] = dev_token;
    }
    
    if ( app_id )
    {
        params[@"app_id"] = app_id;
    }
}

// 获取gps信息
- (void)getGPSInfo:(NSMutableDictionary *)params
{
    double gps_latitude = [EVPushManager sharePushManager].latitude;
    double gps_longitude = [EVPushManager sharePushManager].longitude;
    // fix by 建议使用默认值来判断
    if ( gps_latitude != invalid_latitude_longitude && gps_longitude != invalid_latitude_longitude )
    {
        params[@"gps_latitude"] = @(gps_latitude);
        params[@"gps_longitude"] = @(gps_longitude);
    }
}

// 获得推送信息字典
- (void)getPushInfo:(NSMutableDictionary *)params
{
    NSString *push_id = [EVPushManager sharePushManager].userInfo.push_id;
    NSString *channel_id = [EVPushManager sharePushManager].userInfo.channel_id;
    NSString *dev_token = [EVPushManager sharePushManager].userInfo.dev_token;
    NSString *app_id = [EVPushManager sharePushManager].userInfo.app_id;
    NSString *dev_id = [EVPushManager sharePushManager].userInfo.devid;
    if ( push_id && channel_id && dev_token && app_id &&  dev_id )
    {
        params[@"push_id"] = push_id;
        params[@"channel_id"] = channel_id;
        params[@"dev_token"] = dev_token;
        params[@"app_id"] = app_id;
        params[@"devid"] = dev_id;
    }
}





@end


@implementation EVBaseToolManager ( Notification)

// 设置消息推送的开关
+ (void)turnNotificationOff:(BOOL)off
{
    [[NSUserDefaults standardUserDefaults] setBool:off
                                            forKey:kNotificationOffKey];
}

// 获取消息推送的开关
+ (BOOL)pushNotificationIsOff
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:kNotificationOffKey] integerValue];
}

@end


