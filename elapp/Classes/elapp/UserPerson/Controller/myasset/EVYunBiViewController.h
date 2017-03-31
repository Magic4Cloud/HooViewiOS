//
//  EVYunBiViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
@class EVUserAsset;

@protocol EVYiBiViewControllerDelegate <NSObject>

/**
 *  成功购买火眼豆
 *
 *  @param ecoin 用户的火眼豆总数
 */
- (void)buySuccessWithEcoin:(NSInteger)ecoin;

@end

/**
 充值  界面
 */
@interface EVYunBiViewController : EVViewController

@property (strong, nonatomic) EVUserAsset *asset;  /**< 用户资产信息 */

@property (weak, nonatomic) id<EVYiBiViewControllerDelegate> delegate;  /**< 代理 */

@property (nonatomic, assign) BOOL isPresented;   //是否是模态出来的
@property (nonatomic, copy  ) void(^updateEcionBlock)(NSString *ecion);     /**< 更新火眼豆的回调 */
@end
