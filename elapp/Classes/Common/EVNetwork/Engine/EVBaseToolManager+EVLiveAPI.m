//
//  EVBaseToolManager+EVLiveAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//



#import "EVBaseToolManager+EVLiveAPI.h"
#import "constants.h"
#import "NSString+Extension.h"
#import "EVHttpURLManager.h"


@implementation EVBaseToolManager (EVLiveAPI)
/* 支付付费的直播 */
- (void)GETLivePayWithVid:(NSString *)vid start:(void(^)())startBlock fail:(void(^)(NSError *error))failBlock successBlock:(void(^)(NSDictionary *retinfo))successBlock sessionExpire:(void(^)())sessionExpireBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if (sessionID == nil) {
        return;
    }
    params[kSessionIdKey] = sessionID;
    
    
    if (vid == nil) {
        return;
    }
    params[@"vid"] = vid;
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoLivePayAPI
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
                     NSDictionary *videoInfo = info[kRetinfoKey];
                     successBlock(videoInfo);
                 }
             }
             else if ( failBlock )
             {
                 NSError *error = [[NSError alloc] initWithDomain:kBaseToolDomain
                                                             code:-1
                                                         userInfo:@{kCustomErrorKey: kE_GlobalZH(@"request_fail_again")}];
                 failBlock(error);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}




- (void)GETAppdevRemoveVideoWith:(NSString *)vid
                           start:(void (^)())startBlock
                            fail:(void (^)(NSError *))failBlock
                         success:(void (^)())successBlock
                   sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kVid] = vid;
    
    //    NSString *urlString = [self fullURLStringWithURI:CCVideoDeletePastVideoAPI params:params];
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoDeletePastVideoAPI
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
                     successBlock();
                 }
             }
             else if ( failBlock )
             {
                 NSError *error = [[NSError alloc] initWithDomain:kBaseToolDomain
                                                             code:-1
                                                         userInfo:@{kCustomErrorKey: kE_GlobalZH(@"request_fail_again")}];
                 failBlock(error);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}

// 用于结束一个正在直播的接口http://115.29.109.121/mediawiki/index.php?title=Appdevstoplive
- (void)GETAppdevstopliveWithVid:(NSString *)vid
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *videoInfo))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kVid] = vid;

    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoStopLiveAPI
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
                     NSDictionary *videoInfo = info[kRetinfoKey];
                     successBlock(videoInfo);
                 }
             }
             else if ( failBlock )
             {
                 NSError *error = [[NSError alloc] initWithDomain:kBaseToolDomain
                                                             code:-1
                                                         userInfo:@{kCustomErrorKey:kE_GlobalZH(@"request_fail_again")}];
                 failBlock(error);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}





- (void)GETUserInformWithName:(NSString *)name
                  description:(NSString *)descp
                        start:(void(^)())startBlock
                      success:(void(^)())successBlock
                         fail:(void(^)())failBlock
                       expire:(void(^)())sessionExpireBlock
{
    if ( [NSString isBlankString:name] &&
        [NSString isBlankString:descp] )
    {
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    params[kNameKey] = name;
    params[kDescription] = descp;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInformAPI
                                              params:params];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CCLog(@"%@",urlString);
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
                     successBlock();
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




- (void)GETLiveSendRedPacketWithVid:(NSString *)vid
                              ecoin:(NSInteger)ecoin
                              count:(NSInteger)count
                           greeting:(NSString *)greeting
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)())successBlock
                      sessionExpire:(void(^)())sessionExpireBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    params[kSessionIdKey] = sessionID;
    params[kVid] = vid;
    params[kCount] = [NSString stringWithFormat:@"%zd", count];
    params[@"amount"] = [NSString stringWithFormat:@"%zd", ecoin];
    params[kTitle] = greeting;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVAnchorSendPacket
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

- (void)upLoadVideoThumbWithiImage:(UIImage *)image vid:(NSString *)vid fileparams:(NSMutableDictionary *)fileparams sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil ) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kVid] = vid;
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoLogo
                                                          params:params];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    NSString *contentType = @"form/multipart";
    NSString *fileMineType = @"image/jpeg";
    [self postWithURLString:urlString contentType:contentType params:fileparams fileData:imgData fileMineType:fileMineType fileName:vid start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSData *data) {
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        CCLog(@"upload thumb success%@",json);
    }];
}




