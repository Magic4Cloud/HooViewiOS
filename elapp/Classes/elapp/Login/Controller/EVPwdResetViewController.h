//
//  EVPwdResetViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

@interface EVPwdResetViewController : EVViewController

@property (nonatomic,copy) NSString *phone; // 手机号

/**
 *  初始化当前控制器
 */
+ (instancetype)pwdResetViewController;

@end
