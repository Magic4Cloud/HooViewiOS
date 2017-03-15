//
//  EVBaseToolManager+EVStartAppAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseToolManager+EVStartAppAPI.h"
#import "NSString+Extension.h"
#import "constants.h"
#import "EVHttpURLManager.h"



@implementation EVBaseToolManager (EVStartAppAPI)

//分类接口
- (void)GETNewtopicWithStart:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoTopiclistAPI
                                                          params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
    

}

//分类接口
- (void)GETGoodsListWithStart:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVGoodsListAPI
                                                          params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
    

}

- (void)GETParamsWithDevType:(NSString *)devtype
                  startBlock:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(NSDictionary *dict))successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    if ( sessionID == nil )
    {
        return ;
    }
    params[kSessionIdKey] = sessionID;
    if ([devtype isNotEmpty])
    {
        [params setObject:devtype forKey:kDeviceType];
    }
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVGetParamNewAPI
                                        params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];

}



@end
