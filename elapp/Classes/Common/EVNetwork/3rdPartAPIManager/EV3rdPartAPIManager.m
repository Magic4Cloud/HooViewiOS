//
//  EV3rdPartAPIManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EV3rdPartAPIManager.h"
#import "constants.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "EVNetWorkManager.h"
#import <AFNetworking.h>


NSString *const kErrorInfo = @"kErrorInfo";

NSString *const kUserRequestFail = @"kUserRequestFail";

NSString *const kWeiBoAuthCancel = @"kWeiBoAuthCancel";
NSString *const kWeiBoAuthDeny = @"kWeiBoAuthDeny";
NSString *const kWeiBoAuthFail = @"kWeiBoAuthFail";

NSString *const kWeixinAuthFail = @"kWeixinAuthFail";
NSString *const kWeiXinAuthCancel = @"kWeiBoAuthCancel";
NSString *const kWeiXinPayCancel = @"kWeiXinPayCancel";
NSString *const kWeiXinPayFailed = @"kWeiXinPayFailed";

NSString *const kQQAuthFail = @"kQQAuthFail";
NSString *const kQQAuthCancel = @"kQQAuthCancel";
NSString *const kQQAuthNoNetWork = @"kQQAuthNoNetWork";

NSString *const k_WeiBo_ExpireInKey = @"k_WeiBo_ExpireInKey";
NSString *const k_WeiXin_ExpireInKey = @"k_WeiXin_ExpireInKey";
NSString *const k_QQ_ExpireInKey = @"k_QQ_ExpireInKey";

NSString *const k_AccessToken_WeiBo_Key = @"k_AccessToken_WeiBo_Key";
NSString *const k_AccessToken_WeiXin_Key = @"k_AccessToken_WeiXin_Key";
NSString *const k_AccessToken_QQ_Key = @"k_AccessToken_QQ_Key";


#define WeiXinAuthURLStringWithCode(code) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WEIXIN_APP_KEY, WEIXIN_SECRET_KEY, code]

@interface EV3rdPartAPIManager ()<WeiboSDKDelegate,WXApiDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic,strong) AFURLSessionManager *sessionManager;

@end

@implementation EV3rdPartAPIManager
#pragma mark - ***********         Init💧         ***********
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static EV3rdPartAPIManager *instance;
    dispatch_once( &onceToken, ^{
        instance = [[EV3rdPartAPIManager alloc] init];
    } );
    
    return instance;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _sessionManager = [[AFURLSessionManager alloc] init];
    }
    return self;
}

#pragma mark - 授权相关 >>>>
#pragma mark 回调处理
- (void)qqSuccess:(NSDictionary *)dic {
    if (self.qqLoginSuccess) {
        self.qqLoginSuccess(dic);
    }
}
- (void)qqFailure:(NSDictionary *)dic {
    if (self.qqLoginFailure) {
        self.qqLoginFailure(dic);
    }
}
- (void)sinaSuccess:(NSDictionary *)dic {
    if (self.sinaLoginSuccess) {
        self.sinaLoginSuccess(dic);
    }
}
- (void)sinaFailure:(NSDictionary *)dic {
    if (self.sinaLoginFailure) {
        self.sinaLoginFailure(dic);
    }
}
- (void)wechatSuccess:(NSDictionary *)dic {
    if (self.wechatLoginSuccess) {
        self.wechatLoginSuccess(dic);
    }
}
- (void)wechatFailure:(NSDictionary *)dic {
    if (self.wechatLoginFailure) {
        self.wechatLoginFailure(dic);
    }
}
- (void)wechatPaySucc:(NSDictionary *)dic {
    if (self.payWechatSuccess) {
        self.payWechatSuccess(dic);
    }
}
- (void)wechatPayFail:(NSDictionary *)dic {
    if (self.payWechatFailure) {
        self.payWechatFailure(dic);
    }
}

#pragma mark -  3rd regist
- (void)registForAppWeiXinKey:(NSString *)weiXinKey weiBoKey:(NSString *)weiBoKey QQkey:(NSString *)QQKey
{
    if (weiXinKey != nil && ![weiXinKey isEqualToString:@""]) {
        [WXApi registerApp:weiXinKey withDescription:@"com.hooview.app"];
    }
    
    if (weiBoKey != nil && ![weiBoKey isEqualToString:@""]) {
        [WeiboSDK registerApp:weiBoKey];
    }
    
    if (QQKey != nil && ![QQKey isEqualToString:@""]) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:self];
    }
    
#ifdef CCDEBUG
    [WeiboSDK enableDebugMode:NO];
#endif
    
}


