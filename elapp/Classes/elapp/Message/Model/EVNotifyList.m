//
//  EVNotifyList.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import "EVNotifyList.h"

@implementation EVNotifyList

/**模型替换*/
+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames{
    return @{@"message_id": @"group_id"};
}

@end
