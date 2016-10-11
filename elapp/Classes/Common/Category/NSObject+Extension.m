//
//  NSObject+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (void)performBlockOnMainThread:(void(^)())block {
    if ( block == nil )
    {
        return;
    }
    if ( [[NSThread currentThread] isMainThread] )
    {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (void)performBlockOnMainThreadInClass:(void (^)())block
{
    if ( block == nil )
    {
        return;
    }
    if ( [[NSThread currentThread] isMainThread] )
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            block();
        });
    }
}

+ (void)cc_exchangeInstanceMethod1:(SEL)method1
                           method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)cc_exchangeClassMethod1:(SEL)method1
                        method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end
