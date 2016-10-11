//
//  EVMessageConfig.h
//  EVMessage
//
//  Created by mashuaiwei on 16/8/9.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

//#ifndef EVMessageConfig_h
//#define EVMessageConfig_h
/*
 #define EV_WEBSOCKET_OK                            200
 #define EV_WEBSOCKET_ERROR_DBSERVER                501
 #define EV_WEBSOCKET_ERROR_NOT_JSON                601
 #define EV_WEBSOCKET_ERROR_CODE_EMPTY              602
 #define EV_WEBSOCKET_ERROR_CODE_ERROR              603
 #define EV_WEBSOCKET_ERROR_REG_USER                604
 #define EV_WEBSOCKET_ERROR_BODY_LEN16              605
 #define EV_WEBSOCKET_ERROR_USER_EXIST              606
 #define EV_WEBSOCKET_ERROR_USER_NOT_EXIST          607
 #define EV_WEBSOCKET_ERROR_PERMISSION_DENIED       608
 #define EV_WEBSOCKET_ERROR_APPLICATION_NAME        610
 #define EV_WEBSOCKET_ERROR_APPLICATION_ID          611
 #define EV_WEBSOCKET_ERROR_DEL_APPLICATION         612
 #define EV_WEBSOCKET_ERROR_REG_APPLICATION         613
 #define EV_WEBSOCKET_ERROR_GET_APPLICATION         614
 #define EV_WEBSOCKET_ERROR_TOPIC_NAME              620
 #define EV_WEBSOCKET_ERROR_REG_TOPIC               621
 #define EV_WEBSOCKET_ERROR_DEL_TOPIC               622
 #define EV_WEBSOCKET_ERROR_JOIN_TOPIC              623
 #define EV_WEBSOCKET_ERROR_TOPIC_NOT_EXIST         624
 #define EV_WEBSOCKET_ERROR_TOPIC_JOINED            625
 #define EV_WEBSOCKET_ERROR_TOPIC_NOT_JOIN          626
 #define EV_WEBSOCKET_ERROR_JSON_FORM               630
 #define EV_WEBSOCKET_ERROR_TRIEFILTER              631
 #define EV_WEBSOCKET_ERROR_SENDTOPIC               632
 #define EV_WEBSOCKET_ERROR_SHUTUPED                633
 #define EV_WEBSOCKET_ERROR_CMD                     700
 #define EV_WEBSOCKET_ERROR_PARAM                   701
 #define EV_WEBSOCKET_ERROR_UID                     702
 #define EV_WEBSOCKET_ERROR_APPID                   703
 #define EV_WEBSOCKET_ERROR_UNKNOW                  1000
*/
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
};


//#endif /* EVMessageConfig_h */
