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
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVOpenRedEnvelAPI params:params];
    [self requestWithURLString:urlString
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue]
                 && sessionExpireBlock )
             {
                 sessionExpireBlock();
             }
             
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if (successBlock) {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else
             {
                 failBlock([NSError cc_errorWithDictionary:info]);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
                                              params:params];
    [self requestWithURLString:urlString
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             CCLog(@"%@",info);
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             } else if ( failBlock )
             {
                 failBlock([NSError errorWithDomain:kBaseToolDomain
                                               code:-1
                                           userInfo:@{kCustomErrorKey: k_REQUST_FAIL}]);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
         
     }];
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
    [params setValue:groupid forKey:KgroupidKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVMessageitemlistAPI
                                              params:params];
    [self requestWithURLString:urlString
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             CCLog(@"%@",info);
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     NSDictionary *retinfo = info[kRetinfoKey];
                     successBlock(retinfo);
                 }
             }
             else if ( failBlock )
             {
                 failBlock([NSError errorWithDomain:kBaseToolDomain
                                               code:-1
                                           userInfo:@{kCustomErrorKey: k_REQUST_FAIL}]);
             }
         }
         else if ( failBlock )
         {
             failBlock(nil);
         }
     }];
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
                                              params:params];
    [self requestWithURLString:urlString
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             CCLog(@"%@",info);
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( failBlock )
             {
                 failBlock([NSError errorWithDomain:kBaseToolDomain
                                               code:-1
                                           userInfo:@{kCustomErrorKey: k_REQUST_FAIL}]);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}

@end
