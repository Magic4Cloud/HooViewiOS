//
//  EVHttpURLManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVHttpURLManager : NSObject

/**
 *  拼接URL
 *
 *  @param hostString 基URL
 *  @param uriString  追加部分
 *  @param params     参数
 *
 *  @return 拼接后的URL
 */
+ (NSString *)urlStringWithHost:(NSString *)hostString
                      uriString:(NSString *)uriString
                         params:(NSMutableDictionary *)params;

// 根据Uri获得完整url
+ (NSString *)fullURLStringWithURI:(NSString *)uriString
                            params:(NSMutableDictionary *)params;



// https根据Uri获得完整url
+ (NSString *)httpsFullURLStringWithURI:(NSString *)uriString
                                 params:(NSMutableDictionary *)params;


@end
