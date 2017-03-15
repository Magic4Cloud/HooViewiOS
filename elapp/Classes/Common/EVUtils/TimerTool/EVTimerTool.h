//
//  EVTimerTool.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVTimerTool : NSObject

@property (nonatomic, weak) NSTimer *timer; /**< 计时器 */

/**
 *
 *  开始计时
 */
- (void)startCountTime;

/**
 *
 *  停止计时
 */
- (void)stopCountTime;

@end
