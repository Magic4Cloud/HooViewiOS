//
//  NSDictionary+JSON.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

/**
 *  把json数据转成字符串
 */
- (NSString *)jsonString;

/**
 *  转化为json二进制数据
 *
 *  @return 
 */
- (NSData *)jsonData;

/**
 *  通过key获得字典中对应的值，如果该值为NSNull返回为空
 *
 *  @param key 字典中的值
 *
 *  @return 返回的值
 */
- (id)cc_objectWithKey:(NSString *)key;

@end