- (NSString *)GETLivePreStartParams:(NSDictionary *)param
                              Start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                     sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    params[kSessionIdKey] = sessionID;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVLiveStartAPI
                                                          params:params];
    return  [self requestWithURLString:urlString
                                 start:startBlock
                                  fail:failBlock
                               success:^(NSData *data)
             {
                 if ( data )
                 {
                     NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];
                     
                     
                     NSLog(@"infoo===============================  %@",info);
                     if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
                     {
                         NSString *extra = @"NULL";
                         if ( info[kExtra] )
                         {
                             extra = info[kExtra];
                         }
                         
                         if ( successBlock )
                         {
                             successBlock(info[kRetinfoKey]);
                         }
                     }
                     else
                     {
                         NSString *message = kE_GlobalZH(@"noNetwork");
                         if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
                         {
                             if ( sessionExpireBlock )
                             {
                                 sessionExpireBlock();
                             }
                         }
                         else
                         {
                             if ( [info[kRetvalKye] isEqualToString:kE_USER_PHONE_NOT_EXISTS] )
                             {
                                 message = kE_USER_PHONE_NOT_EXISTS;
                             }
                             
                             if ( failBlock )
                             {
                                 NSError *error = [NSError errorWithDomain:kBaseToolDomain
                                                                      code:-1
                                                                  userInfo:@{kCustomErrorKey : message}];
                                 failBlock(error);
                             }
                         }
                     }
                 }
                 else if ( failBlock )
                 {
                     failBlock(nil);
                 }
                 
             }];
}


- (NSString *)GETLivePreStartStart:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSDictionary *info))successBlock
              sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVLiveStartAPI
                                                          params:params];
  return  [self requestWithURLString:urlString
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
                 NSString *extra = @"NULL";
                 if ( info[kExtra] )
                 {
                     extra = info[kExtra];
                 }
                
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else
             {
                 NSString *message = kE_GlobalZH(@"noNetwork");
                 if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue] )
                 {
                     if ( sessionExpireBlock )
                     {
                         sessionExpireBlock();
                     }
                 }
                 else
                 {
                     if ( [info[kRetvalKye] isEqualToString:kE_USER_PHONE_NOT_EXISTS] )
                     {
                         message = kE_USER_PHONE_NOT_EXISTS;
                     }
                     
                     if ( failBlock )
                     {
                         NSError *error = [NSError errorWithDomain:kBaseToolDomain
                                                              code:-1
                                                          userInfo:@{kCustomErrorKey : message}];
                         failBlock(error);
                     }
                 }
             }
         }
         else if ( failBlock )
         {
             failBlock(nil);
         }
         
     }];
}

// http://115.29.109.121/mediawiki/index.php?title=Videosettitle
- (void)GETVideosettitleWithVid:(NSString *)vid
                          title:(NSString *)title
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
    params[kVid] = vid;
    params[kTitle] = title;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVLiveVideosettitleAPI
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
             NSString *returnValue = info[kRetvalKye];
             if ( [returnValue isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock();
                 }
             }
             else if ( [returnValue isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if ( failBlock )
             {
                 NSError *error = [NSError errorWithDomain:kBaseToolDomain
                                                      code:-1
                                                  userInfo:@{kCustomErrorKey : [NSString stringWithFormat:@"更新视频标题失败,请稍后重试%@",returnValue]}];
                 failBlock(error);
             }
         }
         else if (failBlock)
         {
             failBlock(nil);
         }
     }];
}


