//
//  EVBaseToolManager+EVMessageAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVMessageAPI.h"
#import "constants.h"
#import "EVHttpURLManager.h"


@implementation EVBaseToolManager (EVMessageAPI)
- (void)GETMessageRedEnvelopeCode:(NSString *)code open:(NSInteger)open start:(void (^)())startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( !sessionID )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kOpen] = [NSNumber numberWithInteger:open];
    
    if ( !code ) {
        failBlock ? failBlock(nil) : nil;
        return ;
    }
    params[kCode] = code;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVOpenRedEnvelAPI params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

//  获取招呼内的消息组列表 小秘书和新朋友
-(void)GETMessagegrouplistStart:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(id messageData))successBlock
                 sessionExpired:(void(^)())sessionExpiredBlock

{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    else if (sessionExpiredBlock)
    {
        sessionExpiredBlock();
        return;
    }
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVMessagegrouplistAPI
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
   
}


- (void)GETMessageitemlistStart:(NSInteger)start
                          count:(NSInteger)count
                        groupid:(NSString *)groupid
                          start:(void (^)())startBlock
                           fail:(void (^)(NSError *))failBlock
                        success:(void (^)(id))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( !sessionID )
    {
        return ;
    }
    params[kSessionIdKey] = sessionID;
    [params setValue:@"0" forKey:KgroupidKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVMessageitemlistAPI
                                              params:nil];
    
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}


//  获取招呼内的消息组列表 小秘书和新朋友
-(void)GETMessageunreadcountStart:(NSInteger)start
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)(id messageData))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVMessageunreadcountAPI
                                              params:nil];

    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}

@end
