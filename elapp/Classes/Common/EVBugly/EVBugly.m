//
//  EVBugly.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBugly.h"
#import <Bugly/Bugly.h>
#import "EVLoginInfo.h"

@implementation EVBugly

+ (void)registerBugly
{
    BuglyConfig *config = [[BuglyConfig alloc] init];
#if defined(CCDEBUG)
    assert([NSThread mainThread]);
    config.reportLogLevel = BuglyLogLevelSilent;
    NSString *version = [NSString stringWithFormat:@"%@_dev", CCAppVersion];
    [Bugly updateAppVersion:version];
#else
    config.reportLogLevel = BuglyLogLevelWarn;
#endif
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ( loginInfo && [loginInfo.name isKindOfClass:[NSString class]]  )
    {
        [Bugly setUserIdentifier:loginInfo.name];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Bugly startWithAppId:BUGLY_APP_ID config:config];
    });
}

+ (void)setUserId:(NSString *)userid
{
    [Bugly setUserIdentifier:userid];
}

@end