- (BOOL)handleURL:(NSURL *)url
{
    switch ( self.authType )
    {
        case EVShareManagerAuthWeibo:
            return [WeiboSDK handleOpenURL:url delegate:self];
            break;
        case EVShareManagerAuthWeixin:
        case EVPayManagerAuthWeixin:
            return [WXApi handleOpenURL:url delegate:self];
            break;
        case EVShareManagerAuthTecent:
            return [TencentOAuth HandleOpenURL:url];
            break;
        default:
            break;
    }
    return NO;
}

#pragma mark - QQ wechat weibo
- (void)qqLogin
{
    self.authType = EVShareManagerAuthTecent;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
  
}


- (void)weiboLogin
{
    self.authType = EVShareManagerAuthWeibo;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WEIBO_APP_RE_DIRECT_URI;
    request.scope = @"follow_app_official_microblog";
    if ( ![WeiboSDK sendRequest:request] )
    {
        CCLog(@"weiboLogin - %@", request.sdkVersion);
    }
}

- (void)weixinLoginWithViewController:(UIViewController *)viewController
{
    
    self.authType = EVShareManagerAuthWeixin;
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"com.hooview.app";
    req.openID = WEIXIN_APP_KEY;
    
    [WXApi sendAuthReq:req
        viewController:viewController
              delegate:self];
}

- (void)getQQUserInfo:(EVThirdPartUserInfo *)userInfo success:(void(^)(EVThirdPartUserInfo *userInfo))successBlock fail:(void(^)(NSError *error))failBlock{
    NSAssert(userInfo.access_token && userInfo.openID , @"user info can not be nil");
    NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@&oauth_consumer_key=%@&openid=%@", QQBaseURL, userInfo.access_token, QQ_APP_ID, userInfo.openID];
    [[EVNetWorkManager shareInstance] requestWithURLString:urlString start:nil success:^(NSData *data) {
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if ( successBlock == nil ) {
            return ;
        }
        userInfo.dname = info[@"nickname"];
        userInfo.logourl = info[@"figureurl_qq_2"];
        successBlock(userInfo);
    } fail:^(NSError *error) {
        if ( failBlock ) {
            failBlock(error);
        }
    }];
}


#pragma mark - QQ - TencentSessionDelegate
- (void)tencentDidLogin
{
    if ( self.authType == EVShareManagerAuthTecent ) {
        self.authType = EVShareManagerAuthNone;
    }
    [self.tencentOAuth getUserInfo];
    if ( self.tencentOAuth.accessToken.length != 0 && self.tencentOAuth.openId.length != 0 ) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[@"accessToken"] = self.tencentOAuth.accessToken;
        info[@"expires_in"] = @([self.tencentOAuth.expirationDate timeIntervalSinceNow]);
        info[@"openId"] = self.tencentOAuth.openId;
        [self persistentToken:self.tencentOAuth.accessToken withExpireIn:[NSString stringWithFormat:@"%lf", [self.tencentOAuth.expirationDate timeIntervalSince1970]] withType:EVShareManagerAuthTecent];
        [self qqSuccess:info];

    } else {
         [self qqFailure:@{kErrorInfo : kQQAuthFail}];
 
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if ( self.authType == EVShareManagerAuthTecent ) {
        self.authType = EVShareManagerAuthNone;
    }
    NSString *info = kQQAuthCancel;
    if ( !cancelled ) {
        info = kQQAuthFail;
    }
    [self qqFailure:@{kErrorInfo : info}];
    
}

- (void)tencentDidNotNetWork{
    if ( self.authType == EVShareManagerAuthTecent ) {
        self.authType = EVShareManagerAuthNone;
    }
    [self qqFailure:@{kErrorInfo : kQQAuthNoNetWork}];
}

//--------------   weibo ----------------------------//
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ( [EV3rdPartAPIManager sharedManager].authType == EVShareManagerAuthWeibo ) {
        [EV3rdPartAPIManager sharedManager].authType = EVShareManagerAuthNone;
        NSString *token = response.userInfo[@"access_token"];
        if ( token ) {
            NSTimeInterval expirein = [[NSDate date] timeIntervalSince1970] + [response.userInfo[@"expires_in"] doubleValue];
            NSString *expireInStr = [NSString stringWithFormat:@"%lf",expirein];
            [self persistentToken:token withExpireIn:expireInStr withType:EVShareManagerAuthWeibo];
            
            // 微博回调成功
            [self sinaSuccess:response.userInfo];
            
            return;
        }
        if ( response.userInfo[@"sso_error_user_cancelled"] ) {
            // 微博回调失败
            [self sinaFailure:@{kErrorInfo : kWeiBoAuthCancel}];
            
            return;
        }
        if ( response.statusCode == WeiboSDKResponseStatusCodeAuthDeny ) {
            
            // 微博回调失败
            [self sinaFailure:@{kErrorInfo : kWeiBoAuthDeny}];
            
        }
    }
}

