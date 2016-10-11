//
//  EVStreamer.h
//  EVStreamer
//
//  Created by mashuaiwei on 16/7/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EVStreamerConfig.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^EVStreamerCompleteBlock)(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err);

@protocol EVStreamerDelegate <NSObject>

@optional
/**
 *  直播状态的回调
 *
 *  @param state 状态
 *  @param error 错误
 */
- (void)EVStreamerUpdateState:(EVStreamerState)state
                            error:(NSError *)error;

/**
 *  音频采集的回调
 *
 *  @param audioBufferList 采集的数据
 */
- (void)EVStreamerRecordAudioBufferList:(AudioBufferList *)audioBufferList;

@end

@interface EVStreamer : NSObject

@property (nonatomic,weak) id<EVStreamerDelegate> delegate; /**< 代理 */

#pragma mark - 直播

////////////////////// 以下参数要在 livePrepareComplete: 之前完成 ///////////////////

@property (nonatomic,weak) UIView *presentView;         /**< 画面渲染的 view，必填 */
@property (nonatomic, assign, readonly) NSUInteger fps; /**< 视频采集帧率:25 */
@property (nonatomic, assign) NSUInteger videoBitrate;  /**< 视频初始化码率, 默认为 500 kbps, 然后会根据网络情况动态调整，最大码率为 700 kbps, 最小码率为200 kbps */
@property (nonatomic, assign) NSUInteger audioBitrate;  /**< 音频编码码率(单位：kbps, 值必须 >= 32, 否则不生效), 默认为48 kpbs */
@property (nonatomic, assign) BOOL useHEAAC;            /**< 使用高质量 aac 编码 */
@property (nonatomic, assign) EVStreamFrameSize streamFrameSize;    /**< 上传到服务器的视频流，每帧的大小（宽高），默认为 CCRecorderStreamFrameSize_360x640 */
@property (nonatomic, assign) BOOL mute;                /**< 是否静音, 默认为 NO, 在此也可设置静音 */
@property (nonatomic, assign) BOOL frontCamera;         /**< 是否使用前置摄像头, 默认为 NO */
@property (nonatomic, assign) BOOL flashOn;             /**< 是否使用闪光灯, 默认为 NO，前置摄像头状态下不要使用闪关灯 */

//////////////////////////////////////////////////////////////////////////////////

/**
 *  直播准备：初始化取景器,推流器（presentView 不能为空）
 *
 *  @param complete 准备完成的回调(只包含错误：sdk初始化、硬件初始化)
 */
- (void)livePrepareComplete:(EVStreamerCompleteBlock)complete;


//////////////////////// 以下参数要在 liveStartComplete: 之前完成 ////////////////////

@property (nonatomic, copy) NSString *URI;                  /**< 进行推流请求拼接的字符串（必填） */
@property (strong, nonatomic) UIImage *watermakLogoImage;   /**< 水印logo */
/**
 *  水印logo的相关信息
 *  @prama  key             value                       notation
 *          frame           CGRect(NSString)            图片的frame
 *          relativeFrame   CGRect(NSString)            相对frame
 */
@property (strong, nonatomic) NSDictionary *watermakLogoInfo;


//////////////////////////////////////////////////////////////////////////////////

/**
 *  直播开始的请求
 *
 *  @param complete 请求完成的回调
 */
- (void)liveStartComplete:(EVStreamerCompleteBlock)complete;

/**
 *  开始推流(必须在 liveStartComplete: 回调的状态为 EVStreamerResponse_Okay 时调用才有作用)
    推流状态的回调 EVStreamerUpdateState:error:
 */
- (void)start;

/**
 *  暂停推流
 */
- (void)pause;

/**
 *  恢复推流
 */
- (void)resume;

/**
 *  关闭推流
 */
- (void)shutDown;


#pragma mark - 辅助操作 以下操作必须在prepare之后才能生效

/**
 *  当前摄像头最大的放大倍数
 *     4s 最大放大倍数是 1
 */
@property (nonatomic, assign, readonly) CGFloat maxZoomFactor;

/**
 *  当前摄像头最小的放大倍数
 *      通常从 1 开始, 4s 以下的从 0 开始
 */
@property (nonatomic, assign, readonly) CGFloat minZoomFactor;

/**
 *  缩放
 *      部分 4s 手机放大会失效
 *  @param zoomFactor 放大的倍数
 */
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor
                        fail:(void(^)(NSError *error))failBlock;

/**
 *  切换前后摄像头
 *
 *  @param front YES,使用前置摄像头, NO 使用后置摄像头
 *  @param complete 切换完毕的回调, success == NO 可能是改设备只有一个摄像头可用
 */
- (void)switchCamera:(BOOL)front
            complete:(void(^)(BOOL success , NSError *error))complete;

/**
 *  定点对焦
 *
 *  @param location  焦点
 *  @param failBlock 对焦失败
 */
- (void)cameraWithLocation:(CGPoint)location
                      fail:(void(^)(NSError *focusError))failBlock;

/**
 *  闪光灯开关
 *
 *  @param on YES 打开, NO,关闭
 */
- (void)turnOnFlashLight:(BOOL)on;

/**
 *  控制水印显示开关
 *
 *  @param on YES:开 NO:关
 */
- (void)enableWatermark:(BOOL)on;

/**
 *  获取当前是否开启了水印
 *
 *  @return YES:开 NO:关
 */
- (BOOL)isWatermakOn;

/**
 *  开启/关闭美颜
 *
 *  @param enabled YES:开启 / NO:关闭
 */
- (void)enableFaceBeauty:(BOOL)enabled;

/**
 *  是否开启了美颜
 *
 *  @return YES:开启 / NO:关闭
 */
- (BOOL)isFaceBeautyEnabled;

/**
 *  截取画面
 */
- (void)getCapture:(void(^)(UIImage *image))imageBlock;

@end
