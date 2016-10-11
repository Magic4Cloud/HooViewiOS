//
//  EVVideoPlayer.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EVPlayerConfig.h"
@class EVVideoPlayer;



@protocol EVVideoPlayerDelegate <NSObject>

@optional
- (void)evVideoPlayer:(EVVideoPlayer *)player didChangedState:(EVPlayerState)state;
- (void)evVideoPlayer:(EVVideoPlayer *)player updateSpeed:(float)speed;
- (void)evVideoPlayer:(EVVideoPlayer *)player updateBuffer:(int)percent position:(int)position;

@end


/**
 *  EV视频播放器
 */
@interface EVVideoPlayer : NSObject

@property (nonatomic, weak    ) id<EVVideoPlayerDelegate> delegate;     /**< EVPlayer代理 */
@property (nonatomic, strong  ) UIImage *audioThumbImage;               /**< 背景图片 */
@property (nonatomic, strong) UIView *presentview;                           /**< 播放器视图 */
@property (nonatomic, readonly) NSTimeInterval duration;                /**< 视频总时长 */
@property (nonatomic, readonly) NSTimeInterval playableDuration;        /**< 视频可播放时长 */
@property (nonatomic          ) NSTimeInterval currentPlaybackTime;     /**< 视频当前时间 */
@property (nonatomic          ) MPMovieScalingMode scalingMode;         /**< 播放器的MPMovieScalingMode */
@property (nonatomic, copy) NSString *vid;

/**
 *  初始化播放器
 *
 *  @param url 视频URL（必须参数）
 */
- (id)initWithContentURL:(NSString *)uri;

//重新播放
- (void)againPlay;
- (void)play;           /**< 开始播放 */
- (void)pause;          /**< 暂停播放 */
- (void)shutdown;       /**< 关闭播放 */


@end
