//
//  EVMessage.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMessage.h"

@implementation EVMessage
- (void)setWithDict:(NSDictionary *)dict
{
    self.contentStr = dict[@"contentStr"];
    self.nameStr = dict[@"name"];
    self.messageFrom = [dict[@"from"] integerValue];
}
@end
