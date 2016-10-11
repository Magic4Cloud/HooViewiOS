//
//  EVEventController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVEventController.h"

@implementation EVEvent

@end

@interface EVEventController ()

@property (nonatomic,strong) NSMutableDictionary *events;

@end

@implementation EVEventController

- (NSMutableDictionary *)events{
    if ( _events == nil ) {
        _events = [NSMutableDictionary dictionary];
    }
    return _events;
}

// 添加事件
- (void)pushEvent:(NSString *)event withOperation:(EVEvent *)eventObj{
    EVEvent *task = [self.events objectForKey:event];
    if ( task == nil ) {
        [self.events setObject:eventObj forKey:event];
    }
}

// 执行事件
- (EVEvent *)popEvent:(NSString *)event{
    EVEvent *task = [self.events objectForKey:event];
    if ( task ) {
        if ( task.operation ) {
            task.tasking = YES;
            task.operation();
        }
        [self.events removeObjectForKey:event];
    }
    return task;
}

// 判断事件是否正在执行
- (BOOL)eventIsTasking:(NSString *)event{
    EVEvent *task = [self.events objectForKey:event];
    if ( task ) {
        return task.tasking;
    }
    return NO;
}

// 移除事件
- (void)cancelEvent:(NSString *)event{
    EVEvent *task = [self.events objectForKey:event];
    if ( task ) {
        [self.events removeObjectForKey:event];
        task = nil;
    }
}

@end
