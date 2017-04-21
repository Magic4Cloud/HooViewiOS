//
//  EVBaseToolManager+EVStockMarketAPI.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVHttpURLManager.h"
@implementation EVBaseToolManager (EVStockMarketAPI)
- (void)GETRequestHSuccess:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVMarketQuotesAPI];
    
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:nil success:success fail:error];
}

- (void)GETRequestGlobalSuccess:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
     NSString *urlString = [NSString stringWithFormat:@"%@",EVMarketGlobalAPI];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:nil success:success fail:error];
    
}

- (void)GETRequestTodayFloatMarket:(NSString *)market Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@",EVAllTodayAPI];
    if (market) {
        param[@"market"] = market;
    }
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}


- (void)GETRequestSelfStockList:(NSString *)userid
                        Success:(void (^) (NSDictionary *retinfo))success
                          error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@",EVStockListAPI];
    if (userid) {
        param[@"userid"] = userid;
    }
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}


//添加自选
- (void)GETAddSelfStocksymbol:(NSString *)symbol
                     type:(int)type
                     userid:(NSString *)userid
                    Success:(void (^) (NSDictionary *retinfo))success
                      error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@",EVAddSelfStockAPI];
    if (userid) {
        [param setValue:userid forKey:@"userid"];
        [param setValue:@(type) forKey:@"type"];
        [param setValue:symbol forKey:@"symbol"];
    }
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

//是否已添加自选
- (void)GETIsAddSelfStockSymbol:(NSString *)symbol
                       userid:(NSString *)userid
                      Success:(void (^) (NSDictionary *retinfo))success
                        error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@",EVIsAddSelfStockAPI];
    if (userid) {
        [param setValue:userid forKey:@"userid"];
        [param setValue:symbol forKey:@"symbol"];
    }
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}




- (void)GETUserCollectType:(EVCollectType)type
                      code:(NSString *)code
                    action:(int)action
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *retinfo))successBlock
             sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:sessionID forKey:@"sessionid"];
    [params setValue:@(action) forKey:@"action"];
    [params setValue:code forKey:@"code"];
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVCollectAPI
                                                    params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}


- (void)GETUserCollectListType:(EVCollectType)type
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:sessionID forKey:@"sessionid"];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVCollectListAPI
                                                    params:nil];
    NSLog(@"url:%@\nparams:%@",url,params);
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}



- (void)GETUserHistoryType:(EVCollectType)type
                      code:(NSString *)code
                    action:(int)action
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *retinfo))successBlock
             sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:sessionID forKey:@"sessionid"];
    [params setValue:@(action) forKey:@"action"];
    [params setValue:code forKey:@"code"];
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVHistoryAPI
                                                    params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}


- (void)GETUserHistoryListType:(EVCollectType)type
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:sessionID forKey:@"sessionid"];
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVHistoryList
                                                    params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}
//新版历史记录
- (void)GETUserHistoryListTypeNew:(int)type fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    
    
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString * uid = [self uidFromLocal];
    [params setValue:uid forKey:@"userid"];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:sessionID forKey:@"sessionid"];
    
//    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVHistoryList
//                                                    params:nil];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:EVHVHistoryListAPI parameters:params success:successBlock fail:failBlock];

}

//清除历史记录
- (void)GETCleanhistoryWithType:(NSString *)type fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *retinfo))successBlock
                    sessionExpire:(void(^)())sessionExpireBlock
{
    
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:type forKey:@"type"];
    NSString * uid = [self uidFromLocal];
    [params setValue:uid forKey:@"userid"];
    //    [params setValue:sessionID forKey:@"sessionid"];
    //    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVHistoryList
    //                                                    params:nil];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:EVCleanHistoryListAPI parameters:params success:successBlock fail:failBlock];
    
}

//新版我的收藏
- (void)GETUserCollectListsWithfail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *retinfo))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:@"sessionid"];
    NSString * uid = [self uidFromLocal];
    [params setValue:uid forKey:@"userid"];
    
    //    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVCollectListAPI
    //                                                    params:nil];
    [EVBaseToolManager GETRequestWithUrl:EVHVFavoriteListAPI parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}


- (void)GETRealtimeQuotes:(NSString *)quote success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVQueryQuotesAPI];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (quote.length > 0) {
        [params setValue:quote forKey:@"symbol"]; 
    }
   
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:params success:success fail:error];
}



- (void)POSTStockCommentContent:(NSString *)content
                        stockCode:(NSString *)stockcode
                         userID:(NSString *)userid
                       userName:(NSString *)username
                     userAvatar:(NSString *)useravatar
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)(NSDictionary *retinfo))successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:stockcode forKey:@"stockcode"];
    [params setValue:userid forKey:@"userid"];
    [params setValue:username forKey:@"username"];
    [params setValue:useravatar forKey:@"useravatar"];
    [params setValue:content forKey:@"content"];
    
//    NSString *url = [self jointUrlParam:params url:EVStockComment];
    [EVBaseToolManager POSTNotSessionWithUrl:EVStockComment params:params fileData:nil fileMineType:nil fileName:nil success:successBlock failError:failBlock];
    
}



- (NSString *)jointUrlParam:(NSMutableDictionary *)dict url:(NSString *)url
{
     NSMutableString *paramStr = [NSMutableString string];
    NSInteger paramCount = dict.count;
    __block NSInteger index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",url,paramStr];
    
    return urlStr;
}





@end
