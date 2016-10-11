//
//  EVUserSettingViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVLoginInfo;
#import "EVTableViewController.h"

@interface EVUserSettingViewController : EVTableViewController

/**
 *  初始化此控制器
 */
+ (instancetype)userSettingViewController;

@property (nonatomic, strong) EVLoginInfo *userInfo;        // 用户登陆信息

@property (nonatomic, assign) BOOL isReedit;                // NO：注册 YES：更改个人信息


@end
