//
//  EVSDKInitManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVSDKInitManager.h"
#import "EVSDKManager.h"

@implementation EVSDKInitManager
//初始化聊天服务器   用户登录后的系统账号
+ (void)initMessageSDKUserData:(NSString *)userName {
    EVLog(@"app_key--- %@ ----- secret_key ----- %@ ----- access_key ------- %@  ============  %@ username",EV_APP_KEY,EV_SECRET_KEY,EV_ACCESS_KEY,userName);
    [EVSDKManager initSDKWithAppID:EV_APP_KEY appKey:EV_ACCESS_KEY appSecret:EV_SECRET_KEY userID:userName];
}
@end
