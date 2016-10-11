//
//  EVBaseToolManager+EVHomeAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//
//  EVBaseToolManager+EVHomeAPI.h
//
//  Created by 杨尚彬 on 16/7/18.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager.h"


//Recommend
typedef NS_ENUM(NSInteger, CCHomeWatchListType){
    CCHomeWatchListPopular,
    CCHomeWatchListFollow,
    CCHomeWatchListSearch
};

@interface EVBaseToolManager (EVHomeAPI)
- (void)GETNewTopicVideolistStart:(NSInteger)start
                            count:(NSInteger)count
                          topicid:(NSString *)topicid
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(NSDictionary *info))successBlock
                   sessionExpired:(void(^)())sessionExpiredBlock;
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







/** 推荐页轮播图 */
- (void)GETCarouselInfoWithStart:(void(^)())startBlock
                         success:(void(^)(NSDictionary *info))successBlock
                            fail:(void(^)(NSError *))failBlock
                   sessionExpire:(void(^)())sessionExpireBlock;











@end