- (void)GETUserstartwatchvideoWithParams:(NSDictionary *)videoparams
                                   Start:(void(^)())startBlock
                                    fail:(void(^)(NSError *error))failBlock
                                 success:(void(^)(NSDictionary *videoInfo))successBlock
                           sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( sessionID )
    {
        params[kSessionIdKey] = sessionID;
    }
    
    if ( videoparams[kVid] )
    {
        params[kVid] = videoparams[kVid];
    }
    if (videoparams[kPassword]) {
        params[kPassword] = videoparams[kPassword];
    }

    
    if (videoparams[kPermissionKey]) {
        params[kPermissionKey] = videoparams[kPermissionKey];
    }
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVWatchUserstartwatchvideo
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
             CCLog(@"userstartwatchvideo - %@",info);
             NSString *retval = info[kRetvalKye];
             if ( [retval isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [retval isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
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


// 购买物品
- (void)GETBuyPresentWithGoodsID:(NSString *)goodsid
                          number:(NSInteger)number
                             vid:(NSString *)vid
                            name:(NSString *)name
                           start:(void (^)())startBlock
                            fail:(void (^)(NSError *error))failBlock
                         success:(void (^)(NSDictionary *info))successBlock
                   sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([sessionID isKindOfClass:[NSString class]]
        && sessionID.length > 0)
    {
        params[kSessionIdKey] = sessionID;
    }
    else
    {
        return ;
    }
    [params setValue:goodsid
              forKey:kGoodsid];
    [params setValue:name
              forKey:@"touser"];
    [params setValue:vid
              forKey:kVid];
    
    [params setValue:[NSNumber numberWithInteger:number]
              forKey:@"count"];
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVBuyPresent
                                                   params:params];
    NSLog(@"liwudeanimation------------  %@",urlString);
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
             NSString *retval = info[kRetvalKye];
             if ( [retval isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [retval isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
                 return ;
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

// 用户资产
- (void)GETUserAssetsWithStart:(void (^)())startBlock
                          fail:(void (^)(NSError *))failBlock
                       success:(void (^)(NSDictionary *))successBlock
                 sessionExpire:(void (^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([sessionID isKindOfClass:[NSString class]]&&
        sessionID.length > 0)
    {
        params[kSessionIdKey] = sessionID;
    }
    else
    {
        return;
    }
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVUserAssets
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
             NSString *retval = info[kRetvalKye];
             CCLog(@"%@",info);
             if ( [retval isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [retval isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if ( failBlock )
             {
                 failBlock([NSError cc_errorWithDictionary:info]);
             }
         }
         else if (failBlock)
         {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             NSString *retval = info[kRetvalKye];
             CCLog(@"%@",info);
             if ( [retval isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [retval isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
                 }
             }
             else if ( failBlock )
             {
                 failBlock([NSError cc_errorWithDictionary:info]);
             }
         }
     }];
}

- (void)GETContributorWithUserName:(NSString *)name
                          startNum:(NSInteger)startNum
                             count:(NSInteger)count
                             start:(void (^)())startBlock
                              fail:(void (^)(NSError *error))failBlock
                           success:(void (^)(NSDictionary *info))successBlock
                     sessionExpire:(void (^)())sessionExpireBlock
{
    if ( ![name isKindOfClass:[NSString class]]
        || name.length == 0 )
    {
        return ;
    }
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (sessionID)
    {
        params[kSessionIdKey] = sessionID;
    }
    [params setValue:name
              forKey:kNameKey];
    [params setValue:@(count)
              forKey:kCount];
    [params setValue:@(startNum)
              forKey:kStart];
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVGetContributorAPI
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
             NSString *retval = info[kRetvalKye];
             if ( [retval isEqualToString:kRequestOK] )
             {
                 if ( successBlock )
                 {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else if ( [retval isEqualToString:kSessionIdExpireValue] )
             {
                 if ( sessionExpireBlock )
                 {
                     sessionExpireBlock();
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


#pragma mark - 以下1.4.1 接口



- (void)GETRedEnvelopeVid:(NSString *)vid
                     code:(NSString *)code
                    start:(void(^)())startBlock
                     fail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *retinfo))successBlock
            sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( !sessionID )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    
    if ( !vid || !code ) {
        failBlock ? failBlock(nil) : nil;
        return ;
    }
//    params[kVid] = vid;
    params[@"redpackid"] = code;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoUserRedpack params:params];
    CCLog(@"urlstring-------  %@",urlString);
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
             if ( [info[kRetvalKye] isEqualToString:kSessionIdExpireValue]
                 && sessionExpireBlock )
             {
                 sessionExpireBlock();
             }
             
             if ( [info[kRetvalKye] isEqualToString:kRequestOK] )
             {
                 if (successBlock) {
                     successBlock(info[kRetinfoKey]);
                 }
             }
             else
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
