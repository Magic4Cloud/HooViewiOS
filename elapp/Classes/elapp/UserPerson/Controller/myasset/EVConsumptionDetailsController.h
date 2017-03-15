//
//  EVConsumptionDetailsController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


typedef NS_ENUM(NSInteger, EVDetailType)
{
    EVDetailType_withdrawal =100,       //提现记录
    EVDetailType_prepaid,          //充值记录
    EVDetailType_consume,        //消费记录
};

#import "EVViewController.h"


@interface EVConsumptionDetailsController : EVViewController

@property (nonatomic, assign) EVDetailType type;

@end
