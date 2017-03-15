//
//  EVPhoneRegistFirstController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
#import "EVLoginInfo.h"


@interface EVPhoneRegistFirstController : EVViewController
/**
 *  YES     走重置密码流程
 *  NO      走注册流程
 */
@property ( nonatomic, assign ) BOOL resetPWD;

/**
 *  手机注册
 */
+ (instancetype)phoneRegistFirstController;

@end
