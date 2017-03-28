//
//  EVStartPageModel.m
//  elapp
//
//  Created by 唐超 on 3/27/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVStartPageModel.h"

@implementation EVStartPageModel

- (instancetype)initModelWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        if (dic[@"id"])        _id = dic[@"id"];
        if (dic[@"valid"])     _valid = dic[@"valid"];
        if (dic[@"starttime"]) _starttime = dic[@"starttime"];
        if (dic[@"endtime"])   _endtime = dic[@"endtime"];
        if (dic[@"adurl"])     _adurl = dic[@"adurl"];
    }
    return self;
}
@end