#pragma mark - weixin WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    CCLog(@"-----");
}


-(void)onResp:(BaseResp*)resp
{
    if ( self.authType == EVShareManagerAuthWeixin ) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            if (resp.errCode == WXSuccess) {
                
                SendAuthResp *respWeixin = (SendAuthResp*)resp;
                NSString *code = respWeixin.code;
                NSString *urlString = WeiXinAuthURLStringWithCode(code);
                
                [[EVNetWorkManager shareInstance] requestWithURLString:urlString start:nil success:^(NSData *data) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    
                    if ( info[@"openid"] ) {
                        NSTimeInterval expirein = [[NSDate date] timeIntervalSince1970] + [info[@"expires_in"] doubleValue];
                        [NSString stringWithFormat:@"%lf",expirein];
                        [self persistentToken:info[@"access_token"] withExpireIn:[NSString stringWithFormat:@"%lf",expirein] withType:EVShareManagerAuthWeixin];
                        
                         [self wechatSuccess:info];
                    } else {
                        [self wechatFailure:@{kErrorInfo : kWeixinAuthFail}];
                        
                    }
                    
                }fail:^(NSError *error) {
                     [self wechatFailure:@{kErrorInfo : kWeixinAuthFail}];
                    CCLog(@"weixin auth request fail - %@",error);

                }];
                
            }else{
                [self wechatFailure:@{kErrorInfo : kWeiXinAuthCancel}];
                CCLog(@"wxlogin fail------");
            }
        }
    }else if ( [EV3rdPartAPIManager sharedManager].authType == EVPayManagerAuthWeixin ) {
        
        if([resp isKindOfClass:[PayResp class]]) {
            //支付返回结果，实际支付结果需要去微信服务器端查询
            switch (resp.errCode)
            {
                case WXSuccess:
                {
                    CCLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                    [self wechatPaySucc:nil];
                    [CCNotificationCenter postNotificationName:WeixinPaySuccessNotification  object:nil userInfo:nil];
                }
                    break;
                    
                case WXErrCodeUserCancel:
                {
                    CCLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                    [CCNotificationCenter postNotificationName:WeixinPayFailedNotification  object:nil userInfo:@{kErrorInfo:kWeiXinPayCancel}];
                    
                     [self wechatPayFail:@{kErrorInfo : kWeiXinPayFailed}];
                }
                    break;
                    
                case WXErrCodeCommon:
                case WXErrCodeSentFail:
                case WXErrCodeAuthDeny:
                case WXErrCodeUnsupport:
                default:
                {
                    CCLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                    [CCNotificationCenter postNotificationName:WeixinPayFailedNotification object:nil userInfo:@{kErrorInfo:kWeiXinPayFailed}];
                     [self wechatPayFail:@{kErrorInfo : kWeiXinPayFailed}];
                }
                    break;
            }
        }
    }
}


#pragma mark - ***********      Actions 🌠        ***********
- (void)handleLoginInfo:(EVThirdPartUserInfo *)userInfo info:(NSDictionary *)info success:(void(^)(EVThirdPartUserInfo *userInfo))successBlock
{
    switch ( userInfo.type )
    {
        case EVThirdPartUserInfoQQ:
        {
            userInfo.dname = info[@"nickname"];
            userInfo.logourl = info[@"figureurl_qq_2"];
            userInfo.location = [NSString stringWithFormat:@"%@ %@",info[@"province"],info[@"city"]];
            
            if ( ![info[@"year"] isKindOfClass:[NSNull class]]  ) {
                userInfo.birthday = [NSString stringWithFormat:@"%@-01-01",info[@"year"]];
            }
            if ( ![info[@"gender"] isKindOfClass:[NSNull class]] ) {
                userInfo.gender = [info[@"gender"] isEqualToString:kE_GlobalZH(@"e_male")] ? @"male" : @"female";
            }
            
        }
            break;
        case EVThirdPartUserInfoSina:
        {
            userInfo.dname = info[@"screen_name"];
            userInfo.logourl = info[@"avatar_hd"];
            userInfo.location = info[@"location"];
            userInfo.signature = info[@"description"];
            NSString *gender = nil;
            if ( ![info[@"gender"] isKindOfClass:[NSNull class]] ) {
                if ( [info[@"gender"] isEqualToString:@"m"] ) {
                    gender = @"male";
                } else if ( [info[@"gender"] isEqualToString:@"f"] ) {
                    gender = @"female";
                }
                userInfo.gender = gender;
            }
            
        }
            break;
        case EVThirdPartUserInfoWeixin:
        {
            userInfo.dname = info[@"nickname"];
            userInfo.logourl = info[@"headimgurl"];
            NSString *gender = nil;
            if ( [info[@"sex"] integerValue] == 1 ) {
                gender = @"male";
            } else {
                gender = @"female";
            }
            userInfo.gender = gender;
            userInfo.unionid = info[@"unionid"];
        }
            break;
            
        default:
            break;
    }
    if ( successBlock ) {
        successBlock(userInfo);
    }
    
}

