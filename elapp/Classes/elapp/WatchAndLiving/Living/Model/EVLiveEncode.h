//
//  EVLiveEncode.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EVStreamerConfig.h"
@class EVStreamer;
typedef NS_ENUM (NSInteger, EVEncodedState)
{
    EVEncodedStateEncoderError,                     //设备发生错误
    EVEncodedStateConnecting,                       // 连接服务器
    EVEncodedStateStreamReady,                      // 连接服务器成功
    EVEncodedStateConnected,                        // 连接成功
    EVEncodedStateReconnecting,                     // 重连中
    EVEncodedStateStreamOptimizComplete,            // 优化完毕
    EVEncodedStateStreamOptimizing,                 // 优化连接中，当前网络环境欠佳
    EVEncodedStateNoNetWork,                        // 当前无网络, 网络回来会自动重连
    EVEncodedStateInitNetworkErreor,               //网络初始化失败
    EVEncodedStatePhoneCallComeIn,                  // 电话来了
    EVEncodedStateLivingIsInterruptedByOther,       // 直播被被迫中断, 其他原因
    EVEncodedStateNetWorkStateUnSuitForStreaming_lv1,   // 当前网络环境不适合直播(等级一)
    EVEncodedStateNetWorkStateUnSuitForStreaming_lv2,   // 当前网络环境不适合直播(等级二)
};
@protocol EVVideoCodingDelegate <NSObject>

@optional

- (void)codingStateChanged:(EVEncodedState)state;

////聚焦失败
- (void)cameraFocusFail:(NSString *)fail;

- (void)enterForeground;

- (void)enterBackground;

- (void)EVRecordAudioBufferList:(AudioBufferList *)audioBufferList;

- (void)LinkStatus:(EVInteractiveLiveStatus)status;

//直播状态

@end
//rtmp://localhost:1935/rtmplive/room1
@interface EVLiveEncode : NSObject

@property (nonatomic, assign) id<EVVideoCodingDelegate> delegate;

@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, assign) BOOL startLiving;


@property (nonatomic, copy) NSString *getPreLiveurl;

@property (nonatomic) CGPoint focusFloat;


@property (strong, nonatomic) NSDictionary *watermakLogoInfo;

/**
 *   缩放
 *
 *  @param zoomFactor 放大点
 *  @param failBlock  错误
 */
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor
                        fail:(void(^)(NSError *error))failBlock;
/**
 *  截取画面
 */
- (void)getCapture:(void(^)(UIImage *image))imageBlock;
/**
 *  切换前后摄像头
 *
 *  @param front YES,使用前置摄像头, NO 使用后置摄像头
 *  @param complete 切换完毕的回调, success == NO 可能是改设备只有一个摄像头可用
 */
- (void)switchCamera:(BOOL)front
            complete:(void(^)(BOOL success , NSError *error))complete;


/**
 *  初始化视频
 *
 *  @param view 传人你要的视频view
 */
- (void)initWithLiveEncodeView:(UIView *)view;



- (void)startLinkChannelid:(NSString *)channel;
- (void)endLink;
/**
 *  开始编码
 */
- (void)startEncoding;

/**
 *  停止编码
 */
- (void)shutDownEncoding;

/**
 *  停止推流
 */
- (void)shutDwonStream;

/**
 *  上传直播url
 *
 *  @param url url
 */
- (void)upDateLiveUrl:(NSString *)url;

/**
 *  开启/关闭美颜
 *
 *  @param enabled YES:开启 / NO:关闭
 */
- (void)enableFaceBeauty:(BOOL)enabled;


@end
