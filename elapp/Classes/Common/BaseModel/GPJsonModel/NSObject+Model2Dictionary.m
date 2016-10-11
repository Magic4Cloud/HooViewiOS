//
//  NSObject+Model2Dictionary.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSObject+Model2Dictionary.h"
#import "NSObject+Log.h"
#import "NSObject+Public.h"

@implementation NSObject (Model2Dictionary)

- (NSMutableDictionary *)gp_dictionaryFromModel{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    __block GPIvar *ivarModel = nil;
    NSDictionary *ingoreProperties = [[self class] ignoreProperties];
    [self gp_emurateIvarsUsingBlock:^(Ivar ivar, NSString *ivarName, id value) {
        ivarModel = [GPIvar ivarWithIvar:ivar fromObject:self];
        if ( ivarModel.ivarValue == nil )
        {
            ivarModel.ivarValue = [[NSNull alloc] init];
        }
        if ( ivarModel.propertyName && ingoreProperties[ivarModel.propertyName] == nil )
        {
            switch (ivarModel.ivarType) {
                case GPIvarPropertyDirectKeyValueType:
                    if ( ivarModel.ivarValue )
                    {
                        dictM[ivarModel.propertyName] = ivarModel.ivarValue;
                    }
                    break;
                case GPIvarPropertyCollectionType:{
                    id value = [NSObject gp_arrayValueStringFromCollection:ivarModel.ivarValue];
                    if ( value )
                    {
                        dictM[ivarModel.propertyName] = value;
                    }
                }
                    break;
                case GPIvarPropertyDictionaryType:
                {
                    id value = [NSObject gp_dictionaryValuesStringFromDictionary:ivarModel.ivarValue];
                    if ( value )
                    {
                        dictM[ivarModel.propertyName] = value;
                    }
                }
                    break;
                case GPIvarPropertyDIYObject:
                    dictM[ivarModel.propertyName] = [ivarModel.ivarValue gp_dictionaryFromModel];
                    break;
                    
                default:
                    break;
            }
        }
    }];
    return dictM;
}

#pragma mark - 私有方法
+ (NSArray *)gp_arrayValueStringFromCollection:(id)collection{
    if ( collection == nil || [collection isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    NSAssert([collection isKindOfClass:[NSArray class]] || [collection isKindOfClass:[NSSet class]], @"该类型不能使用 for in 遍历");
    NSMutableArray *array = [NSMutableArray array];
    for (id item in collection) { // 可以直接赋值的对象类型
        NSString *className = NSStringFromClass([item class]);
        if ( [[self directKeyValueClasses] containsObject:className] ) {
            [array addObject:item];
        } else if ( [[self collectionClasses] containsObject:className] ){
            // 数组 或者 set 类型
            [array addObject:[self gp_arrayValueStringFromCollection:item]];
        } else if ( [[self dictionaryClasses] containsObject:className] ){
            // 字典类型
            [array addObject:[self gp_dictionaryValuesStringFromDictionary:item]];
        } else { // 自定义对象的情况
            [array addObject:[item gp_dictionaryFromModel]];
        }
    }
    return array;
}

+ (NSDictionary *)gp_dictionaryValuesStringFromDictionary:(NSDictionary *)dict{
    if ( dict == nil || [dict isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id item, BOOL *stop) {
        NSString *className = NSStringFromClass([item class]);
        if ( [[self directKeyValueClasses] containsObject:className] ) {
            // 可以直接赋值的对象类型
            dictM[key] = item;
        } else if ( [[self collectionClasses] containsObject:className] ){
            // 数组 或者 set 类型
            dictM[key] = [self gp_arrayValueStringFromCollection:item];
        } else if ( [[self dictionaryClasses] containsObject:className] ){
            // 字典类型
            dictM[key] = [self gp_dictionaryValuesStringFromDictionary:item];
        } else { // 自定义对象的情况
            dictM[key] = [item gp_dictionaryFromModel];
        }
    }];
    return dictM;
}

+ (NSDictionary *)ignoreProperties
{
    return nil;
}

@end
