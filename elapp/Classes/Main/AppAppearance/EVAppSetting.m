//
//  EVAppSetting.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoginInfo.h"


#define kNormarlFontName        @"BTGotham"

NSString *const EVAppSettingVersionDidChangedNotification = @"EVAppSettingVersionDidChangedNotification";
NSString *const EVAppSettingChangeKey = @"EVAppSettingChangeKey";
NSString * const NotifyOfLogout = @"NotifyOfLogout";
NSString * const NotifyOfLogin = @"NotifyOfLogin";


@interface EVAppSetting ()
{
    NSString *_appVersion;
    
#ifdef STARTE_SWITCH_SERVER_MANUAL
    NSArray *_serverURLStrings;
    NSArray *_serverAgentStates;
    NSArray *_serverHTTPSURLStrings;
#endif
    
}

@end

@implementation EVAppSetting

+ (instancetype)shareInstance
{
    static EVAppSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.version = EVAppSettingVersion_2_0_1;
        _normalFontFamilyName = kNormarlFontName;
                
#ifdef STARTE_SWITCH_SERVER_MANUAL
        _serverAgentStates = @[
                              EVURL_STATTE_DEV,
                              EVURL_STATTE_RELEASE
                              ];
        _serverURLStrings = @[
                               EVURL_DEV,
                               EVURL_RELEASE
                               ];
        _serverHTTPSURLStrings = @[
                                   EVURL_HTTPS_DEV,
                                   EVURL_HTTPS_RELEASE
                                   ];
#endif
    }
    return self;
}

#pragma mark - 手动切换服务器配置
#ifdef STARTE_SWITCH_SERVER_MANUAL
- (NSString *)serverURLString
{
    return [_serverURLStrings[_serverState] mutableCopy];
}

- (NSString *)serverAGENT
{
    return [_serverAgentStates[_serverState] mutableCopy];
}

- (NSString *)httpsServerUrlString
{
    return [_serverHTTPSURLStrings[_serverState] mutableCopy];
}
#endif

- (void)createCacheAppFolder
{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:FOLDERPATH] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:FOLDERPATH withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (NSString *)appCacheFilePath
{
    [self createCacheAppFolder];
    return FOLDERPATH;
}

- (UIImage *)appIcon
{
    if ( _appIcon == nil )
    {
        _appIcon = [UIImage imageNamed:@"shareIcon"];
    }
    return _appIcon;
}

- (void)setVersion:(EVAppSettingVersion)version
{
    _version = version;
    switch ( _version )
    {
        case EVAppSettingVersion_2_0_0:
            _appMainColorString = @"#9AC9FF";
            break;
        case EVAppSettingVersion_2_0_1:

            _appMainColorString = @"#00dab8";

            break;
        default:
            break;
    }
}

+ (void)broadcastAppMainColorChage{
    [self broadcastAppStyleChangeWith:EVAppStyleChangeMainColor];
}

+ (void)broadcastAppMainFontStyleChage
{
    [self broadcastAppStyleChangeWith:EVAppStyleChangeFontFamilyName];
}

+ (void)broadcastAppStyleChangeWith:(EVAppStyleChangeState)state
{
    [EVNotificationCenter postNotificationName:EVAppSettingVersionDidChangedNotification object:@{EVAppSettingChangeKey: @(state)}];
}

- (NSString *)defaultLiveTitle
{
    NSString *title = [NSString stringWithFormat:@"%@%@",[EVLoginInfo localObject].nickname, kE_GlobalZH(@"living_enter_watch")];
    return title;
}

+ (NSString *)defaultLiveTitleWithMode:(BOOL)audioOnly
{
    NSString *nickName = [EVLoginInfo localObject].nickname;
    if (  audioOnly )
    {
        return [NSString stringWithFormat:@"%@%@", nickName, kE_GlobalZH(@"living_enter_watch")];
    }
    
    return [self liveTitleWithNickName:nickName CurrentTitle:nil isLive:YES];
}

////直播跟录播的标题状态 传一个值进来区分直播录播
+ (NSString *)liveTitleWithNickName:(NSString *)nickName
                       CurrentTitle:(NSString *)title
                             isLive:(BOOL)isLive
{
    if ( title )
    {
        return title;
    }
    
    NSString *defaltLivingTitle = [NSString stringWithFormat:@"%@%@",nickName, kE_GlobalZH(@"living_enter_watch")];
    
    if ( !isLive )
    {
        defaltLivingTitle = [NSString stringWithFormat:@"%@%@", nickName,kE_GlobalZH(@"bring_you_fly")];
    }
    
    return defaltLivingTitle;
}

- (NSString *)appVersion
{
    if ( _appVersion )
    {
        return _appVersion;
    }
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

#ifdef STARTE_SWITCH_SERVER_MANUAL
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    bundleVersion = [NSString stringWithFormat:@"%@_%@", bundleVersion, [fmt stringFromDate:[NSDate date]]];
#endif
    
    _appVersion = bundleVersion;
    return _appVersion;
}

- (UIFont *)normalFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.normalFontFamilyName size:size];
}


- (UIFont *)systemBoldFontWithSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}

- (UIFont *) systemFontOfSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}




@end
