//
//  EVAudioPlayer.h
//  EVCoreStreamer
//
//  Created by mashuaiwei on 16/9/6.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

// 音乐的播放状态
typedef NS_ENUM(NSUInteger, EVAudioPlayerState) {
    EVAudioPlayerStateNoPlaying,            /**< 未播放 */
    EVAudioPlayerStatePlayPreparing,        /**< 播放准备中 */
    EVAudioPlayerStatePlaying,              /**< 正在播放 */
    EVAudioPlayerStatePlayFailure,          /**< 播放失败 */
    EVAudioPlayerStateInterrupted,          /**< 播放被中断 */
    EVAudioPlayerStatePlayComplete,         /**< 播放完成 */
};

@protocol EVAudioPlayerDelegate <NSObject>

@optional
- (void)EVAudioPlayerPlayState:(EVAudioPlayerState)state;

@end

@interface EVAudioPlayer : NSObject

@property (readonly) AudioComponentInstance audioUnit;
@property (atomic, readonly) AudioBuffer tempMusicBuffer;   /**< 读取的音乐 buffer */
@property (nonatomic, copy) NSString *filePath; /**< 要播放的文件路径 */
@property (nonatomic, readonly, assign) BOOL isPlaying; /**< 是否正在播放 */
@property (nonatomic, assign) BOOL supportLoop; /**< 是否支持单曲循环 */
@property (nonatomic, assign) float musicVolume; /**< 音乐的音量大小:0 - 1.0 */

@property (nonatomic, weak) id<EVAudioPlayerDelegate> delegate;   /**< 代理 */

/**
 *  初始化音乐播放器的后台线程，一般放在 APPDelegate 的 didFinishLaunch: 中做，并且在使用单例前调用
 */
+ (void)initialAudioPlayerBackgroundThread;

/**
 *  单例
 */
+ (instancetype)sharePlayer;

/**
 *  播放(属性 filePath 必须有效)
 */
- (void)play;
/**
 *  使用文件路径进行播放
 *
 *  @param filePath 文件路径
 */
- (void)playWithFilePath:(NSString *)filePath;
/**
 *  停止播放
 */
- (void)stop;
/**
 *  暂停
 */
- (void)pause;
/**
 *  继续播放
 */
- (void)resume;

/**
 *  与录音进行混音
 *
 *  @param audioBufferList 录制的音频
 */
- (void)mixWithRecordedBuffer:(AudioBufferList *)audioBufferList;

@end
