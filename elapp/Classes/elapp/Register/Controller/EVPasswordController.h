//
//  EVPasswordController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"
#import "EVLoginInfo.h"

@interface EVPasswordController : EVViewController

@property (nonatomic, strong) EVLoginInfo *loginInfo;

/**
 *  YES     走重置密码流程
 *  NO      走注册流程
 */
@property ( nonatomic, assign ) BOOL resetPWD;

@property (nonatomic, copy) NSString *verifyCode;

@end
