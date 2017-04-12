//
//  EVTopicModel.m
//  elapp
//
//  Created by 唐超 on 4/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVTopicModel.h"

@implementation EVTopicModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"news" : [EVNewsModel class],
             };
}
@end
