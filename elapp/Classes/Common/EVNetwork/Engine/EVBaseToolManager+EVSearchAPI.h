//
//  EVBaseToolManager+EVSearchAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


typedef NS_ENUM(NSInteger ,EVSearchType){
    EVSearchTypeNews = 0,
    EVSearchTypeLive,
    EVSearchTypeStock,
};
@interface EVBaseToolManager (EVSearchAPI)

/**
 *  全局搜索
 *
 *  @param keyword            搜索关键字
 *  @param type               搜索类型：“all/user/live/video” 代表“全部/主播用户/直播视频/录播视频”
 *  @param start              从第几个开始，type为all时无效
 *  @param count              需要请求的条数
 *
 */
- (void)getSearchInfosWith:(NSString *)keyword
                      type:(EVSearchType)type
                     start:(NSInteger)start
                     count:(NSInteger)count
                startBlock:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *dict))successBlock
             sessionExpire:(void(^)())sessionExpireBlock
               reterrBlock:(void(^)(NSString *reterr))reterrBlock;

@end
