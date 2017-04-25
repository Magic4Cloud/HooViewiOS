//
//  EVBaseToolManager+EVUserCenterAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "constants.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"
#import "EVFanOrFollowerModel.h"
#import "EVUserModel.h"
#import "EVUserVideoModel.h"
#import "EVHttpURLManager.h"
#import "EVWatchVideoInfo.h"


#define kAccountExistNeedMerge @"E_AUTH_NEED_MERGE"
#define kAccountMergeConflict @"E_AUTH_MERGE_CONFLICTS"
#define kAccountUserPhoneFormatError @"E_USER_PHONE_FORMAT"
#define kAccountMergeEServer @"E_SERVER"
#define kAccountOK @"ok"


@implementation EVBaseToolManager (EVUserCenterAPI)


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

// http://115.29.109.121/mediawiki/index.php?title=Usereditinfo
- (void)GETUsereditinfoWithParams:(NSMutableDictionary *)params
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)())successBlock
                    sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    NSString *uid = [self uidFromLocal];
#ifdef EVDEBUG
    NSAssert(sessionID, @"session id can not be nil");
#endif
    
    params = [NSMutableDictionary dictionaryWithDictionary:params];
    params[kSessionIdKey] = sessionID;
    params[@"userid"] = uid;

    [EVBaseToolManager GETRequestWithUrl:EVVideoUserEditInfoAPI parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}

// http://115.29.109.121/mediawiki/index.php?title=Useruploadlogo
- (void)GETUploadUserLogoWithImage:(UIImage *)image
                             uname:(NSString *)uname
                             start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *retinfo))successBlock
                     sessionExpire:(void(^)())sessionExpireBlock
{
    [self getUploadImageWithURI:EVVideoUploadIconAPI Image:image uname:uname start:startBlock fail:failBlock success:successBlock sessionExpire:sessionExpireBlock];
}




- (void)getUploadImageWithURI:(NSString *)uri
                        Image:(UIImage *)image
                        uname:(NSString *)uname
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)(NSDictionary *retinfo))successBlock
                sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil ) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:uri
                                              params:nil];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",uname];
    postParams[kFile] = fileName;
    NSAssert(image, @"image can not be nil");
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    //NSString *contentType = @"form/multipart";
    NSString *fileMineType = @"image/jpeg";
    [EVBaseToolManager POSTRequestWithUrl:urlString params:params fileData:data fileMineType:fileMineType fileName:@"file" success:successBlock sessionExpireBlock:sessionExpireBlock failError:failBlock];

}



// http://115.29.109.121/mediawiki/index.php?title=Userauthbind
- (void)GETUserBindWithParams:(NSDictionary *)params
                        start:(void (^)())startBlock
                         fail:(void (^)(NSError *))failBlock
                      success:(void (^)())successBlock
                sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil ) {
        return ;
    }
    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    mParams[kSessionIdKey] = sessionID;
    
    NSString *password = mParams[kPassword];
    [mParams removeObjectForKey:kPassword];
    
    NSDictionary *postParmas = nil;
    
    if ( password )
    {
        postParmas = @{kPassword : password};
    }
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoUserBind
                                                   params:nil];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    [EVBaseToolManager GETRequestWithUrl:urlString parameters:mParams success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
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
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    if ( uname )
    {
        params[kNameKey] = uname;
    }
    
    if ( imuser )
    {
        params[kImuser] = imuser;
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserBaseInfoAPI
                                              params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}


- (void)GETBaseUserInfoWithUname:(NSString *)uname
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *modelDict))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID )
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kSessionIdKey] = sessionID;
        if ( uname )
        {
            params[kNameKey] = uname;
        }
        NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserInfoAPI
                                                              params:nil];
        [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    }

}


- (void)GETUserInfoWithUname:(NSString *)uname
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
    NSString * uid = [self uidFromLocal];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[@"userid"] = uid;
    if ( uname )
    {
        params[kNameKey] = uname;
    }
    
    if ( imuser )
    {
        params[kImuser] = imuser;
    }
        
    [EVBaseToolManager GETRequestWithUrl:EVVideoUserInfoAPI parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}




// CCVideoUserPastVideoAPI
// http://115.29.109.121/mediawiki/index.php?title=Devicepastliving
- (void)devicepastlivingWithUname:(NSString *)uname
                            maxid:(NSString *)maxid
                            count:(NSInteger)count
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)())successBlock
                    sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    // params[@"uname"] = uname;
    params[kNameKey] = uname;
    params[@"maxid"] = maxid;
    params[@"count"] = @(count);
    [self getGPSInfo:params];
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserPastVideoAPI
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

// http://115.29.109.121/mediawiki/index.php?title=Userfans
- (void)userfansWithName:(NSString *)name
                   start:(NSInteger)start
                   count:(NSInteger)count
                   start:(void(^)())startBlock
                    fail:(void(^)(NSError *error))failBlock
                 success:(void(^)())successBlock
           sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kNameKey] = name;
    params[kStart] = @(start);
    params[kCount] = @(count);
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserFansAPI
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