- (void)getTirdPartUserInfo:(EVThirdPartUserInfo *)userInfo start:(void(^)())startBlock
                    success:(void(^)(EVThirdPartUserInfo *userInfo))successBlock
                       fail:(void(^)(NSError *error))failBlock {
    NSAssert(userInfo.access_token , @"user info can not be nil");
    NSString *urlString = nil;
    
    switch ( userInfo.type )
    {
        case EVThirdPartUserInfoQQ:
            NSAssert(userInfo.access_token.length && userInfo.openID .length, @"access_token open_id nil");
            urlString = [NSString stringWithFormat:@"%@?access_token=%@&oauth_consumer_key=%@&openid=%@", QQBaseURL, userInfo.access_token, QQ_APP_ID, userInfo.openID];
            break;
        case EVThirdPartUserInfoSina:
            NSAssert(userInfo.access_token.length && userInfo.uid .length, @"access_token uid nil");
            urlString = [NSString stringWithFormat:@"%@?source=%@&access_token=%@&uid=%@", WeiboBaseURL, WEIBO_APP_KEY, userInfo.access_token, userInfo.uid];
            break;
        case EVThirdPartUserInfoWeixin:
            NSAssert(userInfo.access_token.length && userInfo.openID .length, @"access_token open_id nil");
            urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", userInfo.access_token, userInfo.openID];
            break;
        default:
            break;
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[EVNetWorkManager shareInstance] requestWithURLString:urlString start:startBlock success:^(NSData *data) {
        if ( data ) {
            if ( successBlock ) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                [self handleLoginInfo:userInfo info:info success:successBlock];
            }
        }else if ( failBlock ){
            
            failBlock(nil);
            
        } else {
            
        }
        } fail:^(NSError *error) {
            if ( failBlock ) {
                failBlock(error);
            }

    }];
    
    return;
}

#pragma mark - cache
- (void)persistentToken:(NSString *)token withExpireIn:(NSString *)expireIn withType:(EVShareManagerAuthType)type
{
    NSString *expireInKey = nil;
    NSString *key = nil;
    switch ( type ) {
        case EVShareManagerAuthWeibo:
            expireInKey = k_WeiBo_ExpireInKey;
            key = k_AccessToken_WeiBo_Key;
            break;
        case EVShareManagerAuthWeixin:
            expireInKey = k_WeiXin_ExpireInKey;
            key = k_AccessToken_WeiXin_Key;
            break;
        case EVShareManagerAuthTecent:
            expireInKey = k_QQ_ExpireInKey;
            key = k_AccessToken_QQ_Key;
            break;
        default:
            break;
    }
    [CCUserDefault setObject:token forKey:key];
    [CCUserDefault setObject:expireIn forKey:expireInKey];
    [CCUserDefault synchronize];
}
@end

@implementation EVThirdPartUserInfo

- (NSMutableDictionary *)userLoginParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( self.dname ) {
        // params[@"dname"] = self.dname;
        params[@"nickname"] = self.dname;
    }
    if ( self.logourl ) {
        params[@"logourl"] = self.logourl;
    }
    if ( self.access_token ) {
        params[@"access_token"] = self.access_token;
    }
    if ( self.refresh_token ) {
        params[@"refresh_token"] = self.refresh_token;
    }
    if ( self.expires_in ) {
        params[@"expires_in"] = self.expires_in;
    }
    if ( self.openID ) {
        params[@"token"] = self.openID;
    }
    if ( self.uid ) {
        params[@"token"] = self.uid;
    }
    
    if ( self.birthday.length ) {
        params[@"birthday"] = self.birthday;
    }
    
    if ( self.location.length ) {
        params[@"location"] = self.location;
    } else {
        params[@"location"] = kEChina;
    }
    
    if ( self.gender.length ) {
        params[@"gender"] = self.gender;
    }
    
    // fix by 高沛荣
    if ( ![self.signature isKindOfClass:[NSNull class]] && self.signature )
    {
        params[@"signature"] = [NSString stringWithFormat:@"%@", self.signature];
    }
    
    if (self.unionid.length)
    {
        params[@"unionid"] = self.unionid;
    }
    
    return params;
}

@end
