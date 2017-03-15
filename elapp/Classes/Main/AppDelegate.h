//
//  AppDelegate.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#define CCGetHomeViewController() (((AppDelegate *)[UIApplication sharedApplication].delegate).homeVC)

#import <UIKit/UIKit.h>
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVHomeViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVBaseToolManager+EVHomeAPI.h"

#define app_delegate_engine ((AppDelegate *)[UIApplication sharedApplication].delegate).liveEngine

extern NSString * const kStatusBarTappedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, weak) EVHomeViewController *homeVC;

@property (nonatomic,strong) EVBaseToolManager *liveEngine;


@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)BOOL allowRotation;//是否允许转向

- (void)setUpHomeController;

/**
 *
 *  重新登录
 */
- (void)relogin;

/**
 *
 *  发私信
 *  @param name 对方的云播号
 */
- (void)chatWithName:(NSString *)name;

@end

