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
                                                               params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
    

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
    
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoDeletePastVideoAPI
                                                   params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    

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
                                              params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
    
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
    params[kDescriptionKey] = descp;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVUserInformAPI
                                              params:nil];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    EVLog(@"%@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
                                                   params:nil];

    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}

- (void)upLoadVideoThumbWithiImage:(UIImage *)image vid:(NSString *)vid fileparams:(NSMutableDictionary *)fileparams success:(void(^)(NSDictionary *dict))success sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil ) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kVid] = vid;
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVVideoLogo
                                                          params:nil];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
//    NSString *contentType = @"form/multipart";
    NSString *fileMineType = @"image/jpeg";
    
    [EVBaseToolManager POSTRequestWithUrl:urlString params:params fileData:imgData fileMineType:fileMineType fileName:@"file" success:success sessionExpireBlock:sessionExpireBlock failError:nil];
    
}




- (void)GETLivePreStartParams:(NSDictionary *)param
                              Start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                     sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    params[kSessionIdKey] = sessionID;
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVLiveStartAPI
                                                          params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
                                              params:nil];
 
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}


- (void)GETUserstartwatchvideoWithParams:(NSDictionary *)videoparams
                                   Start:(void(^)())startBlock
                                    fail:(void(^)(NSError *error))failBlock
                                 success:(void(^)(NSDictionary *videoInfo))successBlock
                           sessionExpire:(void(^)())sessionExpireBlock
{
//    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
   
//    if ( sessionID )
//    {
//        params[kSessionIdKey] = sessionID;
//    }
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( videoparams[kVid] )
    {
        params[kVid] = videoparams[kVid];
    }
//    if (videoparams[kPassword]) {
//        params[kPassword] = videoparams[kPassword];
//    }
//
//    
//    if (videoparams[kPermissionKey]) {
//        params[kPermissionKey] = videoparams[kPermissionKey];
//    }
//    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVWatchUserstartwatchvideo
                                              params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:nil fail:failBlock];

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
  
    if (vid.length >0 ) {
        [params setValue:vid
                  forKey:kVid];
    }
    
    [params setValue:[NSNumber numberWithInteger:number]
              forKey:@"count"];
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVBuyPresent
                                                   params:nil];
    EVLog(@"liwudeanimation------------  %@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
                                                   params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
                                              params:nil];
    
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

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
    EVLog(@"urlstring-------  %@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}


- (void)GETUserShutVid:(NSString *)vid
              userName:(NSString *)userName
                shutUp:(NSString *)shutup
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
    params[kNameKey]   = userName;
    params[kVid]  = vid;
    params[@"shutup"] = shutup;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoShutupAPI params:nil];
    EVLog(@"urlstring-------  %@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

    
}

- (void)GetUserManagerVid:(NSString *)vid
                 userName:(NSString *)userName
                  manager:(NSString *)manager
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
    params[kNameKey]   = userName;
    params[kVid]  = vid;
    params[@"manager"] = manager;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoManagerAPI params:nil];
    EVLog(@"urlstring-------  %@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}

- (void)GETKictUserVid:(NSString *)vid userName:(NSString *)username kick:(NSString *)kick fail:(void(^)(NSError *error))failBlock
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
    params[kNameKey]   = username;
    params[kVid]  = vid;
    params[@"kick"] = kick;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVVideoKickUserAPI params:nil];
    EVLog(@"urlstring-------  %@",urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}

- (void)GETRequestLinkUsername:(NSString *)username success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( !sessionID )
    {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kOwnername]   = username;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVRequestLinkAPI params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:success sessionExpireBlock:sessionExpireBlock fail:error];
}

- (void)GETAcceptLinkUsername:(NSString *)username success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if (!sessionID) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[kRequestname]   = username;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVAcceptLinkAPI params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:success sessionExpireBlock:sessionExpireBlock fail:error];
    
}

- (void)GETEndLinkCallid:(NSString *)callid vid:(NSString *)vid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if (!sessionID) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[@"callid"]   = callid;
    params[kVid] = vid;
//    params[kType]  = @(type);
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVEndLinkAPI params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:success sessionExpireBlock:sessionExpireBlock fail:error];
}

- (void)GETCancelLindCallid:(NSString *)callid vid:(NSString *)vid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if (!sessionID) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kSessionIdKey] = sessionID;
    params[@"callid"]   = callid;
    params[kVid]  = vid;
    NSString *urlString = [EVHttpURLManager httpsFullURLStringWithURI:EVCancelLinkAPI params:nil];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:success sessionExpireBlock:sessionExpireBlock fail:error];
}


//创建图文直播间
- (void)GETCreateTextLiveUserid:(NSString *)userid nickName:(NSString *)nickname easemobid:(NSString *)easemobid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = userid;
    param[@"nickname"] = nickname;
    param[@"easemobid"] = easemobid;
    NSString *url = [NSString stringWithFormat:EVCreatTextLiveAPI];
    [EVBaseToolManager GETNoSessionWithUrl:url parameters:param success:success fail:error];
    
}



//创建图文直播间
- (void)GETHistoryTextLiveStreamid:(NSString *)streamid  count:(NSString *)count start:(NSString *)start stime:(NSString *)stime success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"streamid"] = streamid;
    param[@"count"] = count;
    param[@"etime"] = stime;
    param[@"start"] = start;
    NSString *url = [NSString stringWithFormat:EVTextLiveHistiryAPI];
    [EVBaseToolManager GETNoSessionWithUrl:url parameters:param success:success fail:error];
    
}


- (void)POSTChatTextLiveID:(NSString *)streamid from:(NSString *)from nk:(NSString *)nk msgid:(NSString *)msgid msgtype:(NSString *)msgtype msg:(NSString *)msg tp:(NSString *)tp rct:(NSString *)rct rnk:(NSString *)rnk timestamp:(NSString *)timestamp img:(UIImage *)img success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:streamid forKey:@"to"];
    [param setValue:from forKey:@"from"];
    [param setValue:nk forKey:@"nk"];
    [param setValue:msgid forKey:@"msgid"];
    [param setValue:msgtype forKey:@"msgtype"];
    [param setValue:tp forKey:@"tp"];
    [param setValue:rct forKey:@"rct"];
    [param setValue:rnk forKey:@"rnk"];
    [param setValue:timestamp forKey:@"timestamp"];
    if (msg.length > 0) {
        [param setValue:msg forKey:@"msg"];
    }
    NSData *imageData = UIImagePNGRepresentation(img);
    NSString *url = [NSString stringWithFormat:EVTextLiveChatUploadAPI];
    [EVBaseToolManager POSTNotSessionWithUrl:url params:param fileData:imageData fileMineType:nil fileName:nil success:success failError:error];
}

- (void)GETIsHaveTextLiveOwnerid:(NSString *)ownerid streamid:(NSString *)streamid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (ownerid.length > 0) {
        [param setValue:ownerid forKey:@"ownerid"];
    }
    if (streamid.length > 0) {
        [param setValue:streamid forKey:@"streamid"];
    }
   NSString *url = [NSString stringWithFormat:EVTextLiveHaveAPI];
 [EVBaseToolManager GETNoSessionWithUrl:url parameters:param success:success fail:error];
    
}


@end
