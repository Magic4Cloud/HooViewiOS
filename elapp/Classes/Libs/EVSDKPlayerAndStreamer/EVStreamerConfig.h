//
//  EVStreamerConfig.h
//  EVCoreStreamer
//
//  Created by mashuaiwei on 16/7/28.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#ifndef EVStreamerConfig_h
#define EVStreamerConfig_h

// 直播状态码
typedef NS_ENUM(NSUInteger, EVStreamerState) {
    EVStreamerStateUknown,                              // 未知
    EVStreamerStateAudioInitalError,                    // 音频设备初始化失败
    EVStreamerStateVideoInitialError,                   // 视频设备初始化失败
    EVStreamerStateSessionWarning,
    EVStreamerStateSessionError,
    EVStreamerStateEncoderError,                        // 编码错误
    EVStreamerStateStreamReady,                         // 连接服务器前期准备完成
    EVStreamerStateConnecting,                          // 连接推流服务器
    EVStreamerStateReconnecting,                        // 重连中
    EVStreamerStateConnected,                           // 推流服务器连接成功
    EVStreamerStateStreamOptimizing,                    // 优化连接中，当前网络环境欠佳
    EVStreamerStateStreamOptimizeComplete,              // 优化完毕
    EVStreamerStateNetworkUnsuitForStreaming_lv1,       // 当前网络环境不适合直播(等级一)
    EVStreamerStateNetworkUnsuitForStreaming_lv2,       // 当前网络环境不适合直播(等级二)
    EVStreamerStateNoNetwork,                           // 当前无网络, 网络回来会自动重连
    EVStreamerStateInitNetWorkError,
    EVStreamerStateConnectTimeout,                      // 连接服务器超时, 会自动重连
    EVStreamerStateStreamTimeout,                       // 写数据流超时, 会自动重连 废弃
    EVStreamerStateConnectDisconnectByPeer,             // 服务器断开连接了, 废弃
    EVStreamerStateLivingIsInterruptedByPhone,          // 直播被被迫中断, 原因: 接电话
    EVStreamerStateLivingIsInterruptedByOther,          // 直播被被迫中断, 其他原因
    EVStreamerStatePhoneCallComeIn,                     // 电话来了
    EVStreamerStatePhoneCallDisconnect,                 // 挂断电话
};

// 直播端网络请求的结果码
typedef NS_ENUM(NSUInteger, EVStreamerResponseCode) {
    EVStreamerResponse_Okay = 0,
    EVStreamerResponse_error_sdkNotInitedOrInitedFailure = 1,           /**< 没有进行sdk初始化，或者sdk初始化失败 */
    EVStreamerResponse_error_sdkLiveRequestError,                       /**< 直播请求失败 */
    EVStreamerResponse_error_sdkNotLivePrepareOrPrepareFailure,         /**< 没有调用直播准备接口，或调用直播准备失败 */
    EVStreamerResponse_error_sdkNoVid,                                  /**< 没有设置 vid, vid 一定要在 liveStart 之前设置 */
    EVStreamerResponse_error_sdkNoURI,                                  /**< 没有设置URI, URI 一定要在 liveStart 之前设置 */
    EVStreamerResponse_error_sdkInitHardware,                           /**< 初始化硬件错误 */
};

// 编码输出视频的size
typedef NS_ENUM(NSUInteger, EVStreamFrameSize) {
    EVStreamFrameSize_default = 0,
    EVStreamFrameSize_360x640 = EVStreamFrameSize_default,
    EVStreamFrameSize_540x960,
    EVStreamFrameSize_720x1280,
};

// 音频上传码率(单位：kbps)
typedef NS_ENUM(NSUInteger, EVStreamerAudioBitrate) {
    EVStreamerAudioBitrate_32,
    EVStreamerAudioBitrate_48,
    EVStreamerAudioBitrate_64,
    EVStreamerAudioBitrate_128,
};

typedef NS_ENUM(NSUInteger, EVInteractiveLiveStatus) {
    EVInteractiveLiveStatusNone,            /**< 未知状态 */
    EVInteractiveLiveStatusSuccess,         /**< 连麦成功 */
    EVInteractiveLiveStatusUserOffline,     /**< 用户掉线 */
    EVInteractiveLiveStatusLinkFailed,      /**< 连麦失败 */
    EVInteractiveLiveStatusEnd,             /**< 连麦结束 */
};

#endif /* EVStreamerConfig_h */
