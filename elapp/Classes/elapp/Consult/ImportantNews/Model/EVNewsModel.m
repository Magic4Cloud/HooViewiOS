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
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",dic[@"time"]];
    timeStr =   [timeStr substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeLbl = [NSString stringWithFormat:@"%@",dic[@"time"]];
    if (timeLbl.length>10) {
        NSString *lTime = [NSString stringWithFormat:@"%@/%@ %@",[timeLbl substringWithRange:NSMakeRange(5, 2)],[timeLbl substringWithRange:NSMakeRange(8, 2)],[timeLbl substringWithRange:NSMakeRange(11, 5)]];
        if (![currentDateStr isEqualToString:timeStr]) {
            self.time = [NSString stringWithFormat:@"%@",lTime];
        }else {
            self.time = [NSString stringWithFormat:@"今天 %@",[timeLbl substringWithRange:NSMakeRange(11, 5)]];
        }
    }
    
    
    if (![dic[@"cover"] isKindOfClass:[NSArray class]] ) {
        return YES;
    }
    else
    {
        NSArray * array =  dic[@"cover"];
        if (array.count>0) {
            if ([array[0] isEqual:[NSNull null]]) {
                return YES;
            }
        }
        else
        {
            return YES;
        }
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
