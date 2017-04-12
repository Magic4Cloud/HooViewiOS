//
//  EVBaseToolManager+EVNewsAPI.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager.h"

@interface EVBaseToolManager (EVNewsAPI)


- (void)POSTNewsCommentContent:(NSString *)content
                     stockCode:(NSString *)stockcode
                        userID:(NSString *)userid
                      userName:(NSString *)username
                    userAvatar:(NSString *)useravatar
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock;


- (void)GETNewsRequestStart:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

- (void)GETFastNewsRequestStart:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

- (void)GETEyesNewsRequestChannelid:(NSString *)channelid Programid:(NSString *)programid start:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

//自选新闻
- (void)GETChooseNewsRequestStart:(NSString *)start
                            count:(NSString *)count
                           userid:(NSString *)userid
                          Success:(void (^) (NSDictionary *retinfo))success
                            error:(void (^)(NSError *error))error;

//专栏
- (void)GETSpeciaColumnNewsRequestStart:(NSString *)start
                                  count:(NSString *)count
                                Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;


- (void)GETNewsCommentListnewsId:(NSString *)vid
                            start:(NSString *)start
                            count:(NSString *)count
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(NSDictionary *retinfo))successBlock;

- (void)GETNewsDetailNewsID:(NSString *)newsid fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock;

//- (void)GETConsultNewsRequestSymbol:(NSString *)symbol
//                              Start:(NSString *)start
//                              count:(NSString *)count
//                            Success:(void (^) (NSDictionary *retinfo))success
//                              error:(void (^)(NSError *error))error;

- (void)GETConsultNewsRequestSymbol:(NSString *)symbol
                              Start:(NSString *)start
                              count:(NSString *)count
                             userid:(NSString *)userid
                            Success:(void (^) (NSDictionary *retinfo))success
                              error:(void (^)(NSError *error))error;

- (void)GETCollectUserNewsID:(NSString *)newsid start:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;
@end
