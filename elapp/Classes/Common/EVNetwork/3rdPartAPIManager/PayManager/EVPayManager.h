//
//  EVPayManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@class EVProductInfoModel;

typedef enum : NSUInteger {
    EVPayFailedTypeUnknown,
    EVPayFailedTypeCancel,
    EVPayFailedTypeError,
} EVPayFailedType;

@protocol EVPayManagerDelegate <NSObject>

@optional
/**
 *  微信支付成功
 */
- (void)weixinPayDidSucceed;
/**
 *  微信支付失败
 */
- (void)weixinPayDidFailWithFailType:(EVPayFailedType)failType
                         failMessage:(NSString *)failMessage;
/**
 *  苹果支付成功
 */
- (void)appPayDidSucceedWithEcoin:(NSInteger)ecoin;
/**
 *  苹果支付失败
 */
- (void)appPayDidFailWithFailType:(EVPayFailedType)failType
                      failMessage:(NSString *)failMessage;

/**
 *  连接iTunesStore成功
 */
- (void)appPayInProcessing;

@end

@interface EVPayManager : NSObject

@property (weak, nonatomic) id<EVPayManagerDelegate> delgate;  /**< 代理 */

/**
 *  管理支付的单例v
 */
+ (instancetype)sharedManager;
/**
 *  微信支付
 *
 *  @param product 要购买的产品
 */
- (void)payByWeiXinWithOder:(EVProductInfoModel *)product;
/**
 *  取消微信支付
 */
- (void)cancelWeiXinPay;
/**
 *  苹果支付
 *
 *  @param product 要购买的产品
 */
- (void)payByInAppPurchase:(EVProductInfoModel *)product;
/**
 *  取消苹果支付
 */
- (void)cancelInAppPay;
/**
 *  取消所有支付
 */
- (void)cancelPay;

/**
 *  检测是否有购买成功的产品没有提交到自己的服务器，如果有把它们提交到服务器
 */
- (void)checkWhetherAnyBuyedProductDoNotUploadToServerAndThenPushThem;

@end
