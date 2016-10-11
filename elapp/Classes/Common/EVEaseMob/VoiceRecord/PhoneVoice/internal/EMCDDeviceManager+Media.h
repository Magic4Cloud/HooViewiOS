//
//  EMCDDeviceManager+Media.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EMCDDeviceManagerBase.h"

@interface EMCDDeviceManager (Media)

#pragma mark - AudioPlayer
// 播放音频
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;
// 停止播放
- (void)stopPlaying;

- (void)stopPlayingWithChangeCategory:(BOOL)isChange;

// 当前是否正在播放
-(BOOL)isPlaying;

#pragma mark - AudioRecorder
// 开始录音
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                                completion:(void(^)(NSError *error))completion;

// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion;
// 取消录音
-(void)cancelCurrentRecording;


// 当前是否正在录音
-(BOOL)isRecording;

@end
