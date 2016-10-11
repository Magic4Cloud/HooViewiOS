//
//  EVRegionCodeModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVRegionCodeModel.h"

@implementation EVRegionCodeModel

@end

@implementation CCRegionCodeGroup

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"items" : [EVRegionCodeModel class]};
}

+ (NSArray *)regionCodeGroups
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aera" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return [self objectWithDictionaryArray:array];
}

@end
