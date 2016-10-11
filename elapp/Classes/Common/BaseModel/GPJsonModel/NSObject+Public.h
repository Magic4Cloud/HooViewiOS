//
//  NSObject+Public.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Public)

/**
 *  这里汇总了所有可以直接赋值到字典中的value的类型
 */
+ (NSArray *)directKeyValueClasses;

/**
 *  这里汇总了字典的各种类型
 */
+ (NSArray *)dictionaryClasses;

/**
 *  这里汇总了各种集合类型
 */
+ (NSArray *)collectionClasses;

@end
