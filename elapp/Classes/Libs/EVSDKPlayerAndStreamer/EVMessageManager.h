//
//  EVMessageManager.h
//  EVMessage
//
//  Created by mashuaiwei on 16/7/24.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessageProtocol.h"
#import "EVMessageConfig.h"

typedef void(^EVMessageResultBlock)(BOOL isSuccess, EVMessageErrorCode errorCode);

@interface EVMessageManager : NSObject

@property (nonatomic, weak) id<EVMessageProtocol> delegate;  /**< 代理 */

/**
 *  获取单例
 */
+ (instancetype)shareManager;

/**
 *  连接消息服务器
 */
- (void)connect;

/**
 *  断开消息服务器
 */
- (void)close;

/**
 *  加入话题
 *
 *  @param topic       话题
 *  @param resultblock 执行结果
 */
- (void)joinTopic:(NSString *)topic
           result:(void(^)(BOOL isSuccess, EVMessageErrorCode errorCode, NSArray <NSString *>*privateInfos, NSArray <NSString *>*users))resultblock;

/**
 *  离开话题
 *
 *  @param topic       话题
 *  @param resultblock 执行结果
 */
- (void)leaveTopic:(NSString *)topic
            result:(EVMessageResultBlock)resultblock;

/**
 *  向话题内的所有人发送消息
 *
 *  @param message      会进行关键字过滤的内容(一般发送群聊消息)
 *  @param userdata     不进行关键字过滤的内容(在此可以做自定义协议)
 *  @param topic        话题
 *  @param resultblock  发送结果
 */
- (void)sendMessage:(NSString *)message
           userData:(NSString *)userdata
            toTopic:(NSString *)topic
             result:(EVMessageResultBlock)resultblock;

/**
 *  增加点赞数
 *
 *  @param likes       本次增加的数目
 *  @param topic       话题
 *  @param resultblock 发送结果
 */
- (void)addLikeCountNumber:(NSUInteger)likes
                   inTopic:(NSString *)topic
                    result:(EVMessageResultBlock)resultblock;

@end
