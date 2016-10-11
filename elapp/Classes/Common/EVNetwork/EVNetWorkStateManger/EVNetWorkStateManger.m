//
//  EVNetWorkStateManger.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNetWorkStateManger.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

// AFNetworkReachabilityStatusNotReachable
#define NETWORK_UNKNOW                  @"unknown"
#define NETWORK_NOTREACHABLE            @"notreacheable"
#define NETWORK_WIFI                    @"WiFi"
#define NETWORK_2G                      @"2G"
#define NETWORK_3G                      @"3G"
#define NETWORK_4G                      @"4G"

@interface EVNetWorkStateManger ()
{
    NSString *_netStateWorkDes;
}

@property (nonatomic,copy) NSString *netStateWorkDes;

@end

@implementation EVNetWorkStateManger

+ (instancetype)shareInstance
{
    return [self sharedManager];
}

- (NSString *)netStateWorkDes
{
    if ( _netStateWorkDes == nil )
    { 
        _netStateWorkDes = NETWORK_UNKNOW;
    }
    return _netStateWorkDes;
}

- (void)setNetStateWorkDes:(NSString *)netStateWorkDes
{
    _netStateWorkDes = [netStateWorkDes copy];
}

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability{
    CCLog(@"initWithReachability");
    if ( self = [super initWithReachability:reachability] ) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
//    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
//    [reachability startMonitoring];
    [CCNotificationCenter addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)boardCastNetWorkState{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationNetworkStatusChanged:(NSNotification*)userinfo{
    NSInteger status = [[[userinfo userInfo]objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    self.currNetWorkState = status;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            [self noNetWork];
            return;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self wwanNetWork];
            return;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self wifiNetWork];
            return;
        case AFNetworkReachabilityStatusUnknown:
        default:
            [self unKnowNetWork];
            return;
    }
}

- (void)netWorkStateChange{
    switch ( self.networkReachabilityStatus ) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self wifiNetWork];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self noNetWork];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self wwanNetWork];
            break;
        default:
            [self unKnowNetWork];
            break;
    }
}

- (void)postNotificationWithState:(CCNetworkStatus)state
{
    [CCNotificationCenter postNotificationName:CCNetWorkChangeNotification object:nil userInfo:@{CCNetWorkStateKey: @(state)}];
}

- (void)unKnowNetWork
{
    self.netStateWorkDes = NETWORK_UNKNOW;
    [self postNotificationWithState:UnknowNetwork];
}

- (void)wifiNetWork
{
    self.netStateWorkDes = NETWORK_WIFI;
    [self postNotificationWithState:WifiNetwork];
}

- (void)wwanNetWork
{
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"])
    {
        self.netStateWorkDes = NETWORK_2G;
        [self postNotificationWithState:GPRS];
        //GPRS网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"])
    {
        self.netStateWorkDes = NETWORK_2G;
        [self postNotificationWithState:Edge];
        //2.75G的EDGE网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:WCDMA];
        //3G WCDMA网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:HSDPA];
        //3.5G网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:HSUPA];
        //3.5G网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"])
    {
        self.netStateWorkDes = NETWORK_2G;
        [self postNotificationWithState:CDMA1xNetwork];
        //CDMA2G网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:CDMAEVDORev0];
        //CDMA的EVDORev0(应该算3G吧?)
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:CDMAEVDORevA];
        //CDMA的EVDORevA(应该也算3G吧?)
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"])
    {
        self.netStateWorkDes = NETWORK_3G;
        [self postNotificationWithState:CDMAEVDORevB];
        //CDMA的EVDORev0(应该还是算3G吧?)
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"])
    {
        self.netStateWorkDes = NETWORK_2G;
        [self postNotificationWithState:HRPD];
        //HRPD网络
        return;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"])
    {
        self.netStateWorkDes = NETWORK_4G;
        [self postNotificationWithState:LTE];
        //LTE4G网络
        return;
    }
}

- (void)noNetWork
{
    self.netStateWorkDes = NETWORK_UNKNOW;
    [self postNotificationWithState:WithoutNetwork];
}

- (BOOL)isWifi{
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (BOOL)isNetWorkEnable{
    return self.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
