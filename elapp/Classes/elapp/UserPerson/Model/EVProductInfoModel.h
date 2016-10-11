//
//  EVProductInfoModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"

@interface EVProductInfoModel : CCBaseObject

@property (assign, nonatomic) NSUInteger rmb; /**< 充值金额，单位为元，int */
@property (assign, nonatomic) NSUInteger ecoin; /**< 获取的云币数，int */
@property (assign, nonatomic) NSUInteger free; /**< 赠送的云币数，int */
@property (assign, nonatomic) BOOL active; /**< 是否激活 */
@property (assign, nonatomic) NSInteger platform; /**< 支付平台 */
@property (copy, nonatomic) NSString *productid;  /**< 产品id */

@end
