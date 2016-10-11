//
//  EVBaseToolManager+EVLogAPI.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager+EVLogAPI.h"
#import "EVLoginInfo.h"
#import "EVHttpURLManager.h"
@implementation EVBaseToolManager (EVLogAPI)

- (NSString *)fullLogURLWithParams:(NSMutableDictionary *)params
{
    return [EVHttpURLManager urlStringWithHost:CCLogBaseURL
                         uriString:CCApplePayURI
                            params:params];
}

- (void)POSTPayLogWithType:(NSString *)type
                     state:(NSString *)state
                  moreInfo:(NSDictionary *)moreInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:CCActionApplePayValue forKey:CCActionKey];
    [params setValue:type forKey:kType];
    [params setValue:state forKey:kState];
    [params setValue:[EVLoginInfo localObject].name forKey:kNameKey];
    [params setValuesForKeysWithDictionary:moreInfo];
    
    NSString *urlString = [self fullLogURLWithParams:params];
    [self requestWithURLString:urlString
                         start:nil
                          fail:nil
                       success:nil];
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
