//
//  EVPhoneLoginViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"


@interface EVPhoneLoginViewController : EVViewController

/**
 *  初始化
 */
+ (instancetype)phoneLoginViewController;

@property (nonatomic, copy) NSString *phone;    /**< 手机号，用于充值密码后自动填充 */

@end
