//
//  EVBaseToolManager+EVStockMarketAPI.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager.h"



// 定义解除绑定的类型
typedef NS_ENUM(NSUInteger, EVCollectType)
{
    EVCollectTypeNews = 1,//资讯
    EVCollectTypeVideo,//视频
    EVCollectTypeIndex,//指数
    EVCollectTypeStock,//股票
};

@interface EVBaseToolManager (EVStockMarketAPI)
- (void)GETRequestHSuccess:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

- (void)GETRequestGlobalSuccess:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

- (void)GETRequestTodayFloatMarket:(NSString *)market Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;


- (void)GETRequestSelfStockList:(NSString *)userid Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

//添加自选
- (void)GETAddSelfStocksymbol:(NSString *)symbol
                         type:(int)type
                       userid:(NSString *)userid
                      Success:(void (^) (NSDictionary *retinfo))success
                        error:(void (^)(NSError *error))error;

//是否已添加自选
- (void)GETIsAddSelfStockSymbol:(NSString *)symbol
                         userid:(NSString *)userid
                        Success:(void (^) (NSDictionary *retinfo))success
                          error:(void (^)(NSError *error))error;

//判断文章是否收藏
- (void)GETUserCollectType:(EVCollectType)type
                      code:(NSString *)code
                    action:(int)action
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *retinfo))successBlock
             sessionExpire:(void(^)())sessionExpireBlock;

//收藏文章
- (void)GETNewsCollectNewsid:(NSString *)newsid
                      action:(int)action
                       start:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(NSDictionary *retinfo))successBlock
               sessionExpire:(void(^)())sessionExpireBlock;


- (void)GETUserCollectListType:(EVCollectType)type
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *retinfo))successBlock
             sessionExpire:(void(^)())sessionExpireBlock;
- (void)GETUserHistoryType:(EVCollectType)type
                      code:(NSString *)code
                    action:(int)action
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *retinfo))successBlock
             sessionExpire:(void(^)())sessionExpireBlock;

- (void)GETUserHistoryListType:(EVCollectType)type
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock;

//http://openapi.hooview.com/tushare/get_realtime_quotes?quote=000001,000586

- (void)GETRealtimeQuotes:(NSString *)quote success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

- (void)POSTStockCommentContent:(NSString *)content
                      stockCode:(NSString *)stockcode
                         userID:(NSString *)userid
                       userName:(NSString *)username
                     userAvatar:(NSString *)useravatar
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *retinfo))successBlock;

/**
 新版我的收藏

 @param start 开始位置
 @param count 数据条数
 @param userId 查询对象的用户ID
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)GETUserCollectListsWithStart:(NSString *)start count:(NSString *)count userId:(NSString *)userId fail:(void(^)(NSError *error))failBlock
                             success:(void(^)(NSDictionary *retinfo))successBlock
                       sessionExpire:(void(^)())sessionExpireBlock;

/**
 新版添加浏览历史记录

 @param newsId 新闻id
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)ADDHistoryWithNewsId:(NSString *)newsId fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
               sessionExpire:(void(^)())sessionExpireBlock;

/**
 新版视频浏览历史记录添加

 @param vid 视频id
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)ADDHistoryWithWatchVid:(NSString *)vid fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock;
/**
 新版历史记录

 @param type 0 视频  1文章
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)GETUserHistoryListTypeNew:(int)type start:(NSString *)start count:(NSString *)count fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
                    sessionExpire:(void(^)())sessionExpireBlock;

/**
 清除历史记录

 @param type 类型（0，直播记录；1，文章记录）
 @param failBlock
 @param successBlock
 @param sessionExpireBlock
 */
- (void)GETCleanhistoryWithType:(NSString *)type fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
                  sessionExpire:(void(^)())sessionExpireBlock;

@end
