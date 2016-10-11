//
//  EVBaseToolManager+EVFindFreindsAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


typedef enum : NSUInteger {
    LikeTypeUnlike, // 取消赞
    LikeTypeLike,   // 点赞
} LikeType;
@interface EVBaseToolManager (EVFindFreindsAPI)

/**
 *  获取发现主播页的接口
 *
 *  @param start        从第几条开始
 *  @param count        总共请求的个数
 *  @param startBlock   开始请求
 *  @param failBlock    请求失败
 *  @param successBlock 请求成功
 *
 *  @return
 */
- (void)GETFriendCircleStart:(NSInteger)start
                       count:(NSInteger)count
                       start:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(id messageData))successBlock
                essionExpire:(void(^)())sessionExpireBlock;



@end
