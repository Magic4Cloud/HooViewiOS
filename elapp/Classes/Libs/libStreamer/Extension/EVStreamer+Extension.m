//
//  CCRecoder+Extension.m
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 easyvaas. All rights reserved.
//

#import "EVStreamer+Extension.h"
#import "EVAlertManager.h"
#import "NSObject+Extension.h"
#import <DeviceUtil.h>

#define CCRECORD_PREPARE_PLIST  [EVAppCacheFilePath stringByAppendingPathComponent:@"live_prepare_plist"]

#define ENCODER_SIGNATURE_HIGH                      @"V0_P2_S0_E1_R1_B0_A0_C0_M0"
#define ENCODER_SIGNATURE_BASELINE                  @"V0_P0_S0_E0_R1_B0_A0_C0_M0"
#define ENCODER_SIGNATURE_AUDIOONLY                 @"A0_C0_M0"


@implementation EVStreamer (Extension)

// 摄像头 和 麦克风授权
+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny
{
    [self requestCameraAuthedUserAuthed:^{
        [self requestMicPhoneAuthedUserAuthed:userAuthed userDeny:userDeny];
    } userDeny:userDeny];
}

// 摄像头授权
+ (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
                             userDeny:(void(^)())userDeny
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if ( cameraAuthStatus == AVAuthorizationStatusAuthorized )
    {
        [self cameraAuthed:YES];
        
        if ( userAuthed )
        {
            userAuthed();
        }
        
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusNotDetermined )
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            [self performBlockOnMainThreadInClass:^{
                
                [self cameraAuthed:granted];
                if ( granted )
                {
                    if ( userAuthed )
                    {
                        userAuthed();
                    }
                }
                else
                {
                    if ( userDeny )
                    {
                        userDeny();
                    }
                }
                
            }];
        }];
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusDenied || cameraAuthStatus == AVAuthorizationStatusRestricted )
    {
        if ( [UIDevice currentDevice].systemVersion.floatValue < 8.0 )
        {
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"easyvaas_start_warrant") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:nil];
        }
        else
        {
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"access_camera") cancelButtonTitle:kE_GlobalZH(@"not_permit") comfirmTitle:kE_GlobalZH(@"e_permit") WithComfirm:^{
                BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                if (canOpenSettings)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } cancel:^{
                if ( userDeny )
                {
                    userDeny();
                }
            }];
        }
    }
}

// 麦克风授权
+ (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
                               userDeny:(void(^)())userDeny
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ( [audioSession respondsToSelector:@selector(recordPermission)] )
    {
        AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
        switch ( permission )
        {
            case AVAudioSessionRecordPermissionGranted:
                [self micAuthored:YES];
                if ( userAuthed )
                {
                    userAuthed();
                }
                break;
                
            case AVAudioSessionRecordPermissionDenied:
            {
                [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"access_mike") cancelButtonTitle:kE_GlobalZH(@"not_permit") comfirmTitle:kE_GlobalZH(@"e_permit") WithComfirm:^{
                    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                    if (canOpenSettings)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                } cancel:^{
                    if ( userDeny )
                    {
                        userDeny();
                    }
                    [self micAuthored:NO];
                }];
            }
                break;
                
            case AVAudioSessionRecordPermissionUndetermined:
            {
                [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
            }
                break;
                
            default:
                break;
        }
    }
    else if ( [[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)] )
    {
        [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
    }
}

/**
 *  使用系统默认的方式请求麦克风授权 只适配 iOS 7 以上的手机
 *
 *  @param userAuthed 用户授权成功
 *  @param userDeny   用户授权拒绝
 */
+ (void)askForMicAuthedUserAuthed:(void(^)())userAuthed
                         userDeny:(void(^)())userDeny
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        [self performBlockOnMainThreadInClass:^{
            [self micAuthored:granted];
            
            if ( granted )
            {
                if ( userAuthed )
                {
                    userAuthed();
                }
            }
            else
            {
                [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:kE_GlobalZH(@"easyvaas_start_warrant") cancelButtonTitle:kCancel comfirmTitle:kOK WithComfirm:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
                } cancel:userDeny];
            }
        }];
    }];
}

+ (void)micAuthored:(BOOL)micAuthed
{
    [CCUserDefault setBool:micAuthed forKey:kAudioAuthed];
    [CCUserDefault synchronize];
}

+ (void)cameraAuthed:(BOOL)cameraAuthed
{
    [CCUserDefault setBool:cameraAuthed forKey:kCameraAuthed];
    [CCUserDefault synchronize];
}

+ (void)saveLivePrepareInfo:(NSDictionary *)info
{
    if ( info == nil )
    {
        [[NSFileManager defaultManager] removeItemAtPath:CCRECORD_PREPARE_PLIST error:NULL];
    }
    else
    {
        [info writeToFile:CCRECORD_PREPARE_PLIST atomically:YES];
    }
}

+ (NSDictionary *)livePrepreInfoFromLocal
{
    return [NSDictionary dictionaryWithContentsOfFile:CCRECORD_PREPARE_PLIST];
}

+ (NSString *)getEncoderSignature
{
    int device_type = [DeviceUtil hardware];
    
    if( device_type >= IPHONE_6)
    {
        return ENCODER_SIGNATURE_HIGH;
    }
    else
    {
        return ENCODER_SIGNATURE_BASELINE;
    }
}

+ (NSString *)getAudioEncoderSignature
{
    return ENCODER_SIGNATURE_AUDIOONLY;
}

@end
