//
//  EMAudioPlayerUtil.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMAudioPlayerUtil : NSObject
// 当前是否正在播放
+ (BOOL)isPlaying;

// 得到当前播放音频路径
+ (NSString *)playingFilePath;

// 播放指定路径下音频（wav）
+ (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;

// 停止当前播放音频
+ (void)stopCurrentPlaying;

@end
