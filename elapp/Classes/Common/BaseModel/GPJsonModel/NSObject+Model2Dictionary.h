//
//  NSObject+Model2Dictionary.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIvar.h"

@interface NSObject (Model2Dictionary)

/**
 *  把该对象转化为一个字典
 *
 *  @return 对象字典
 */
- (NSMutableDictionary *)gp_dictionaryFromModel;

+ (NSDictionary *)ignoreProperties;

@end
