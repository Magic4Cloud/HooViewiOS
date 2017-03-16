//
//  EVOpenURLManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVOpenURLManager.h"
#import "AppDelegate.h"
#import "UIViewController+Extension.h"
#import "NSString+Extension.h"
#import "EVWatchVideoInfo.h"
#import "EVLiveViewController.h"
#import "EVAlertManager.h"
#import "UIWindow+Extension.h"
#import "EVDetailWebViewController.h"

static EVOpenURLManager *_openURLManager;

@implementation EVOpenURLManager

#pragma mark - class or instance methods 

+ (instancetype)shareInstance {
    if (!_openURLManager)
    {
        _openURLManager = [[EVOpenURLManager alloc] init];
    }
    return _openURLManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _openURLManager = [super allocWithZone:zone];
    });
    return _openURLManager;
    
}


- (BOOL)openUrl:(NSURL *)url
{
    NSString *prefix = [NSString stringWithFormat:@"%@://",CCAppScheme];
    if ( [url.absoluteString hasPrefix:prefix] )
    {
        NSRange range = [url.absoluteString rangeOfString:prefix];
        NSArray *subPrefixes = [[url.absoluteString substringFromIndex:range.length] componentsSeparatedByString:@"?"];
        if ( [subPrefixes[0] isEqualToString:@"video"] )
        {
            subPrefixes = [subPrefixes[1] componentsSeparatedByString:@"&"];
            [self switchToWatchPageWithVid:subPrefixes];
        }
        else if ( [subPrefixes[0] isEqualToString:@"usersearch"] )
        {
            range = [subPrefixes[1] rangeOfString:@"keyword="];
            if ( range.length == 0 )
            {
                return NO;
            }
            NSString *keyWord = [subPrefixes[1] substringFromIndex:range.length];
            [self switchToSearchPageWithSearchKeyWords:keyWord];
        }
        else if ( [subPrefixes[0] isEqualToString:@"notice"] )
        {
            range = [subPrefixes[1] rangeOfString:@"nid="];
            if ( range.length == 0 )
            {
                return NO;
            }
            
        }
        else if ( [subPrefixes[0] isEqualToString:@"activity"] )
        {
            range = [subPrefixes[1] rangeOfString:@"activity_id="];
            if ( range.length == 0 )
            {
                return NO;
            }
            NSString *activity_id = [subPrefixes[1] substringFromIndex:range.length];
            [self switchToActivityPageWithActivityId:activity_id];
        }
        else if ([subPrefixes[0] isEqualToString:@"joinIn"]) // 活动中我要参赛
        {
            range = [subPrefixes[1] rangeOfString:@"activity_id="];
            if ( range.length == 0 )
            {
                return NO;
            }
            NSString *activity_id = [subPrefixes[1] substringFromIndex:range.length];
            [self switchToLiveWithActivityId:activity_id];
        }
        
        return YES;
    }
    return NO;
}

- (void)switchToSearchPageWithSearchKeyWords:(NSString *)keyWords
{
    [EVNotificationCenter postNotificationName:CCNeedToForceCloseLivePageOrWatchPage object:nil];
    
//    CCFindFriendViewController *findFriendVC = [[CCFindFriendViewController alloc] init];
//    findFriendVC.searchKeyWordsFromWeb = keyWords;
//    findFriendVC.isFromWeb = YES;
//    findFriendVC.hidesBottomBarWhenPushed = YES;
//    [((AppDelegate *)([UIApplication sharedApplication].delegate)) setUpHomeController];
//    UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//    if (![tabVC isKindOfClass:[UITabBarController class]] || tabVC.viewControllers.count < 3)
//    {
//        return;
//    }
//    tabVC.selectedIndex = 3;
//    UINavigationController *nav = tabVC.viewControllers[3];
//    [nav pushViewController:findFriendVC animated:YES];
}

- (void)switchToLiveWithActivityId:(NSString *)activityId
{
    UIViewController *presenetVC = [((AppDelegate *)[UIApplication sharedApplication].delegate).window visibleViewController];
    if ([presenetVC isKindOfClass:[EVDetailWebViewController class]])
    {
        EVDetailWebViewController *webVC = (EVDetailWebViewController *)presenetVC;
        [webVC startLiveWithActivityId:activityId];
    }
}

- (void)switchToWatchPageWithVid:(NSArray *)params
{
    // 处理正在观看视频/正在直播的情况
    __block UIViewController *presenetVC = [((AppDelegate *)[UIApplication sharedApplication].delegate).window visibleViewController];
    if (!presenetVC)
    {
        return;
    }
    
    if ( [presenetVC isKindOfClass:[EVLiveViewController class]] )
    {
        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"quit_living_again_click_url") comfirmTitle:kOK WithComfirm:^{
            
        }];
        return;
    }
    
    NSString *vid = nil;
    NSString *username = nil;
    NSString *nickname = nil;
    NSString *password = nil;
    for (NSString *item in params)
    {
        if ( [item cc_containString:@"vid="] )
        {
            vid = [item substringFromIndex:4];
        }
        else if ( [item cc_containString:@"username="] )
        {
            username = [item substringFromIndex:9];
        }
        else if ( [item cc_containString:@"nickname="] )
        {
            nickname = [item substringFromIndex:9];
        }
        else if ([item cc_containString:@"password="])
        {
            password = [item substringFromIndex:9];
        }
    }
    if (!vid)
    {
        return;
    }
    EVWatchVideoInfo *videoInfo = [[EVWatchVideoInfo alloc] init];
    videoInfo.vid = vid;
    videoInfo.password = password;
    videoInfo.name = username;
    videoInfo.nickname = nickname;
    [presenetVC playVideoWithVideoInfo:videoInfo permission:EVLivePermissionSquare];
}

/**
 *  跳转活动详情页面
 *
 *  @param activity_id
 */
- (void)switchToActivityPageWithActivityId:(NSString *)activity_id
{
    //EVHomeViewController *homeVC = ((AppDelegate *)[UIApplication sharedApplication].delegate).homeVC;
}



@end
