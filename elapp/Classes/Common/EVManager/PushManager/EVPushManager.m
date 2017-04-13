//
//  EVPushManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPushManager.h"
#import "constants.h"
#import <MapKit/MapKit.h>
#import "EVGeocoder.h"
#import "OpenUDID.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>


#define kAPP_KEY  [[EVAppSetting shareInstance] appPushServiceKey]

//#define kAPP_KEY  @"CtrIXAieWOjWbMF1OlNv6imD"

#define userInfoFullPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userinfo.arc"]

#define kDeviceTokenKey @"kDeviceTokenKey"
#define kUserInfoKey @"kUserInfoKey"

@interface EVPushUserInfo ()<NSCoding>

@end

@implementation EVPushUserInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if ( self = [super init] ) {
        if ( ![dict[kApp_id] isKindOfClass:[NSNull class]] )
        {
            self.app_id = dict[kApp_id];
        }
        
        if ( ![dict[kChannel_id] isKindOfClass:[NSNull class]]  )
        {
            self.channel_id = dict[kChannel_id];
        }
        
        if ( ![dict[kError_code] isKindOfClass:[NSNull class]]  )
        {
            self.error_code = [dict[kError_code] integerValue];
        }
        
        if ( ![dict[kRequest_id] isKindOfClass:[NSNull class]]  )
        {
            self.request_id = dict[kRequest_id];
        }
        
        if ( ![dict[kUser_id] isKindOfClass:[NSNull class]]  )
        {
            self.push_id = dict[kUser_id];
        }
        
#ifdef EVDEBUG
        NSAssert(self.app_id && self.channel_id, @"these two params can not be nil");
#endif
        
    }
    return self;
}

- (NSString *)devid{
    if ( _devid == nil )
    {
        _devid = [OpenUDID value];
    }
    return _devid;
}

+ (instancetype)pushUserInfoWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    EVPushUserInfo *userInfo = [[[self class] alloc] init];
    userInfo.error_code = [decoder decodeIntegerForKey:kError_code];
    userInfo.channel_id = [decoder decodeObjectForKey:kChannel_id];
    userInfo.request_id = [decoder decodeObjectForKey:kRequest_id];
    userInfo.dev_token = [decoder decodeObjectForKey:kDev_token];
    userInfo.app_id = [decoder decodeObjectForKey:kApp_id];
    if ( userInfo.devid == nil )
    {
        userInfo.devid = [decoder decodeObjectForKey:kDevid];
    }
    return userInfo;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
#ifdef EVDEBUG
    NSAssert(_dev_token, @"dev_token 不能为空");
#endif
    [encoder encodeInteger:_error_code forKey:kError_code];
    [encoder encodeObject:_channel_id forKey:kChannel_id];
    [encoder encodeObject:_request_id forKey:kRequest_id];
    
    [encoder encodeObject:_dev_token forKey:kDev_token];
    [encoder encodeObject:_app_id forKey:kApp_id];
    [encoder encodeObject:self.devid forKey:kDevid];
}

@end

@interface EVPushManager ()<CLLocationManagerDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) NSDictionary *responseData;
/** 极光推送 channelId */
@property (nonatomic ,copy) NSString *channelId;
/** 设备的 dev_token */
@property (nonatomic ,copy) NSString *dev_token;
/** 地图位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationMgr;
/** 用来标识不带  gps 的请求已经发送成功 */
@property (nonatomic, assign) BOOL deviceOnlineSending;
/** 用来标识带  gps 信心的请求已经发送成功 */
//@property (nonatomic, assign) BOOL gpsDeviceOnlineSend;
/** 用来标识此次程序启动是否向服务器注册了deviceonline */
@property (nonatomic, assign,getter= isRegistDeviceToServer ) BOOL registDeviceToServer;

@end

@implementation EVPushManager

singtonImplement(PushManager)

- (CLLocationManager *)locationMgr
{
    if ( _locationMgr == nil )
    {
        _locationMgr =  [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        // 设置精确度 (精确度越高,越耗电)
        _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置走了多少米之后重新获取新的位置
        _locationMgr.distanceFilter = 20;
    }
    return _locationMgr;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _latitude = invalid_latitude_longitude;
        _longitude = invalid_latitude_longitude;
    }
    return self;
}

- (void)resetJpushBadge
{
    [JPUSHService resetBadge];
}

- (void)setUpWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert) categories:nil];
    }
    else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    BOOL isProduction = YES;
#ifdef STATE_DEV
    isProduction = NO;
#endif
    
    _userInfo = [[EVPushUserInfo alloc] init];
    _userInfo.app_id = J_PUSH_APP_KEY;
    [JPUSHService setupWithOption:launchOptions appKey:J_PUSH_APP_KEY channel:J_PUSH_APP_CHANNEL apsForProduction:isProduction];
    [self addObserverToJPush];
    
    // 注册权限
    if ( [self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)] )
    {
        [self.locationMgr requestWhenInUseAuthorization];
    }
    
    [self.locationMgr startUpdatingLocation];
}

/** 添加激光推送的监听 */
- (void)addObserverToJPush
{
    [EVNotificationCenter addObserver:self selector:@selector(JPushDidLoginSuccess:) name:kJPFNetworkDidLoginNotification object:nil];
}


