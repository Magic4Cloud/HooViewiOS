//
//  EVConsumptionModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVConsumptionModel.h"

@implementation EVRecordlistItemModel

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"description" : @"descriptionss"};
}

@end

@implementation CCConsumptionModel

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"recordlist": [EVRecordlistItemModel class]};
}

@end
