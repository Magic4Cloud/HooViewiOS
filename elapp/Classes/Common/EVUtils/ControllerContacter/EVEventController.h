//
//  EVEventController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CCEventControllerOperation)();

@interface EVEvent : NSObject

@property (nonatomic, assign) BOOL tasking;
@property (nonatomic,copy) CCEventControllerOperation operation;

@end

/**
 *  @author gaopeirong
 *
 *  播放器事件处理类
 */
@interface EVEventController : NSObject

@property (nonatomic, assign) BOOL completeEvents;

/**
 *  @author gaopeirong
 *
 *  添加事件
 *
 *  @param event    要添加的事件名称
 *  @param eventObj 要添加的事件
 */
- (void)pushEvent:(NSString *)event withOperation:(EVEvent *)eventObj;

/**
 *  @author gaopeirong
 *
 *  执行事件
 *
 *  @param event 要执行的事件
 *
 *  @return 被执行的事件
 */
- (EVEvent *)popEvent:(NSString *)event;

/**
 *  @author gaopeirong
 *
 *  移除事件
 *
 *  @param event 要移除的事件
 */
- (void)cancelEvent:(NSString *)event;

/**
 *  @author gaopeirong
 *
 *  判断事件是否正在执行
 *
 *  @param event 要进行判断的事件
 *
 *  @return 该事件是否正在执行
 */
- (BOOL)eventIsTasking:(NSString *)event;

@end
