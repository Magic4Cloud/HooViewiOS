//
//  NSObject+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (void)performBlockOnMainThread:(void(^)())block;

+ (void)performBlockOnMainThreadInClass:(void(^)())block;

/**
 *  本实例中交换两个对象方法
 *
 *  @param method1
 *  @param method2 
 */
+ (void)cc_exchangeInstanceMethod1:(SEL)method1
                           method2:(SEL)method2;

/**
 *  本类中交换两个类方法
 *
 *  @param method1
 *  @param method2
 */
+ (void)cc_exchangeClassMethod1:(SEL)method1
                        method2:(SEL)method2;


@end
