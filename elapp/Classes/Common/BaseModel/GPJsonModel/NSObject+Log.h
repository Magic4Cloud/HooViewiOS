//
//  NSObject+Log.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GPDebug.h"

@interface NSObject (Log)

- (void)gp_emurateIvarsUsingBlock:(void(^)(Ivar ivar,NSString *ivarName,id value))block;

@end
