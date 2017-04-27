//
//  EVBaseToolManager+MyShopAPI.m
//  elapp
//
//  Created by 唐超 on 4/21/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVBaseToolManager+MyShopAPI.h"

@implementation EVBaseToolManager (MyShopAPI)

- (void)GETMyShopsWithType:(NSString *)type start:(NSString *)start count:(NSString *)count fail:(void (^)(NSError * error))failBlock success:(void (^)(NSDictionary * retinfo))successBlock
                 sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    NSString * uid = [self uidFromLocal];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:start forKey:@"start"];
    [params setValue:count forKey:@"count"];
    [params setValue:type forKey:@"type"];
    [params setValue:uid forKey:@"userid"];
    if ([sessionID isKindOfClass:[NSString class]]&&
        sessionID.length > 0)
    {
        params[kSessionIdKey] = sessionID;
    }
    else
    {
        return;
    }
    
    [EVBaseToolManager GETNotVerifyRequestWithUrl:EVMyShopsAPI parameters:params success:successBlock fail:failBlock];

}
@end
