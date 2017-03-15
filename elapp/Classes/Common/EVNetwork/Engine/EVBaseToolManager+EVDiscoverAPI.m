//
//  EVBaseToolManager+EVDiscoverAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVDiscoverAPI.h"
#import "constants.h"
#import "EVHttpURLManager.h"


@implementation EVBaseToolManager (EVDiscoverAPI)

- (void)GETObtainAssetsranklist:(NSInteger)start
                          count:(NSInteger)count
                           type:(NSString *)type
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *messageData))successBlock
                  sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( !sessionID )
    {
        sessionExpireBlock();
        return;
    }
    params[kSessionIdKey] = sessionID;
    [params setValue:type forKey:@"type"];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVAssetsranklistAPI
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}

@end
