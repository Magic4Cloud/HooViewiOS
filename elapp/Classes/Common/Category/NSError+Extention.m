//
//  NSError+Extention.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSError+Extention.h"
#import "NSString+Extension.h"
#import "NSDictionary+JSON.h"

@implementation NSError (Extention)

- (NSString *)errorInfoWithPlacehold:(NSString *)placeholderInfo
{
#ifdef EVDEBUG
    NSAssert(self != nil, @"error info cannot be nil");
#endif
    NSDictionary *userInfo = self.userInfo;
    NSString *errorinfo = userInfo[kRetErr];
    
    if ([userInfo[kRetvalKye] isEqualToString:kE_SERVER]) {
        return kE_GlobalZH(@"network_busy");
    }
    else if ([errorinfo isNotEmpty])
    {
        return errorinfo;
    }
    return placeholderInfo;
}

+ (instancetype)cc_errorWithDictionary:(NSDictionary *)info
{
    NSDictionary *dictionary = nil;
    NSString *errorStr = nil;
    if ( (errorStr = [info cc_objectWithKey:kRetErr]) && errorStr.length )
    {
        dictionary = info;
    }
    else
    {
        dictionary = [self cc_errorDictionaryWithInfo:info];
    }
    
    NSError *error = [self errorWithDomain:kBaseToolDomain code:kBaseToolErrorCode userInfo:dictionary];
    return error;
}

+ (NSDictionary *)cc_errorDictionaryWithInfo:(NSDictionary *)info
{
    NSString *errorKey = [info cc_objectWithKey:kRetvalKye];
    
    if ( [errorKey isEqualToString:kE_USER_NOT_EXISTS] )
    {
        errorKey = kE_GlobalZH(@"user_not_exist");
    }
    else if ( [errorKey isEqualToString:kE_Auth] )
    {
        errorKey = kE_GlobalZH(@"warrant_fail");
    }
    else if ( [errorKey isEqualToString:kE_VIDEO_NOT_EXISTS] )
    {
        errorKey = kE_GlobalZH(@"video_delete");
    }
    else if ( [errorKey isEqualToString:kE_VIDEO_PERM] )
    {
        errorKey = kE_GlobalZH(@"not_watch_video");
    }
    else if ( [errorKey isEqualToString:kE_VIDEO_WRONG_PASSWORD] )
    {
        errorKey = kE_GlobalZH(@"living_password_error");
    }
    else if ([errorKey isEqualToString:kE_AUTH_MERGE_CONFILICTS])
    {
        errorKey = kE_GlobalZH(@"merge_conflict");
    }
    else if ([errorKey isEqualToString:kE_VIDEO_NOT_EXISTS])
    {
        errorKey = kE_GlobalZH(@"video_no_have");
    }
    else if ([errorKey isEqualToString:kE_VIDEO_PERM])
    {
        errorKey = kE_GlobalZH(@"video_no_operate_purview");
    }
    else if ([errorKey isEqualToString:kE_SMS_SERVICE])
    {
        errorKey = kE_GlobalZH(@"SMS_serve_abnormal");
    }
    else if ([errorKey isEqualToString:kE_USER_EXISTS])
    {
        errorKey = kE_GlobalZH(@"user_exist");
    }
    else if ([errorKey isEqualToString:kE_SMS_INTERVAL])
    {
        errorKey = kE_GlobalZH(@"send_time_short");
    }
    else if ([errorKey isEqualToString:kE_SERVICE])
    {
        errorKey = kE_GlobalZH(@"network_busy");
    }
    else if ([errorKey isEqualToString:kE_RECHARGE_OPTION])
    {
        errorKey = kE_GlobalZH(@"recharge_selection_fail");
    }
    else if ([errorKey isEqualToString:kE_RICEROLL_NOT_ENOUGH])
    {
        errorKey = kE_GlobalZH(@"fanpiao_num_no");
    }
    else if ([errorKey isEqualToString:kE_SIGNIN_REPEAT])
    {
        errorKey = kE_GlobalZH(@"sign_in_tomorrow_come");
    }
    else if ([errorKey isEqualToString:kE_ECOIN_NOT_ENOUGH])
    {
        errorKey = kE_GlobalZH(@"nil_coin");
    }
    else if ( [errorKey isEqualToString:kE_PAY_ECOIN_NOT_ENOUGH])
    {
        errorKey = kE_GlobalZH(@"nil_coin");
    }
    else if ( [errorKey isEqualToString:kE_COLLECT_EXISTS])
    {
        errorKey = @"重复添加";
    }
    else
    {
        errorKey = nil;
    }
    
    if ( errorKey == nil )
    {
        return nil;
    }
    return @{kRetErr : errorKey};
}

@end
