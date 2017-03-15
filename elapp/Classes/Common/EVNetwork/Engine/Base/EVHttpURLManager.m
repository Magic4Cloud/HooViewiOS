//
//  EVHttpURLManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVHttpURLManager.h"
#import "EVNetWorkManager.h"


@implementation EVHttpURLManager
/**
 *  拼接URL
 *  @param hostString 基URL
 *  @param uriString  追加部分
 *  @param params     参数
 *  @return 拼接后的URL
 */
+ (NSString *)urlStringWithHost:(NSString *)hostString
                      uriString:(NSString *)uriString
                         params:(NSMutableDictionary *)params
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostString, uriString];
    if ( params[@"device"] == nil )
    {
        params[@"device"] = @"ios";
    }
    EVNetWorkRequest *request = [EVNetWorkRequest netWorkRequestURLString:urlString];
    request.getParams = params;
    urlString = request.urlString;
#ifdef EVDEBUG
    if ( [urlString hasPrefix:@"https"] )
    {
    
    }
    else
    {
        
    }
#endif
    return urlString;
}


// 根据Uri获得完整url
+ (NSString *)fullURLStringWithURI:(NSString *)uriString
                            params:(NSMutableDictionary *)params
{
    return [self urlStringWithHost:EVVideoBaseURL
                         uriString:uriString
                            params:params];
}


// https根据Uri获得完整url
+ (NSString *)httpsFullURLStringWithURI:(NSString *)uriString
                                 params:(NSMutableDictionary *)params
{
    return [self urlStringWithHost:EVVideoBaseHTTPSURL
                         uriString:uriString
                            params:params];
}


@end
