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
 *  @author shizhiang, 15-09-18 20:09:56
 *
 *  开始计时
 */
- (void)startCountTime;

/**
 *  @author shizhiang, 15-09-18 20:09:03
 *
 *  停止计时
 */
- (void)stopCountTime;

@end
