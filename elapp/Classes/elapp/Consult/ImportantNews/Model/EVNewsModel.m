//
//  EVNewsModel.m
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsModel.h"
#import "EVCoreDataClass.h"
@implementation EVNewsModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"newsID":@"id",
             };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _cellHeight = 100;
    
    
    NSArray * coverArray = dic[@"cover"];
        
    if ([coverArray isKindOfClass:[NSArray class]] && coverArray.count == 3)
    {
            //三张图片
        _cellHeight = 180;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",dic[@"time"]];
    self.time = [timeStr timeFormatter];
    if (_newsID && _newsID.length>0)
    {
        //已读对比
       self.haveRead = [[EVCoreDataClass shareInstance] checkHaveReadNewsid:_newsID ];
    }
    
    return YES;
}
@end
