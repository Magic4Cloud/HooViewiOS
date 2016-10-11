//
//  EVNetWorkStateManger.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, CCNetworkStatus) {
    UnknowNetwork = -1,//不知名网络
    WithoutNetwork = 0,//没有网络
    WifiNetwork = 1,   //WIFI网络
    CDMA1xNetwork = 2, //电信2G网络
    CDMAEVDORev0 = 3,  //电信3G Rev0
    CDMAEVDORevA = 4,  //电信3G RevA
    CDMAEVDORevB = 5,  //电信3G RevB
    Edge = 6,          //移动/联通E网 (2G网络)
    GPRS = 7,          //移动/联通GPRS(2G网络)
    HSDPA = 8,         //移动/联通3G网络  (虽然移动用的是td而不是wcdma但也算是3G)
    HSUPA = 9,         //移动/联通3G网络
    LTE = 10,          //4G网络
    WCDMA= 11,         //3G网络
    HRPD = 12,         //CDMA网络
    //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
    //10为4G网络
    //-1为不知名网络
};

@interface EVNetWorkStateManger : AFNetworkReachabilityManager

@property (nonatomic, assign) CCNetworkStatus currNetWorkState;

@property (nonatomic,copy, readonly) NSString *netStateWorkDes;

- (void)boardCastNetWorkState;

- (BOOL)isWifi;

- (BOOL)isNetWorkEnable;

@end
