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
                                             params:nil];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
                                             params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}
@end
