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
                      type:(EVSearchType)type
                     start:(NSInteger)start
                     count:(NSInteger)count
                startBlock:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *dict))successBlock
             sessionExpire:(void(^)())sessionExpireBlock
               reterrBlock:(void(^)(NSString *reterr))reterrBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(start) forKey:kStart];
    [params setValue:@(count) forKey:kCount];
   
    NSString *urlString;
    switch (type) {
        case EVSearchTypeNews:
            urlString = EVSearchNews;
             [params setValue:keyword forKey:@"title"];
            break;
        case EVSearchTypeLive:
             urlString = EVSearchVideoAPI;
             [params setValue:keyword forKey:kKeyWord];
            
            break;
        case EVSearchTypeStock:
            urlString = EVSearchStock;
             [params setValue:keyword forKey:@"name"];
            break;
        default:
            break;
    }
    
    EVLog(@"param ------- %@ -----------------  %@",params,urlString);
    [EVBaseToolManager GETRequestWithUrl:urlString parameters:params success:successBlock sessionExpireBlock:sessionExpireBlock fail:failBlock];
}

@end
