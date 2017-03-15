//
//  EVBaseToolManager+EVLogAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


// http://log.easyvaas.tv/yzb.gif?act=applepay&b=2&c=1
/* 苹果支付：
 1. type: getProduct、payWithItuneStore
 2. state: start、success、fail
 3. moreInfo: json 字符串
 */
#define CCLogBaseURL @"http://log.easyvaas.tv/"
#define CCApplePayURI @"yzb.gif"
#define CCActionKey @"act"
#define CCActionApplePayValue   @"applepay"
#define CCStateStartValue   @"start"
#define CCStateSuccessValue    @"success"
#define CCStateFailValue   @"fail"
#define CCTypeGetProductValue   @"getProduct"
#define CCTypePayWithItuneStoreValue    @"payWithItuneStore"
#define CCMoreInfoKey  @"moreInfo"
#define CCProductID @"productID"

@interface EVBaseToolManager (EVLogAPI)


@end
