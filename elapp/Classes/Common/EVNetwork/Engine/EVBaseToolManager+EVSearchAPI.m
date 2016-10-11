//
//  EVBaseToolManager+EVSearchAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVSearchAPI.h"
#import "constants.h"
#import "EVHttpURLManager.h"


@implementation EVBaseToolManager (EVSearchAPI)

// http://115.29.109.121/mediawiki/index.php?title=Searchinfos
- (void)getSearchInfosWith:(NSString *)keyword
                      type:(NSString *)type
                     start:(NSInteger)start
                     count:(NSInteger)count
                startBlock:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *dict))successBlock
             sessionExpire:(void(^)())sessionExpireBlock
               reterrBlock:(void(^)(NSString *reterr))reterrBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    params[kSessionIdKey] = sessionID;
    [params setValue:type forKey:kType];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    [params setValue:keyword forKey:kKeyWord];
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVSearchInfosAPI
                                              params:params];
    
    [self requestWithURLString:urlString
                         start:startBlock
                          fail:failBlock
                       success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
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
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if (failBlock)
             {
                 NSString *reterr = [NSString stringWithFormat:@"%@",info[@"reterr"]];
                 reterrBlock(reterr);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}

@end
