//
//  EVVideoAndLiveModel.m
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVVideoAndLiveModel.h"

@implementation EVVideoAndLiveModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if ([dic[@"watch_count"] integerValue]>=10000) {
        _isHot = YES;
    }
    else
    {
        _isHot = NO;
    }
    
    return YES;
}
@end
