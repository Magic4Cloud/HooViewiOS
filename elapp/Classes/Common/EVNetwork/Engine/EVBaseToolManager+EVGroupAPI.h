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
- (NSDictionary *)baseUserInfoUrlWithImuser:(NSString *)imuser;

- (NSString *)GETBaseUserInfoWithUname:(NSString *)uname
                           orImuser:(NSString *)imuser
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *modelDict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;


/** 添加或者删除关注 */
- (NSString *)GETFollowUserWithName:(NSString *)name
                      followType:(FollowType)type
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)())successBlock
                    essionExpire:(void(^)())sessionExpireBlock;

- (void)logoUrlWithImuser:(NSString *)imuser completion:(void(^)(NSString *logourl,NSString *name))completion;

- (NSString *)userbasicinfolistWithNameList:(NSArray *)names
                               orImuserList:(NSArray *)imusers
                                      start:(void(^)())startBlock
                                       fail:(void(^)(NSError *error))failBlock
                                    success:(void(^)(NSDictionary *modelDict))successBlock
                              sessionExpire:(void(^)())sessionExpireBlock;
@end
