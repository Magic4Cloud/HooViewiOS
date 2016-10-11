//
//  EVTopicItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTopicItem.h"

@implementation EVTopicItem
/**修改替换id*/
+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames{
    return @{@"id" : @"Id", @"description" : @"descriptions"};
}

@end
