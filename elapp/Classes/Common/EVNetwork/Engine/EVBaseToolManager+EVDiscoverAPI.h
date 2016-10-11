//
//  EVBaseToolManager+EVDiscoverAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"

@interface EVBaseToolManager (EVDiscoverAPI)

/**
 *  排行榜接口
 *
 *  @param start              分页 0
 *  @param count              数量
 *  @param type               周榜(week) 月榜(monthall) 月榜(all)
 *  @param startBlock         开始
 *  @param failBlock          错误
 *  @param successBlock       成功
 *  @param sessionExpireBlock session过期
 */
- (void)GETObtainAssetsranklist:(NSInteger)start
                          count:(NSInteger)count
                           type:(NSString *)type
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *messageData))successBlock
                  sessionExpire:(void(^)())sessionExpireBlock;

@end
