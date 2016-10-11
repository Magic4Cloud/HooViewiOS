//
//  EVDiscoverUserModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVDiscoverUserModel.h"
#import "NSString+Extension.h"

@implementation EVDiscoverUserModel


- (NSString *)fans_count
{
    return [NSString shortNumber:[_fans_count integerValue]];
}

- (NSString *)live_time
{
    return [NSString shortNumber:[_live_time integerValue] / 60];
}

- (NSString *)live_count
{
    return [NSString shortNumber:[_live_count integerValue]];
}

- (NSString *)like_count
{
    return [NSString shortNumber:[_like_count integerValue]];
}

- (NSString *)watch_count
{
    return [NSString shortNumber:[_watch_count integerValue]];
}

// 获取类型对应的key
+ (NSString *)userModelKeyForType:(NSString *)type
{
    return [NSString stringWithFormat:@"%@%@",type,kCCDiscoverUserModelKeySuffix];
}

+ (NSArray *)discoverUserModelsForType:(NSString *)type withDictionary:(NSDictionary *) dic
{
    // 获取不同类型对应的key
    NSString *key = [self userModelKeyForType:type];
    
    // 获取对应的数组
    NSArray *array = [dic objectForKey:key];
    
    // 获取对象数组
    NSArray *userModelsArray = [EVDiscoverUserModel objectWithDictionaryArray:array];
    
    // 设置类型
    for (EVDiscoverUserModel *model in userModelsArray) {
        model.type = type;
    }
    return userModelsArray;
}

+ (NSArray *)allDiscoverUserModelsWithDictionary:(NSDictionary *)allDic
{
    NSArray *freshArray = [self discoverUserModelsForType:kCCDiscoverUserModelTypeNew withDictionary:allDic];
    NSArray *recommendArray = [self discoverUserModelsForType:kCCDiscoverUserModelTypeRecommend withDictionary:allDic];
    NSArray *hotArray = [self discoverUserModelsForType:kCCDiscoverUserModelTypeHot withDictionary:allDic];
    NSArray *cityArray = [self discoverUserModelsForType:kCCDiscoverUserModelTypeCity withDictionary:allDic];

    return @[freshArray,recommendArray,hotArray,cityArray];;
}

@end
