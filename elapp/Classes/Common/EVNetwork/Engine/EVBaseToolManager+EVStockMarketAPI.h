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
    EVCollectTypeNews = 1,//咨询
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

- (void)GETUserCollectType:(EVCollectType)type
                      code:(NSString *)code
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


@end
