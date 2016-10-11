//
//  NSError+Extention.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSError (Extention)

/**
 *  优先使用服务器的错误提示,如果没有找到就指定默认的提示
 *
 *  @param placeholderInfo 默认的提示 
 *  全局通用提示请使用宏 CCAPP_GLOBAL_PLACEHOLDER (@"网络不佳请稍后重试")
 *
 *  @return 
 */
- (NSString *)errorInfoWithPlacehold:(NSString *)placeholderInfo;

/**
 *  创建并过滤出跟服务器相关的错误对象
 *
 *  @param info 服务器返回的信息
 *
 *  @return 
 */
+ (instancetype)cc_errorWithDictionary:(NSDictionary *)info;

@end