// http://115.29.109.121/mediawiki/index.php?title=Userfollow
- (void)userfollowWithMinid:(NSString *)minid
                      count:(NSInteger)count
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)())successBlock
              sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil ) {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[@"minid"] = minid;
    params[@"count"] = @(count);
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserFollowsAPI
                                              params:nil];
  
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}



// http://115.29.109.121/mediawiki/index.php?title=Useraction
- (void)useractionWithDstuname:(NSString *)dstuname
                        follow:(BOOL)follow
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)())successBlock
                 sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kNameKey] = dstuname;
    params[kAction] = follow ? @"follow" : @"unfollow";
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoFollowUserAPI
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}







// http://115.29.109.121/mediawiki/index.php?title=Userfanlist
- (void)GETFansListWithName:(NSString *)name
                    startID:(NSInteger)start
                      count:(NSInteger)count
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSArray *fans))successBlock
               essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoUserFansAPI
                                        params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            NSArray *fans = [EVFanOrFollowerModel objectWithDictionaryArray:successDict[kUserKey]];
            successBlock(fans);
        }
    } sessionExpireBlock:sessionExpireBlock fail:failBlock];
  
}

// http://115.29.109.121/mediawiki/index.php?title=Userfollowerlist
- (void)GETFollowersListWithName:(NSString *)name
                         startID:(NSInteger)start
                           count:(NSInteger)count
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSArray *fans))successBlock
                    essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoUserFollowsAPI
                                        params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            NSArray *fans = [EVFanOrFollowerModel objectWithDictionaryArray:successDict[kUserKey]];
            successBlock(fans);
        }
    } sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

- (void)GETUserfriendlistStart:(NSInteger)start
                         count:(NSInteger)count
                        start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *result))successBlock
                  essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
        if ( sessionID == nil )
        {
                return ;
        }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoUserFollowsAPI
                                                                  params:nil];
   
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
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
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    // type = follow - > 0 -> @"unfollow"
    NSString *action = type ? @"1" : @"0";
    [params setValue:action forKey:kAction];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoFollowUserAPI
                                        params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            successBlock();
        }
        [EVUserModel updateFollowStateWithName:name followed:type completet:nil];
        [EVNotificationCenter postNotificationName:EVFollowedStateChangedNotification
                                            object:nil
                                          userInfo:@{kNameKey:name,
                                                     kFollow:@(type)}];
        
    } sessionExpireBlock:sessionExpireBlock fail:failBlock];
  
}

- (void)GETLivingFollowAnchorWithVid:(NSString *)vid
                                name:(NSString *)name
                              follow:(FollowType)type
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    NSString *action = type ? @"1" : @"0";
    [params setValue:action forKey:kAction];
    [params setValue:vid forKey:kVid];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoFollowUserAPI
                                        params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:nil sessionExpireBlock:nil fail:nil];
}


// http://115.29.109.121/mediawiki/index.php?title=Uservideolist
- (void)GETUserVideoListWithName:(NSString *)name
                            type:(NSString *)type
                           start:(NSInteger)start
                           count:(NSInteger)count
                      startBlock:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSArray *videos))successBlock
                    essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
//    if ( sessionID == nil )
//    {
//        return ;
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    [params setValue:type forKey:kType];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    [self getGPSInfo:params];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoUserPastVideoAPI
                                        params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            NSArray *videos = [EVWatchVideoInfo objectWithDictionaryArray:successDict[kVideosKey]];
            successBlock(videos);
        }
    } sessionExpireBlock:sessionExpireBlock fail:failBlock];

}


/** 获取个人中心主页直播列表数据 */
- (void)GETHVCenterVideoListWithUserid:(NSString *)userid
                                 start:(NSInteger)start
                                 count:(NSInteger)count
                            startBlock:(void(^)())startBlock
                                  fail:(void(^)(NSError *error))failBlock
                               success:(void(^)(NSDictionary *retinfo))successBlock
                          essionExpire:(void(^)())sessionExpireBlock {
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:userid forKey:kNameKey];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    
    [EVBaseToolManager GETRequestWithUrl:EVHVCenterLiveListAPI parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            successBlock(successDict);
        }
        
    } sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
}

//获取我的发布
- (void)GETMyReleaseListWithUserid:(NSString *)userid
                            type:(NSString *)type
                           start:(NSInteger)start
                           count:(NSInteger)count
                      startBlock:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *videos))successBlock
                    essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
        if ( sessionID == nil )
        {
            return ;
        }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:userid forKey:kNameKey];
    [params setValue:type forKey:kType];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
//    [self getGPSInfo:params];
    
    
//    EVVipMyReleaseAPI
    
    [EVBaseToolManager GETRequestWithUrl:EVMyReleaseAPI parameters:params success:^(NSDictionary *successDict) {
        if ( successBlock )
        {
            successBlock(successDict);
        }

    } sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
}





- (void)GETLogoutWithFail:(void(^)(NSError *error))failBlock
                  success:(void(^)())successBlock
             essionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    
    NSString *url =  [EVHttpURLManager httpsFullURLStringWithURI:EVVideoUserLogoutAPI
                                              params:nil];
 
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

