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
#ifdef CCDEBUG
    NSAssert(sessionID, @"session id can not be nil");
#endif
    
    params = [NSMutableDictionary dictionaryWithDictionary:params];
    params[kSessionIdKey] = sessionID;
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserEditInfoAPI
                                              params:params];
    //    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
             else if ( [info[kRetvalKye] isEqualToString:@"ok"] )
             {
                 if ( successBlock )
                 {
                     successBlock();
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
                                              params:params];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",uname];
    postParams[kFile] = fileName;
    NSAssert(image, @"image can not be nil");
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *contentType = @"form/multipart";
    NSString *fileMineType = @"image/jpeg";
    [self postWithURLString:urlString
                contentType:contentType
                     params:postParams
                   fileData:data
               fileMineType:fileMineType
                   fileName:fileName
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
                                                   params:mParams];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self jsonPostWithURLString:urlString
                         params:postParmas
                          start:startBlock
                           fail:failBlock
                        success:^(NSData *data)
     {
         if ( data )
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             CCLog(@"---info : %@ ", info);
             if ( [info[kRetvalKye] isEqualToString:kAccountOK] )
             {
                 if ( successBlock )
                 {
                     successBlock();
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


- (void)GETBaseUserInfoWithUname:(NSString *)uname
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
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserInfoAPI
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
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoUserInfoAPI
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
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
                 if (  sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
             CCLog(@"fans:%@", info);
             NSDictionary *retinfo = info[kRetinfoKey];
             if ([info[kRetvalKye] isEqualToString:kRequestOK])
             {
                 if ( successBlock )
                 {
                     NSArray *fans = [EVFanOrFollowerModel objectWithDictionaryArray:retinfo[kUserKey]];
                     successBlock(fans);
                 }
             }
             else if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock  )
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
             CCLog(@"followers:%@", info);
             NSDictionary *retinfo = info[kRetinfoKey];
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     NSArray *fans = [EVFanOrFollowerModel objectWithDictionaryArray:retinfo[kUserKey]];
                     successBlock(fans);
                 }
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
                     failBlock([NSError cc_errorWithDictionary:info]);
                 }
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
                                                                  params:params];
    [self requestWithURLString:url
                                start:startBlock
                                    fail:failBlock
                                 success:^(NSData *data)
               {
                      if ( data )
                          {
                                  NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                                  CCLog(@"fans : %@", info);
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
                                        params:params];
    //    return [self requestWithURLString:url start:nil fail:nil success:nil]
    [self requestWithURLString:url start:nil fail:nil success:^(NSData *data) {
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        CCLog(@"%@", info);
    }];
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
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:sessionID forKey:kSessionIdKey];
    [params setValue:name forKey:kNameKey];
    [params setValue:type forKey:kType];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
    [self getGPSInfo:params];
    
    NSString *url = [EVHttpURLManager fullURLStringWithURI:EVVideoUserPastVideoAPI
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
             NSDictionary *retinfo = info[kRetinfoKey];
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     NSArray *videos = [EVUserVideoModel objectWithDictionaryArray:retinfo[kVideosKey]];
                     successBlock(videos);
                 }
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
                                              params:params];
    [self requestWithURLString:url start:^{
        
    } fail:failBlock success:^(NSData *data) {
        if ( data )
        {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
            {
                if ( successBlock )
                {
                    successBlock();
                }
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


// 根据已经获取到的图片要上传的URL来上传图片
- (void)GETUpLoadImage:(UIImage *)image
          WithFileName:(NSString *)name
                   Url:(NSString *)urlString
            startBlock:(void(^)())startBlock
                  fail:(void(^)(NSError *error))failBlock
               success:(void(^)(NSString *newVideoShotURL))successBlock
          essionExpire:(void(^)())sessionExpireBlock
{
    if ( (!urlString && ![urlString isEqualToString:@""])
        || !image)
    {
        failBlock(nil);
        CCLog(@"URL和image不能为空！");
        return ;
    }
    NSData *imgData = UIImageJPEGRepresentation(image, 0.7);
    NSString *contentType = @"form/multipart";
    NSString *fileMineType = @"image/jpeg";
    [self postWithURLString:urlString
                contentType:contentType
                     params:nil
                   fileData:imgData
               fileMineType:fileMineType
                   fileName:name start:startBlock
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
                     NSDictionary *retinfo = info[kRetinfoKey];
                     NSString *urlTemp = retinfo[@"url"];
                     NSString *newUrl = [NSString stringWithFormat:@"http://%@", urlTemp];
                     successBlock(newUrl);
                 }
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











-(void)GETUnbundlingtype:(CCUnbundlingAuthtype)unbundling
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
        case CCAccountQQ:
            [params setValue:kAuthTypeQQ
                      forKey:kType];
            break;
        case CCAccountSina:
            [params setValue:kAuthTypeSina
                      forKey:kType];
            break;
        case CCAccountWeixin:
            [params setValue:kAuthTypeWeixin
                      forKey:kType];
            break;
    }
    //    NSString *url = [self fullURLStringWithURI:CCUserAuthUnbind params:params];
    NSString *url = [EVHttpURLManager httpsFullURLStringWithURI:EVUserAuthUnbind
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
             CCLog(@"info = %@", info);
             if ([info[kRetvalKye] isEqualToString:kRequestOK])
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
             else
             {
                 CCLog(@"Request not work properly!");
                 if (failBlock)
                 {
                     failBlock([NSError cc_errorWithDictionary:info]);
                 }
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
    
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
             if([info[kRetvalKye] isEqualToString:kRequestOK])
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if([info[kRetvalKye] isEqualToString:kSessionIdExpireValue])
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
                     failBlock([NSError cc_errorWithDictionary:info]);
                 }
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
             if( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock();
                 }
             }
             else if([info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else
             {
                 CCLog(@"Request not work properly!");
                 NSDictionary *errorDic = nil;
                 if ([info[kRetErr] isNotEmpty])
                 {
                     errorDic = info;
                 }
                 else
                 {
                     errorDic = @{kRetErr: kE_GlobalZH(@"setting_fail")};
                 }
                 if (failBlock)
                 {
                     failBlock([NSError cc_errorWithDictionary:errorDic]);
                 }
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
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
                                                                    error:nil];
             
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
             failBlock(nil);
         }
     }];
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
                                                                    error:nil];
             
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
             failBlock(nil);
         }
     }];
}


// 充值选项
- (void)GETCashinOptionWith:(CCPayPlatform)plateform
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
                 if ( sessionExpiredBlock )
                 {
                     sessionExpiredBlock();
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

- (void)POSTApplevalidWith:(NSString *)receipt
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
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVAppleValidAPI
                                                   params:params];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self jsonPostWithURLString:urlString
                         params:@{kReceipt : receipt}
                          start:startBlock
                           fail:^(NSError *error)
     {
         if ( failBlock )
         {
             failBlock(error);
         }
         // fix by 马帅伟 模拟多线程请求闪退问题(重复发送改到了主线程中)
     } success:^(NSData *data)
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
                 if ( sessionExpiredBlock )
                 {
                     sessionExpiredBlock();
                 }
             }
             else if ( failBlock )
             {
                 NSString *errStr = [info valueForKey:kRetvalKye];
                 NSError *err = nil;
                 if ( [errStr isKindOfClass:[NSString class]] && errStr.length > 0 )
                 {
                     err = [NSError errorWithDomain:kBaseToolDomain
                                               code:-1
                                           userInfo:@{kRetvalKye : errStr}];
                 }
                 failBlock(err);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}


@end
