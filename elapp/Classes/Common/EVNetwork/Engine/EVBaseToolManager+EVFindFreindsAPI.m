//
//  EVBaseToolManager+EVFindFreindsAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVFindFreindsAPI.h"
#import "constants.h"
#import "EVHttpURLManager.h"
@implementation EVBaseToolManager (EVFindFreindsAPI)


- (void)GETFriendCircleStart:(NSInteger)start
                       count:(NSInteger)count
                       start:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(id messageData))successBlock
                essionExpire:(void(^)())sessionExpireBlock
{
    
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( !sessionID && sessionExpireBlock)
    {
        sessionExpireBlock();
        return;
    }
    params[kSessionIdKey] = sessionID;
    [params setValue:@(start)
              forKey:kStart];
    [params setValue:@(count)
              forKey:kCount];
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVFriendcircleAPI
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
                     NSDictionary *retinfo = info[kRetinfoKey];
                     successBlock(retinfo);
                 }
             }
             else if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if ( failBlock )
             {
                 failBlock([NSError errorWithDomain:kBaseToolDomain
                                               code:-1
                                           userInfo:@{kCustomErrorKey: k_REQUST_FAIL}]);
             }
         }
     }];
}



@end
