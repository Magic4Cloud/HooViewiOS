//
//  NSArray+Group.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSArray+Group.h"
#import <objc/runtime.h>
#import "NSString+HLHanZiToPinYin.h"

@interface NSArray ()

@property (nonatomic,strong) NSMutableArray *groupArray;

@end

static void *groupArrayKey = &groupArrayKey;

@implementation NSArray (Group)


- (void)setGroupArray:(NSMutableArray *)groupArray
{
    objc_setAssociatedObject(self, &groupArrayKey, groupArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)groupArray
{
   return  objc_getAssociatedObject(self, &groupArrayKey);
}


-(NSArray *)subArraysWithString:(NSString *(^)(id obj))string;
{
    NSArray *groups = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];

    // 所有的组名
    self.groupArray = [NSMutableArray arrayWithCapacity:groups.count];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < groups.count; i ++)
    {
        NSString *key = groups[i];
        NSMutableArray *keyArray;
        for (int j = 0; j < self.count; j ++) {
            id obj = self[j];
            NSString *str = string(obj);
            NSString *firstCharactor = str.firstCharactor ;
            unichar c_groupName = [firstCharactor characterAtIndex:0];
            if (c_groupName < 65 || c_groupName > 90) {
                firstCharactor = @"#";
            }
            if ( [firstCharactor isEqualToString:key] )
            {
                if ( keyArray == nil )
                {
                    keyArray = [NSMutableArray array];
                    [self.groupArray addObject:key];
                }
                [keyArray addObject:obj];
            }
        }
        // 添加到总的数组中
        if ( keyArray )
        {
            [resultArray addObject:keyArray];
        }
    }
    return resultArray;
}


- (NSArray *)groupNames
{
    return self.groupArray;
}

@end
