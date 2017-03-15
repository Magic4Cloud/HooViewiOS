//
//  EVUserTagsModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/26.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVUserTagsModel.h"

@implementation EVUserTagsModel
+(NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id":@"tagid",@"name":@"tagname"};
}
@end
