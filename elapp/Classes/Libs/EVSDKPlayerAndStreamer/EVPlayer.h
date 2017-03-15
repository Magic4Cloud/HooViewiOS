//
//  EVPlayer.h
//  EVPlayer
//
//  Created by mashuaiwei on 16/8/1.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EVPlayerConfig.h"
@class EVPlayer;

// TODO: 错误合并
/**
 *  播放器准备阶段的响应码
 */
typedef NS_ENUM(NSUInteger, EVPlayerResponseCode) {
    EVPlayerResponse_Okay = 0,                                  /**< 观看请求成功 */
    EVPlayerResponse_error_sdkNotInitedOrInitedFailure = 1,     /**< 没有进行sdk初始化，或者sdk初始化失败 */
    EVPlayerResponse_error_sdkPlayRequestError,                 /**< 观看请求失败 */
    EVPlayerResponse_error_sdkNoPlayerContainerView,            /**< 没有设置视频显示的 container view */
    EVPlayerResponse_error_sdkNoURI,                            /**< 没有设置 URI */
};

typedef void(^EVPlayerCompleteBlock)(EVPlayerResponseCode responseCode, NSDictionary *result, NSError *err);

@protocol EVPlayerDelegate <NSObject>

@optional
/**
 *  播放状态的回调
 *
 *  @param player 播放器
 *  @param state  状态码
 */
- (void)    EVPlayer:(EVPlayer *)player
     didChangedState:(EVPlayerState)state;
/**
 *  播放器在某个位置处缓存加载的百分比
 *
 *  @param player   播放器
 *  @param percent  百分比(单位：1)
 *  @param position 播放位置(单位：s)
 */
- (void)    EVPlayer:(EVPlayer *)player
 updateBufferentCent:(int)percent
            position:(int)position;

@end

@interface EVPlayer : NSObject

@property (nonatomic, strong) UIView *playerContainerView;  /**< 播放器将会在此 view 上渲染播放画面,必须在调用 playPrepareComplete: 之前设置(必填) */
@property (nonatomic, copy) NSString *URI;                  /**< 请求视频播放地址的 URI 部分，必须在调用 playPrepareComplete: 之前设置(必填) */
@property (nonatomic,weak) id<EVPlayerDelegate> delegate;   /**< 代理回调 */
@property (nonatomic) NSTimeInterval currentPlaybackTime;   /**< 当前回放到的时刻，设置它可以改变回放的进度（单位：s） */
@property (nonatomic, readonly) NSTimeInterval duration;    /**< 总回放的时长（单位：s） */
@property (nonatomic, readonly) NSTimeInterval playableDuration;    /**< 可播放的时长，即缓冲时长（单位：s） */
@property (nonatomic, readonly) NSInteger bufferingProgress;        /**< 缓冲百分比（单位：1，完全缓冲为100） */
@property (nonatomic, assign) BOOL needRotate;              /**< 是否需要把视频旋转 90° 显示, 在 playPrepareComplete: 前设置 */

/**
 *  播放准备阶段
 *
 *  @param complete 准备完成的回调
 */
- (void)playPrepareComplete:(EVPlayerCompleteBlock)complete;

/**
 *  开始播放(在 playPrepareComplete: 成功（收到 EVPlayerResponse_Okay）后方可调用)
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  停止播放
 */
- (void)shutDown;

@end
