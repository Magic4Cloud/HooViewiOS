//
//  EVBaseToolManager+EVStartAppAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//
//  EVBaseToolManager+EVStartAppAPI.m
//
//  Created by 杨尚彬 on 16/7/18.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager+EVStartAppAPI.h"
#import "NSString+Extension.h"
#import "constants.h"
#import "EVHttpURLManager.h"


@implementation EVBaseToolManager (EVStartAppAPI)

//分类接口
- (NSString *)GETNewtopicWithStart:(void(^)())startBlock
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
                                                          params:params];
    
    return  [self  requestWithURLString:urlString start:startBlock fail:failBlock success:^(NSData *data) {
        if ( data )
        {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:NULL];
            CCLog(@"%@", info);
            if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
            {
                if ( successBlock )
                {
                    successBlock(info[kRetinfoKey]);
                }
            }
            else if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
            {
                if ( sessionExpiredBlock )
                {
                    sessionExpiredBlock();
                }
            }
            else if (failBlock)
            {
                failBlock([NSError cc_errorWithDictionary:info]);
            }
        }
        else if (failBlock)
        {
            NSError *err = nil;
            failBlock(err);
        }
    }];
}

//分类接口
- (NSString *)GETGoodsListWithStart:(void(^)())startBlock
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
                                                          params:params];
    
    return  [self  requestWithURLString:urlString start:startBlock fail:failBlock success:^(NSData *data) {
        if ( data )
        {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:NULL];
            CCLog(@"%@", info);
            if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
            {
                if ( successBlock )
                {
                    successBlock(info[kRetinfoKey]);
                }
            }
            else if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
            {
                if ( sessionExpiredBlock )
                {
                    sessionExpiredBlock();
                }
            }
            else if (failBlock)
            {
                failBlock([NSError cc_errorWithDictionary:info]);
            }
        }
        else if (failBlock)
        {
            NSError *err = nil;
            failBlock(err);
        }
    }];
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
                                        params:params];
    [self requestWithURLString:url
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:NULL];
             //                    CCLog(@"%@", info);
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if (failBlock)
             {
                 failBlock(nil);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}



@end
