//
//  EVBaseToolManager+EVHomeAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVHomeAPI.h"
#import "constants.h"
#import "EVNowVideoItem.h"
#import "EVHttpURLManager.h"

#define kMaxid @"maxid"



@implementation EVBaseToolManager (EVHomeAPI)


- (void)GETNewTopicVideolistStart:(NSInteger)start
                         count:(NSInteger)count
                       topicid:(NSString *)topicid
                         start:(void(^)())startBlock
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
    params[kStart] = @(start);
    params[kCount] = @(count);
    params[kTopicidKey] = topicid;
    params[kLive] = @(1);
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVTopicVideo
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
                 NSError *err = nil;
                 failBlock(err);
             }
         }
         else if (failBlock)
         {
             NSError *err = nil;
             failBlock(err);
         }
     }];
}
//话题视频列表
//http://115.29.109.121/mediawiki/index.php?title=Liverecommendlist
- (void)GETTopicVideolistStart:(NSInteger)start
                         count:(NSInteger)count
                       topicid:(NSString *)topicid
                         start:(void(^)())startBlock
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
    params[kStart] = @(start);
    params[kCount] = @(count);
    params[kTopicidKey] = topicid;
    params[kLive] = @(1);
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVTopicVideo
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
                 NSError *err = nil;
                 failBlock(err);
             }
         }
         else if (failBlock)
         {
             NSError *err = nil;
             failBlock(err);
         }
     }];
}



// http://115.29.109.121/mediawiki/index.php?title=Carouselinfo
- (void)GETCarouselInfoWithStart:(void (^)())startBlock
                         success:(void (^)(NSDictionary *info))successBlock
                            fail:(void (^)(NSError *error))failBlock
                   sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionId = [self getSessionIdWithBlock:sessionExpireBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (sessionId)
    {
        params[kSessionIdKey] = sessionId;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVCarouselInfo
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
             CCLog(@"%@", info);
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
                 failBlock(nil);
             }
         }
         else if ( failBlock )
         {
             failBlock(nil);
         }
     }];
}




@end