-(void)GETUnbundlingtype:(EVUnbundlingAuthtype)unbundling
                   start:(void (^)())startBlock
                    fail:(void (^)(NSError *error))failBlock
                 success:(void (^)(id success))successBlock
            essionExpire:(void (^)())sessionExpireBlock
{
    
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    switch (unbundling)
    {
        case EVAccountQQ:
            [params setValue:kAuthTypeQQ
                      forKey:kType];
            break;
        case EVAccountSina:
            [params setValue:kAuthTypeSina
                      forKey:kType];
            break;
        case EVAccountWeixin:
            [params setValue:kAuthTypeWeixin
                      forKey:kType];
            break;
    }
    //    NSString *url = [self fullURLStringWithURI:CCUserAuthUnbind params:params];
    NSString *url = [EVHttpURLManager httpsFullURLStringWithURI:EVUserAuthUnbind
                                             params:nil];
    [EVBaseToolManager GETRequestWithUrl:url parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
}



- (void)GETUserSettingInfoStart:(void(^)())startBlock
                        success:(void(^)(NSDictionary *info))successBlock
                           fail:(void(^)(NSError *error))failBlock
                  sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserSettingInfo
                                              params:nil];
   
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

// http://115.29.109.121/mediawiki/index.php?title=Usersettinginfo
- (void)GETUserEditSettingWithFollow:(BOOL)follow
                             disturb:(BOOL)disturb
                                live:(BOOL)live
                               start:(void(^)())startBlock
                                fail:(void(^)(NSError *error))failBlock
                             success:(void(^)())successBlock
                       sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kFollow] = @(follow);
    params[kLive] = @(live);
    params[kDisturb] = @(disturb);
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserEditSetting
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}








//提现记录
- (void)GETWithdrawallistWithStart:(NSInteger)start
                             count:(NSInteger)count
                             start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpiredBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID ) {
        params[kSessionIdKey] = sessionID;
    }
    params[kStart] = @(start);
    params[kCount] = @(count);
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVCashoutrecordAPI
                                                   params:nil];
 
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}

- (void)GETConsumeListWithStart:(NSInteger)start
                          count:(NSInteger)count
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *info))successBlock
                 sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpiredBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID ) {
        params[kSessionIdKey] = sessionID;
    }
    params[kStart] = @(start);
    params[kCount] = @(count);
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVConsumeAPI
                                                               params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}

//充值记录
- (void)GETPrepaidRecordslistWithStart:(NSInteger)start
                                 count:(NSInteger)count
                                 start:(void(^)())startBlock
                                  fail:(void(^)(NSError *error))failBlock
                               success:(void(^)(NSDictionary *info))successBlock
                        sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpiredBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    params[kStart] = @(start);
    params[kCount] = @(count);
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVRechargerecordAPI
                                                   params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}


//充值成功回调
- (void)GETSuccessPayToServiceWithUid:(NSString *)userid
                              orderid:(NSString *)orderid
                                  rmb:(NSString *)rmb
                                start:(void(^)())startBlock
                                 fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpiredBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    [params setValue:userid forKey:@"userid"];
    [params setValue:orderid forKey:@"orderid"];
    [params setValue:rmb forKey:@"rmb"];
//    EVSuccessPayToService
    [EVBaseToolManager GETRequestWithUrl:EVSuccessPayToService parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}



// 充值选项
- (void)GETCashinOptionWith:(EVPayPlatform)plateform
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSDictionary *info))successBlock
             sessionExpired:(void(^)())sessionExpiredBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpiredBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
//    params[@"plateform"] = @(plateform);
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVCashinOptionAPI
                                                   params:nil];
    
   
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}

- (void)POSTApplevalidWith:(NSString *)receipt platfrom:(NSString *)platfrom amound:(NSString *)amound
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *info))successBlock
            sessionExpired:(void(^)())sessionExpiredBlock
{
    if ( receipt == nil )
    {
        return;
    }
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    [params setValue:receipt forKey:@"receipt"];
    [params setValue:@"apple" forKey:@"platform"];
    [params setValue:amound forKey:@"amount"];
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVAppleValidAPI
                                                   params:nil];
//    NSString *urlString = [NSString stringWithFormat:@"http://123.57.240.208:8066/epay/applevalid"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    [EVBaseToolManager POSTNotSessionWithUrl:urlString params:params fileData:nil fileMineType:nil fileName:nil success:successBlock failError:failBlock];
}


- (void)GETVideoInfosList:(NSString *)list fail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *info))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    params[@"vidlist"] = list;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoInfosAPI
                                                               params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}

- (void)GETUserTagsListfail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *info))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVUserTagsListAPI
                                                               params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}

- (void)GETAllUserTagsListfail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *info))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVALLUserTagsAPI
                                                               params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}


- (void)GETSetUserTagsList:(NSString *)list fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *info))successBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    params[@"taglist"] = list;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVUserTagsSetAPI
                                                               params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];
}
@end
