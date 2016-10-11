//
//  EVTopicResponse.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTopicResponse.h"
#import "EVTopicItem.h"

@implementation EVTopicResponse

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"topics": [EVTopicItem class]};
}

@end
