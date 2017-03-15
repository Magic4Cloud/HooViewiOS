//
//  EVChooseNewsModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVChooseNewsModel.h"
#import "EVStockBaseModel.h"
@implementation EVChooseNewsModel
+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id":@"newsID"};
}
+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"stocks" : [EVStockBaseModel class]};
}
@end
