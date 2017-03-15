//
//  EVMessageConfig.h
//  EVMessage
//
//  Created by mashuaiwei on 16/8/9.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#ifndef EVMessageConfig_h
#define EVMessageConfig_h
/**
 *  消息模块错误码
 */
typedef NS_ENUM(NSInteger, EVMessageErrorCode) {
    EVMessageErrorNone = 0,                     /**< 无错误 */
    
    EVMessageErrorNetworkTimeout = -1001,       /**< 连接超时 */
    EVMessageErrorNetworkInvalidURL = -1002,    /**< URL 错误 */
    EVMessageErrorNetworkNotConnect = -1003,    /**< 未连接 */
    EVMessageErrorNetworkUnkown = -1101,        /**< 未知网络错误 */
    
    EVMessageErrorSDKNotInit = -2001,           /**< SDK 未初始化或初始化不成功 */
    
    EVMessageErrorInternalServer = -3001,       /**< 消息服务器内部错误 */
    EVMessageErrorPermissionDenied = -3002,     /**< 没有权限 */
    EVMessageErrorJoinTopic = -3003,            /**< 加入 topic 失败 */
    EVMessageErrorSend = -3004,                 /**< 发送失败 */
    EVMessageErrorShutuped = -3005,             /**< 被禁言 */
    
    EVMessageInternalError = -4001,             /**< 内部错误 */
};

typedef NS_ENUM(NSUInteger, EVMessageOperationCode) {
    EVMessageOperationNone = 0,
    EVMessageOperationSet,
    EVMessageOperationDelete,
};

typedef NS_ENUM(NSUInteger, EVMessageType) {
    EVMessageTypeAll = 0,
    EVMessageTypeSystem = 1 << 0,
    EVMessageTypeMessage = 1 << 1,
    EVMessageTypeGift = 1 << 2,
};


#endif /* EVMessageConfig_h */
