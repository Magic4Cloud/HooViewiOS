//
//  EVNotificationManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNotificationManager.h"
#import "constants.h"

@interface EVLocalNotification ()

@end

@implementation EVLocalNotification


- (instancetype)initWithAlertBody:(NSString *)alertBody AlertAction:(NSString *)alertAction{
    if ( self = [super init] ) {
        _fireDate = [NSDate date];
        _alertLaunchImage = @"Default-568h";
        self.soundName = [[NSBundle mainBundle] pathForResource:@"in.caf" ofType:nil];
        // self.soundName = @"in.caf";
        self.alertAction = alertAction;
        self.alertBody = alertBody;
    }
    return self;
}

+ (instancetype)localNotificationWithAlertBody:(NSString *)alertBody AlertAction:(NSString *)alertAction{
    return [[self alloc] initWithAlertBody:alertBody AlertAction:alertAction];
}

- (NSDate *)fireDate
{
    if ( _fireDate == nil )
    {
        _fireDate = [NSDate date];
    }
    return _fireDate;
}

- (UILocalNotification *)localNotification{
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.fireDate = self.fireDate;
    noti.alertBody = self.alertBody;
    noti.alertLaunchImage = self.alertLaunchImage;
    // noti.soundName = self.soundName;
    // noti.soundName = @"in.caf";
    noti.soundName = UILocalNotificationDefaultSoundName;
    noti.applicationIconBadgeNumber = self.applicationIconBadgeNumber;
    noti.userInfo = self.userInfo;
    noti.alertAction = self.alertAction;
    [noti setHasAction:YES];
    return noti;
}

@end

@interface EVNotificationManager ()<UIAlertViewDelegate>


@end

@implementation EVNotificationManager

singtonImplement(NotificationManager)

- (void)registForLocalNotificationFor_iOS8{
    if ( [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)] ) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    if ( [[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        if ( [CCUserDefault boolForKey:CCHasLoginTag] ) {
            [self checkCurrAuthorizeInfo];
        }
    }
}

- (void)checkCurrAuthorizeInfo{
    UIUserNotificationSettings *setting = [UIApplication sharedApplication].currentUserNotificationSettings;
    if ( !((setting.types & UIUserNotificationTypeBadge) && (setting.types & UIUserNotificationTypeSound)  && (setting.types & UIUserNotificationTypeAlert)) ) {
        CCLog(@"没有注册权限");
        if ( ![CCUserDefault boolForKey:CCNoNeedToAlertNotificationSettingTag] ) {
            [self alertToRegistNotification];
        }
    } else {
        CCLog(@"有注册权限");
    }
}

- (void)alertToRegistNotification{
    [[[UIAlertView alloc] initWithTitle:kE_GlobalZH(@"request_start_local_notice") message:kE_GlobalZH(@"start_local_notice_step") delegate:self cancelButtonTitle:kOK otherButtonTitles:kE_GlobalZH(@"not_remind"), nil] show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ( buttonIndex == 0 ) {
        CCLog(@"跳转到设置界面");
        NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
        if ( [[UIApplication sharedApplication] canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            CCLog(@"不可以开启");
        }
    } else {
        [CCUserDefault setBool:YES forKey:CCNoNeedToAlertNotificationSettingTag];
    }

}

- (void)performLocalNotification:(EVLocalNotification *)notification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *noti = notification.localNotification;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}


@end
