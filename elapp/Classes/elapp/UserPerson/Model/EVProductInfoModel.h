//
//  EVProductInfoModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

@interface EVProductInfoModel : EVBaseObject

@property (assign, nonatomic) NSUInteger rmb; /**< 充值金额，单位为元，int */
@property (assign, nonatomic) NSUInteger ecoin; /**< 获取的火眼豆数，int */
@property (assign, nonatomic) NSUInteger free; /**< 赠送的火眼豆数，int */
@property (assign, nonatomic) BOOL active; /**< 是否激活 */
@property (assign, nonatomic) NSInteger platform; /**< 支付平台 */
@property (copy, nonatomic) NSString *productid;  /**< 产品id */

@property (nonatomic, assign) BOOL isSelected;
@end
