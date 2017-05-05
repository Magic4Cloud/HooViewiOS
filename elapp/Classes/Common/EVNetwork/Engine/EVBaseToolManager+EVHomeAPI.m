//
//  EVBaseToolManager+EVHomeAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVHomeAPI.h"
#import "constants.h"
#import "EVNowVideoItem.h"
#import "EVHttpURLManager.h"


#define kMaxid @"maxid"



@implementation EVBaseToolManager (EVHomeAPI)

//话题视频列表
//http://115.29.109.121/mediawiki/index.php?title=Liverecommendlist
- (void)GETTopicVideolistStart:(NSInteger)start
                         count:(NSInteger)count
                       topicid:(NSString *)topicid
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *info))successBlock
                sessionExpired:(void(^)())sessionExpiredBlock
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if ( sessionID )
//    {
//        params[kSessionIdKey] = sessionID;
//    }
    params[kStart] = @(start);
    params[kCount] = @(count);
//    params[kTopicidKey] = topicid;
//    params[kLive] = @(1);
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVTopicVideo
                                                          params:nil];
  
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}


//发送评论
- (void)POSTVideoCommentContent:(NSString *)content
                        topicid:(NSString *)topicid
                           type:(NSString *)type
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *info))successBlock
                 sessionExpired:(void(^)())sessionExpiredBlock{
    
    NSString *userid = [self uidFromLocal];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:topicid forKey:@"topicid"];
    [params setValue:type forKey:@"type"];
    [params setValue:userid forKey:@"userid"];
    [params setValue:content forKey:@"content"];
    
    [EVBaseToolManager GETRequestWithUrl:EVReleaseCommentAPI parameters:params success:successBlock sessionExpireBlock:sessionExpiredBlock fail:failBlock];
}

//获取精品视频评论列表
- (void)GETVideoCommentListtopicid:(NSString *)topicid
                              type:(NSString *)type
                         start:(NSString *)start
                         count:(NSString *)count
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
{
    NSString *userid = [self uidFromLocal];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:topicid forKey:@"topicid"];
    [params setValue:type forKey:@"type"];
    [params setValue:userid forKey:@"userid"];
    [params setValue:@"dateline" forKey:@"orderby"];
    [params setValue:start forKey:@"start"];
    [params setValue:count forKey:@"count"];
    [EVBaseToolManager GETNoSessionWithUrl:EVVideoCommentListAPI parameters:params success:successBlock fail:failBlock];
}

- (void)GETGoodVideoListStart:(NSString *)start count:(NSString *)count fail:(void(^)(NSError *error))failBlock success:(void(^)(NSDictionary *info))successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
    [params setValue:start forKey:kStart];
    [params setValue:count forKey:kCount];
    
    NSString *urlString = [EVHttpURLManager fullURLStringWithURI:EVGoodVideoListAPI
                                                          params:nil];
    
    [EVBaseToolManager GETNoSessionWithUrl:urlString parameters:params success:successBlock fail:failBlock];
    

}


// http://115.29.109.121/mediawiki/index.php?title=Carouselinfo
- (void)GETCarouselInfoWithStart:(void (^)())startBlock
                         success:(void (^)(NSDictionary *info))successBlock
                            fail:(void (^)(NSError *error))failBlock
                   sessionExpire:(void(^)())sessionExpireBlock
{
//    NSString *sessionId = [self getSessionIdWithBlock:sessionExpireBlock];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (sessionId)
//    {
//        params[kSessionIdKey] = sessionId;
//    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@",EVHoovviewNewsBannersAPI];
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:nil success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];

}


- (void)GETTextLiveHomeListStart:(NSString *)start success:(void (^)(NSDictionary *info))successBlock
                            fail:(void (^)(NSError *error))failBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"start"] = start;
    [params setValue:@"20" forKey:@"count"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",EVTextLiveHomeAPI];
    [EVBaseToolManager GETNoSessionWithUrl:urlStr parameters:params success:successBlock fail:failBlock];
}



@end
