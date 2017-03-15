//
//  EVTimerTool.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTimerTool.h"

@interface EVTimerTool ()

@end

@implementation EVTimerTool

- (void)updateForecastTime:(NSTimer *)timer
{
    [EVNotificationCenter postNotificationName:EVUpdateTime object:timer];
}

//定义一个定时器
- (NSTimer *)timer
{
    if ( _timer == nil )
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateForecastTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)startCountTime
{
    [self timer];
}

- (void)stopCountTime
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
