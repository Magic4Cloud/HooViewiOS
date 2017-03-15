//
//  EVBaseToolManager+EVGroupAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

@interface EVBaseToolManager (EVGroupAPI)
- (void)baseUserInfoUrlWithImuser:(NSString *)imuser success:(void(^)(NSDictionary *modelDict))successBlock;

- (void)GETBaseUserInfoWithUname:(NSString *)uname
                           orImuser:(NSString *)imuser
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *modelDict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;


/** 添加或者删除关注 */
- (void)GETFollowUserWithName:(NSString *)name
                      followType:(FollowType)type
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)())successBlock
                    essionExpire:(void(^)())sessionExpireBlock;

- (void)logoUrlWithImuser:(NSString *)imuser completion:(void(^)(NSString *logourl,NSString *name))completion;

- (void)userbasicinfolistWithNameList:(NSArray *)names
                               orImuserList:(NSArray *)imusers
                                      start:(void(^)())startBlock
                                       fail:(void(^)(NSError *error))failBlock
                                    success:(void(^)(NSDictionary *modelDict))successBlock
                              sessionExpire:(void(^)())sessionExpireBlock;
@end
