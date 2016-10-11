//
//  EVBaseToolManager+EVMessageAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"

@interface EVBaseToolManager (EVMessageAPI)

- (void)GETMessageRedEnvelopeCode:(NSString *)code
                             open:(NSInteger)open
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(NSDictionary *retinfo))successBlock
                    sessionExpire:(void(^)())sessionExpireBlock;


/**
 *  小秘书和新朋友的消息体
 *
 *  @param startBlock          开始请求
 *  @param failBlock           错误
 *  @param successBlock        成功
 *  @param sessionExpiredBlock session过期
 */
- (void)GETMessagegrouplistStart:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(id messageData))successBlock
                  sessionExpired:(void(^)())sessionExpiredBlock;


//小秘书消息体
- (void)GETMessageitemlistStart:(NSInteger)start
                          count:(NSInteger)count
                        groupid:(NSString *)groupid
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(id messageData))successBlock;


/**
 *  获取小秘书和新朋友的未读消息数
 *
 *  @param start        0
 *  @param startBlock   开始
 *  @param failBlock    错误
 *  @param successBlock 成功
 */
-(void)GETMessageunreadcountStart:(NSInteger)start
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(id messageData))successBlock;
@end
