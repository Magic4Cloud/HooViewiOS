//
//  EVUserAsset.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

@interface EVUserAsset : EVBaseObject

@property (nonatomic, assign) NSInteger daybarley;  /**< 今日薏米数 */
@property (nonatomic, assign) NSInteger barley;     /**< 总薏米数 */
@property (nonatomic, assign) NSInteger ecoin;      /**< 火眼豆数目 */
@property (nonatomic, assign) NSInteger riceroll;   /**< 火眼币数目 */
@property (nonatomic, assign) NSInteger limitcash;  /**< 今日限定可提现数目 */
@property (nonatomic, assign) NSInteger cash;       /**< 可提现数目，单位分，int */
@property (nonatomic, assign) CGFloat feerate;       /**< 利率 */
@property (assign, nonatomic) NSInteger cashstatus; /**< 是否可提现 */



@end
