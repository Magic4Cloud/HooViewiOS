
//
//  EVBaseToolManager+EVNewsAPI.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseToolManager+EVNewsAPI.h"

@implementation EVBaseToolManager (EVNewsAPI)

- (void)POSTNewsCommentContent:(NSString *)content
                     stockCode:(NSString *)stockcode
                        userID:(NSString *)userid
                      userName:(NSString *)username
                    userAvatar:(NSString *)useravatar
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
{
    //    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    //    if ( sessionID == nil ) {
    //        return;
    //    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[kSessionIdKey] = sessionID;
    [params setValue:stockcode forKey:@"newsid"];
    [params setValue:userid forKey:@"userid"];
    [params setValue:username forKey:@"username"];
    [params setValue:useravatar forKey:@"useravatar"];
    [params setValue:content forKey:@"content"];
    
    //    NSString *url = [self jointUrlParam:params url:EVStockComment];
    [EVBaseToolManager POSTNotSessionWithUrl:EVNewsComment params:params fileData:nil fileMineType:nil fileName:nil success:successBlock failError:failBlock];
    
}


- (void)GETNewsRequestStart:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVHVNewsConstantAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:start forKey:@"start"];
    [param setValue:count forKey:@"count"];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

- (void)GETNewsCommentListnewsId:(NSString *)vid
                         start:(NSString *)start
                         count:(NSString *)count
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *retinfo))successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:vid forKey:@"news"];
//    [params setValue:count forKey:@"count"];
    //    [params setValue:userid forKey:@"userid"];
    [EVBaseToolManager GETNoSessionWithUrl:EVVideoCommentListAPI parameters:params success:successBlock fail:failBlock];
}


//- (void)GETNewsDetailNewsID:(NSString *)newsid
//                       fail:(void(^)(NSError *error))failBlock
//                    success:(void(^)(NSDictionary *retinfo))successBlock
//{
//    
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:newsid forKey:@"newsid"];
//    [EVBaseToolManager GETNoSessionWithUrl:EVNewsDetailAPI parameters:params success:successBlock fail:failBlock];
//}


//获取新闻详情
- (void)GETNewsDetailNewsID:(NSString *)newsid
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSDictionary *retinfo))successBlock
              sessionExpire:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [self getSessionIdWithBlock:sessionExpireBlock];
    if ( sessionID == nil )
    {
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:newsid forKey:@"newsid"];
    [params setValue:sessionID forKey:@"sessionid"];

    [EVBaseToolManager GETNotVerifyRequestWithUrl:EVNewsDetailAPI parameters:params success:successBlock fail:failBlock];
}



- (void)GETFastNewsRequestStart:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVHVFastNewsAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:start forKey:@"start"];
    [param setValue:count forKey:@"count"];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

- (void)GETEyesNewsRequestChannelid:(NSString *)channelid Programid:(NSString *)programid start:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVHVEyesDetailNewsAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:start forKey:@"start"];
    [param setValue:count forKey:@"count"];
    [param setValue:programid forKey:@"programid"];
    [param setValue:channelid forKey:@"channelid"];
    
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

- (void)GETConsultNewsRequestSymbol:(NSString *)symbol
                              Start:(NSString *)start
                              count:(NSString *)count
                             userid:(NSString *)userid
                            Success:(void (^) (NSDictionary *retinfo))success
                              error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVConsultNewsAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:start forKey:@"start"];
//    [param setValue:count forKey:@"count"];
    [param setValue:symbol forKey:@"symbol"];
    [param setValue:userid forKey:@"userid"];
    NSLog(@"url:%@\nparams:%@",urlString,param);
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

//自选新闻
- (void)GETChooseNewsRequestStart:(NSString *)start
                              count:(NSString *)count
                             userid:(NSString *)userid
                            Success:(void (^) (NSDictionary *retinfo))success
                              error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVGetChooseStockNewsAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:start forKey:@"start"];
        [param setValue:count forKey:@"count"];
//    [param setValue:symbol forKey:@"symbol"];
    [param setValue:userid forKey:@"userid"];
    NSLog(@"url:%@\nparams:%@",urlString,param);
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}

//专栏新闻
- (void)GETSpeciaColumnNewsRequestStart:(NSString *)start
                                  count:(NSString *)count
                                Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
//    NSString *url = @"https://demo2821846.mockable.io/news/column";//测试数据
    NSString *urlString = [NSString stringWithFormat:@"%@",EVGetSpecialColumnAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:start forKey:@"start"];
    [param setValue:count forKey:@"count"];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}



- (void)GETCollectUserNewsID:(NSString *)newsid start:(NSString *)start count:(NSString *)count Success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error
{
    NSString *urlString = [NSString stringWithFormat:@"%@",EVNewsUserNewsAPI];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:start forKey:@"start"];
//    [param setValue:count forKey:@"count"];
    [param setValue:newsid forKey:@"newsid"];
    [EVBaseToolManager GETNotVerifyRequestWithUrl:urlString parameters:param success:success fail:error];
}
@end
