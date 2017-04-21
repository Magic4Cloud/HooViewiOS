//
//  EVBaseToolManager+MyShopAPI.h
//  elapp
//
//  Created by 唐超 on 4/21/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVBaseToolManager.h"

/**
 我的购买 api
 */
@interface EVBaseToolManager (MyShopAPI)


/**
 我的购买

 @param type 类型（0，直播；1，精品视频；2，秘籍）
 @param start 起始点
 @param count 数量
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)GETMyShopsWithType:(NSString *)type start:(NSString *)start count:(NSString *)count fail:(void (^)(NSError * error))failBlock success:(void (^)(NSDictionary * retinfo))successBlock
             sessionExpire:(void (^)())sessionExpireBlock;
@end
