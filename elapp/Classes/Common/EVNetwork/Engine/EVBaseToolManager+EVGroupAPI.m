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
#import "EVUserModel.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"


@implementation EVBaseToolManager (EVGroupAPI)

- (void)baseUserInfoUrlWithImuser:(NSString *)imuser success:(void(^)(NSDictionary *modelDict))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    if ( sessionID == nil )
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    if ( imuser )
    {
        params[kNameKey] = imuser;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserBaseInfoAPI
                                                          params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:nil];
}


// http://115.29.109.121/mediawiki/index.php?title=Userinfo
- (void)GETBaseUserInfoWithUname:(NSString *)uname
                           orImuser:(NSString *)imuser
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *modelDict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
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
                                              params:nil];
    
  
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}


// http://115.29.109.121/mediawiki/index.php?title=Userfollowaction
- (void)GETFollowUserWithName:(NSString *)name
                      followType:(FollowType)type
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)())successBlock
                    essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    // type = follow - > 0 -> @"unfollow"
    NSString *action = type ? @"1" : @"0";
    [params setValue:action forKey:kAction];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoFollowUserAPI
                                        params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

//点赞
- (void)GETLikeOrNotWithUserName:(NSString *)name
                            Type:(NSString *)type
                          action:(NSString *)action
                          postid:(NSString *)postid
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)())successBlock
                 essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    NSString *userid = [self uidFromLocal];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:userid forKey:@"userid"];
    [params setValue:action forKey:kAction];
    [params setValue:postid forKey:@"postid"];
    [params setValue:type forKey:@"type"];
    
    [EVBaseToolManager GETRequestWithUrl:EVHVCommentLikeOrNotAPI parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
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


- (void)userbasicinfolistWithNameList:(NSArray *)names
                               orImuserList:(NSArray *)imusers
                                      start:(void(^)())startBlock
                                       fail:(void(^)(NSError *error))failBlock
                                    success:(void(^)(NSDictionary *modelDict))successBlock
                              sessionExpire:(void(^)())sessionExpireBlock
{
//    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
//    if ( sessionID == nil )
//    {
//        return;
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[kSessionIdKey] = sessionID;
    
    if ( names )
    {
        params[@"namelist"] = [NSString stringWithArray:names];
    }
    
    if ( imusers )
    {
        params[@"namelist"] = [NSString stringWithArray:imusers];
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInfos
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}
@end
