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
    
    if ([dic[@"type"] floatValue] == 0)
    {
        NSArray * coverArray = dic[@"cover"];
        
        if ([coverArray isKindOfClass:[NSArray class]] && coverArray.count == 3)
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
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",dic[@"time"]];
    if (timeStr.length > 10) {
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
    }
   
    
    return YES;
}
@end