#pragma mark - JPush notification

- (void)JPushDidLoginSuccess:(NSNotification *)notification
{
    NSString *channelId = [JPUSHService registrationID];
    _channelId = [NSString stringWithFormat:@"j_%@", channelId];
    EVLog(@"---JPush notification:%@", channelId);
    
#ifdef EVDEBUG
    assert( ![J_PUSH_APP_KEY isKindOfClass:[NSNull class]] );
    assert( ![_channelId isKindOfClass:[NSNull class]] );
#endif
    if ( J_PUSH_APP_KEY && _channelId )
    {
        [self intializeUserInfo];
    }
}

- (void)setRegistDeviceToServer:(BOOL)registDeviceToServer
{
    _registDeviceToServer = registDeviceToServer;
    if ( registDeviceToServer )
    {
        [self removeNotification];
    }
}

- (void)dealloc
{
    [self removeNotification];
}

- (void)removeNotification
{
    [EVNotificationCenter removeObserver:self];
}

- (EVPushUserInfo *)userInfo
{
    if ( _userInfo == nil
        || _userInfo.channel_id == nil
        || _userInfo.app_id == nil )
    {
        _userInfo = [self userInFromLocal];
    }
    
    return _userInfo;
}

- (void)bindWithDeviceToken:(NSData *)token_data
{
    // repeat = 1
    _dev_token = [token_data.description substringWithRange:NSMakeRange(1, token_data.description.length - 2)];
    // 去掉空格
    _dev_token = [_dev_token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 缓存dev_token
    [CCUserDefault setObject:_dev_token forKey:kEVDeviceTokenKey];
    [JPUSHService registerDeviceToken:token_data];
}

- (void)handleWithUserInfo:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

- (BOOL)gpsAuth
{
    return [CCUserDefault boolForKey:kUserLocationServiceEnableTagKey];
}

- (void)registUserInfoToServer
{
#ifdef EVDEBUG
    NSAssert(_userInfo, @"获取用户数据失败");
#endif
    if ( self.userInfo == nil
        || _registDeviceToServer
        || _deviceOnlineSending ) return;
    
}


- (NSMutableDictionary *)deviceOnlineParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kDeviceKey] = kDeviceValue;
    
    if ( _userInfo.channel_id )
    {
        params[kChannel_id] = _userInfo.channel_id;
    }
    
    if ( _userInfo.dev_token )
    {
        params[kDev_token] = _userInfo.dev_token;
    }
    
    if ( _userInfo.devid )
    {
        params[kDevid] = _userInfo.devid;
    }
    
    if ( _latitude != invalid_latitude_longitude && _longitude != invalid_latitude_longitude )
    {
        params[kGps_latitude] = @(_latitude);
        params[kGps_longitude] = @(_longitude);
    }
    
    if ( _userInfo.app_id )
    {
        params[kApp_id] = _userInfo.app_id;
    }
    
//    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    [params setValue:adId forKey:kIdfa];
    
    EVLog(@"JPush: %@", params);
    return params;
}

#pragma mark - CLLocationManagerDelegate
// 当获得用户位置信息之后就会回调此方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 获取经纬度
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
    
    [[EVGeocoder shareInstace] decoderLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude success:^(NSString *addressName) {
        EVLog(@"addressName - %@",addressName);
    } fail:^(NSError *error) {
        EVLog(@"get location address fail : %@",error);
    }];
    
    // 获取经纬度
    // iOS 8.0 之前当开始获取获取用户的位置的时候会不停调用该代理方法, 因此每当获得一次位置信息之后要停止更新位置信息
    [self.locationMgr stopUpdatingLocation];
    [self intializeUserInfo];
    
}

// 获取用户的授权信息
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    BOOL authorized = (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
    [CCUserDefault setBool:authorized forKey:kUserLocationServiceEnableTagKey];
    if ( authorized )
    {
        [self.locationMgr startUpdatingLocation];
    }
}

/**
 * 由于 responseData 和 dev_token 不能同时获取
 * 只能收集好两个数据的时候才能设置用户信息
 */
- (void)intializeUserInfo
{
    if ( _channelId != nil  )
    {
        _userInfo.channel_id = [_channelId mutableCopy];
        _userInfo.push_id = [_channelId mutableCopy];
        if ( _dev_token == nil )
        {
            _dev_token = [CCUserDefault objectForKey:kEVDeviceTokenKey];
        }
        _userInfo.dev_token = _dev_token;
        if ( _userInfo != nil )
        {
            [self persistUserInfo:_userInfo];
            [self registUserInfoToServer];
        }
    }
}

- (void)persistUserInfo:(EVPushUserInfo *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoFullPath];
}

- (EVPushUserInfo *)userInFromLocal
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userInfoFullPath];
}

+ (void)setCurrentBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    [JPUSHService setBadge:badge];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSLog(@"__func__:**********%s",__func__);
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if (self.willPresentNotificationBlock) {
        self.willPresentNotificationBlock(userInfo);
    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert); //                    Badge Sound Alert
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"__func__:**********%s",__func__);
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if (self.didReceiveNotificationResponseBlock) {
        self.didReceiveNotificationResponseBlock(userInfo);
    }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //    completionHandler();
}

@end
