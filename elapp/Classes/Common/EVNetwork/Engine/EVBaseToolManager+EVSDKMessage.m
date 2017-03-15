//
//  EVBaseToolManager+EVSDKMessage.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVSDKMessage.h"
#import "EVHttpURLManager.h"
#import "constants.h"



@implementation EVBaseToolManager (EVSDKMessage)

- (void)GETBaseUserInfoListWithUname:(NSString *)uname
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *modelDict))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock
{
//    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
//    if ( sessionID == nil )
//    {
//        return ;
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[kSessionIdKey] = sessionID;
    
    if ( uname )
    {
        params[@"namelist"] = uname;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInfos
                                                          params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
}
@end
