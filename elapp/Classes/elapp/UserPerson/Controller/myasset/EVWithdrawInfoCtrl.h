//
//  EVWithdrawInfoCtrl.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"

@interface EVWithdrawInfoCtrl : EVViewController

@property (nonatomic, copy)   NSString  *withdrawAmount;  //提现金额
@property (nonatomic, assign) CGFloat   weixinFee;        //微信收取的手续费比例

@end
