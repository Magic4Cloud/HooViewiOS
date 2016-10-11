//
//  NSObject+Public.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSObject+Public.h"

@implementation NSObject (Public)

+ (NSArray *)directKeyValueClasses{
    static NSArray *directKeyValueClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        directKeyValueClasses = @[@"__NSCFString",@"__NSCFConstantString",@"__NSCFBoolean",@"__NSCFNumber",@"NSObject",@"NSException",@"NSDate",@"NSURL",@"NSMutableURL",@"NSData",@"NSMutableData"];
    });
    return directKeyValueClasses;
}

+ (NSArray *)dictionaryClasses{
    static NSArray *dictionaryClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionaryClasses = @[@"__NSDictionaryI",@"__NSDictionaryM"];
    });
    return dictionaryClasses;
}

+ (NSArray *)collectionClasses{
    static NSArray *collectionClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionClasses = @[@"__NSArrayM",@"__NSArrayI",@"__NSSetI",@"__NSSetM"];
    });
    return  collectionClasses;
}

@end
