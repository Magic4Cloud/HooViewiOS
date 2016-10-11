//
//  CCRecoder+Extension.h
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 easyvaas. All rights reserved.
//

#import "EVStreamer.h"

@interface EVStreamer (Extension)

/**
 *  请求摄像头 和 麦克风授权 iOS 7 待测
 *
 *  @param userAuthed 用户授权
 *  @param userDeny   用户拒绝
 */
+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny;

/**
 *  请求摄像头权限 iOS 7 待测
 *
 *  @param userAuthed 用户允许
 *  @param userDeny   用户拒绝
 */
+ (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
                             userDeny:(void(^)())userDeny;

/**
 *  请求麦克风授权 iOS 7 待测
 *
 *  @param userAuthed 用户允许
 *  @param userDeny   用户拒绝
 */
+ (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
                               userDeny:(void(^)())userDeny;

/**
 *  保存服务器直播准备信息到本地
 *  如果传 nil 则把当前保存的信息删除
 *
 *  @param info
 */
+ (void)saveLivePrepareInfo:(NSDictionary *)info;

/**
 *  返回上一次异常中断的直播信息
 *
 *  @return 如果反悔为空则上一次没有断开
 */
+ (NSDictionary *)livePrepreInfoFromLocal;

/**
 *  续播编码参数
 *
 *  @return
 */
+ (NSString *)getEncoderSignature;

/**
 *  语音续播编码参数
 *
 *  @return
 */
+ (NSString *)getAudioEncoderSignature;

@end
