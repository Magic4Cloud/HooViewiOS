//
//  EVBaseToolManager+EVGroupAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVGroupAPI.h"
#import "EVHttpURLManager.h"
#import "constants.h"
#import "ASIFormDataRequest.h"
#import "EVUserModel.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"

@implementation EVBaseToolManager (EVGroupAPI)

- (NSDictionary *)baseUserInfoUrlWithImuser:(NSString *)imuser
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    if ( imuser )
    {
        params[kNameKey] = imuser;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserBaseInfoAPI
                                                          params:params];
    ASIHTTPRequest *request = [self startSynchronousRequestWithURLString:urlString];
    NSData *data = request.responseData;
    if ( data )
    {
        return [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:NULL];
    }
    return nil;
}


// http://115.29.109.121/mediawiki/index.php?title=Userinfo
- (NSString *)GETBaseUserInfoWithUname:(NSString *)uname
                           orImuser:(NSString *)imuser
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *modelDict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    if ( uname )
    {
        params[kNameKey] = uname;
    }
    
    if ( imuser )
    {
        params[kNameKey] = imuser;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserBaseInfoAPI
                                              params:params];
    
    return [self requestWithURLString:urlString
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
                                                             userInfo:@{kCustomErrorKey: @"该用户不存在"}];
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


// http://115.29.109.121/mediawiki/index.php?title=Userfollowaction
- (NSString *)GETFollowUserWithName:(NSString *)name
                      followType:(FollowType)type
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)())successBlock
                    essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    // type = follow - > 0 -> @"unfollow"
    NSString *action = type ? @"1" : @"0";
    [params setValue:action forKey:kAction];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoFollowUserAPI
                                        params:params];
    return [self requestWithURLString:url
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
                            successBlock();
                        }
                        [EVUserModel updateFollowStateWithName:name followed:type completet:nil];
                        [CCNotificationCenter postNotificationName:CCFollowedStateChangedNotification
                                                            object:nil
                                                          userInfo:@{kNameKey:name,
                                                                     kFollow:@(type)}];
                    }
                    else if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
                    {
                        if ( sessionExpireBlock )
                        {
                            sessionExpireBlock();
                        }
                    }
                    else
                    {
                        CCLog(@"Request not work properly!");
                        if (failBlock)
                        {
                            failBlock(nil);
                        }
                    }
                }
                else if (failBlock)
                {
                    failBlock(nil);
                }
            }];
}





- (NSString *)filePathWithString:(NSString *)string
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *logourlsDirPath = [cachePath stringByAppendingString:@"/chat_group"];
    NSString *currentPath = [NSString stringWithFormat:@"%@_%@.plist",string,[EVLoginInfo localObject].name];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logourlsDirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logourlsDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [logourlsDirPath stringByAppendingPathComponent:currentPath];
}

- (void)logoUrlWithImuser:(NSString *)imuser completion:(void(^)(NSString *logourl,NSString *name))completion
{
    if ( imuser == nil )
    {
        return;
    }
    NSString *logoFilePath = [self filePathWithString:@"logourl"];
    NSString *nameFilePath = [self filePathWithString:@"name"];
    NSDictionary *logoDic = [NSDictionary dictionaryWithContentsOfFile:logoFilePath];
    NSDictionary *nameDic = [NSDictionary dictionaryWithContentsOfFile:nameFilePath];
    if ( logoDic == nil )
    {
        logoDic = [NSDictionary dictionary];
    }
    if ( nameDic == nil )
    {
        nameDic = [NSDictionary dictionary];
    }
    NSString *logourl = [logoDic objectForKey:imuser];
    NSString *name = [nameDic objectForKey:imuser];
    if ( logourl && name)
    {
        if ( completion )
        {
            completion(logourl,name);
        }
    }
    else
    {
        [self GETBaseUserInfoWithUname:nil orImuser:imuser start:nil fail:nil success:^(NSDictionary *modelDict) {
            NSString *ulogo = [modelDict objectForKey:@"logourl"];
            NSString *uName = [modelDict objectForKey:@"name"];
            if ( ulogo && uName )
            {
                if ( completion )
                {
                    completion(ulogo,uName);
                }
                // logoURL写入本地
                NSDictionary *logoDic_cp = [logoDic mutableCopy];
                [logoDic_cp setValue:ulogo forKey:imuser];
                [logoDic_cp writeToFile:logoFilePath atomically:YES];
                
                // name写入本地
                NSDictionary *nameDic_cp = [nameDic mutableCopy];
                [nameDic_cp setValue:uName forKey:imuser];
                [nameDic_cp writeToFile:nameFilePath atomically:YES];
            }
        } sessionExpire:nil];
    }
}


- (NSString *)userbasicinfolistWithNameList:(NSArray *)names
                               orImuserList:(NSArray *)imusers
                                      start:(void(^)())startBlock
                                       fail:(void(^)(NSError *error))failBlock
                                    success:(void(^)(NSDictionary *modelDict))successBlock
                              sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    if ( names )
    {
        params[@"namelist"] = [NSString stringWithArray:names];
    }
    
    if ( imusers )
    {
        params[@"namelist"] = [NSString stringWithArray:imusers];
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInfos
                                              params:params];
    return [self requestWithURLString:urlString
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
                    else if ( failBlock )
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
