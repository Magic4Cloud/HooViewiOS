//
//  EVNewsModel.m
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsModel.h"

@implementation EVNewsModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"newsID":@"id",
             };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _cellHeight = 100;
    if (![dic[@"cover"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    if ([dic[@"type"] floatValue] == 0)
    {
        NSArray * coverArray = dic[@"cover"];
        
        if (coverArray == nil )
        {
            //没有图片
            _cellHeight = 100;
            return YES;
        }
        else if (coverArray.count == 1)
        {
            //一张图片
            _cellHeight = 100;
        }
        else if (coverArray.count == 3)
        {
            //三张图片
            _cellHeight = 180;
            
        }
    }
    else if([dic[@"type"] floatValue] == 1)
    {
        _cellHeight = 100;
    }
    else if([dic[@"type"] floatValue] == 2)
    {
        _cellHeight = 220;
    }
    return YES;
}
@end
