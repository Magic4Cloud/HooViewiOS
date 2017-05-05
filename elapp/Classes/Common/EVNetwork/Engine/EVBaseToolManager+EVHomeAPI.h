//
//  EVBaseToolManager+EVHomeAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseToolManager.h"


@interface EVBaseToolManager (EVHomeAPI)

/**
 *  热门直播视频列表
 *
 *  @param start               0 开始请求的数
 *  @param count               请求的数 20
 *  @param topicid             话题id
 *  @param startBlock          开始
 *  @param failBlock           错误
 *  @param successBlock        成功
 *  @param sessionExpiredBlock session过期
 */
- (void)GETTopicVideolistStart:(NSInteger)start
                         count:(NSInteger)count
                       topicid:(NSString *)topicid
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *info))successBlock
                sessionExpired:(void(^)())sessionExpiredBlock;





- (void)GETGoodVideoListStart:(NSString *)start count:(NSString *)count fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *info))successBlock;


//发送评论
- (void)POSTVideoCommentContent:(NSString *)content
                        topicid:(NSString *)topicid
                           type:(NSString *)type
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *info))successBlock
                 sessionExpired:(void(^)())sessionExpiredBlock;



//获取精品视频评论列表
- (void)GETVideoCommentListtopicid:(NSString *)topicid
                              type:(NSString *)type
                             start:(NSString *)start
                             count:(NSString *)count
                             start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *retinfo))successBlock;


/** 推荐页轮播图 */
- (void)GETCarouselInfoWithStart:(void(^)())startBlock
                         success:(void(^)(NSDictionary *info))successBlock
                            fail:(void(^)(NSError *))failBlock
                   sessionExpire:(void(^)())sessionExpireBlock;





- (void)GETTextLiveHomeListStart:(NSString *)start success:(void (^)(NSDictionary *info))successBlock
                            fail:(void (^)(NSError *error))failBlock;




@end
