//
//  EVNetWorkManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNetWorkManager.h"
#import <DeviceUtil.h>
#import <objc/runtime.h>
#import "NSObject+Extension.h"


// 协助服务器实现 dns 开关
#define CC_NETWORK_DNS 0

@implementation EVNetWorkRequest

- (instancetype)initWithURLString:(NSString *)urlString
{
    if ( self = [super init] )
    {
        self.urlString = urlString;
        self.httpMethod = EVNetWorkHTTPMethodGet;
    }
    return self;
}

+ (instancetype)netWorkRequestURLString:(NSString *)urlString
{
    return [[self alloc] initWithURLString:urlString];
}

- (NSString *)dataFromParams
{
    NSMutableString *paramStr = [NSMutableString string];
    NSInteger paramCount = self.getParams.count;
    __block NSInteger index = 0;
    [self.getParams enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    return paramStr;
}

- (NSString *)urlString
{
    if ( self.httpMethod == EVNetWorkHTTPMethodPost || !self.getParams )
    {
        return _urlString;
    }
    return [self requestURLStringFromHttpGet];
}

- (NSString *)requestURLStringFromHttpGet
{
#ifdef EVDEBUG
    NSAssert(self.httpMethod == EVNetWorkHTTPMethodGet, @"http method can not be POST");
#endif
    if ( !self.getParams )
    {
        return _urlString;
    }
    return [NSString stringWithFormat:@"%@?%@",_urlString,[self dataFromParams]];
}

@end
