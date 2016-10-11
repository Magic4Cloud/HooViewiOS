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
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    if ( uname )
    {
        params[@"namelist"] = uname;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInfos
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
             if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [info[kRetvalKye] isEqualToString:kE_VIDEO_NOT_EXISTS] )
             {
                 if ( failBlock )
                 {
                     NSError *error = [NSError errorWithDomain:kBaseToolDomain
                                                          code:-1
                                                      userInfo:@{kCustomErrorKey: kE_GlobalZH(@"user_not_exist")}];
                     failBlock(error);
                 }
             }
             else if ( failBlock )
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
