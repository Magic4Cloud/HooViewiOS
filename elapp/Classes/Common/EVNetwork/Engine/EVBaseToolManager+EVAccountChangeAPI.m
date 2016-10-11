//
//  EVBaseToolManager+EVAccountChangeAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVAccountChangeAPI.h"
#import "constants.h"
#import "EVHttpURLManager.h"
#import "NSString+Extension.h"

@implementation EVBaseToolManager (EVAccountChangeAPI)


// http://115.29.109.121/mediawiki/index.php?title=Modifypassword
- (void)POSTModifyPasswordWithOldPwd:(NSString *)oldPwd
                              newPwd:(NSString *)newPwd
                          startBlock:(void(^)())startBlock
                                fail:(void(^)(NSError *error))failBlock
                             success:(void(^)(NSDictionary *dict))successBlock
                       sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    
    if ( oldPwd == nil || newPwd == nil )
    {
        if ( failBlock )
        {
            failBlock(nil);
        }
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID
              forKey:kSessionIdKey];
    [params setValue:[oldPwd md5String]forKey:kOldPwdKey];
    [params setValue:[newPwd md5String]forKey:KNewPwdKey];
    NSString *url = [EVHttpURLManager httpsFullURLStringWithURI:EVModifyPasswordAPI
                                             params:params];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self jsonPostWithURLString:url
                         params:nil
                          start:startBlock
                           fail:failBlock
                        success:^(NSData *data)
     {
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
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if (failBlock)
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

- (void)GETAuthPhoneChangeWithPhone:(NSString *)phone
                         startBlock:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *dict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID
              forKey:kSessionIdKey];
    [params setValue:phone
              forKey:kToken];
    
    NSString *url = [EVHttpURLManager httpsFullURLStringWithURI:EVAuthPhoneChangeAPI
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
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if (failBlock)
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
@end
