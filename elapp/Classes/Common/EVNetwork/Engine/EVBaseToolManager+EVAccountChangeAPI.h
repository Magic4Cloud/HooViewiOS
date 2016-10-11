//
//  EVBaseToolManager+EVAccountChangeAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"

@interface EVBaseToolManager (EVAccountChangeAPI)

/**
 *  更改密码
 *
 *  @param oldPwd             旧密码
 *  @param newPwd             新密码
 *  @param startBlock         开始请求的回调
 *  @param failBlock          成功的回调
 *  @param successBlock       失败的回调
 *  @param sessionExpireBlock session过期的回调
 *
 *  @return 请求地址
 */
- (void)POSTModifyPasswordWithOldPwd:(NSString *)oldPwd
                              newPwd:(NSString *)newPwd
                          startBlock:(void(^)())startBlock
                                fail:(void(^)(NSError *error))failBlock
                             success:(void(^)(NSDictionary *dict))successBlock
                       sessionExpire:(void(^)())sessionExpireBlock;


/**
 *  更换手机号
 *
 *  @param phone              新手机号
 *
 *  @return
 */
- (void)GETAuthPhoneChangeWithPhone:(NSString *)phone
                         startBlock:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *dict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;

@end
