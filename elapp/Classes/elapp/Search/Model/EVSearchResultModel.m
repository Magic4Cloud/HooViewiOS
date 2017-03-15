//
//  EVSearchResultModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSearchResultModel.h"
#import "EVFindUserInfo.h"
#import "EVNowVideoItem.h"
#import "EVBaseNewsModel.h"
#import "EVStockBaseModel.h"

@implementation EVSearchResultModel

#pragma mark - 重写字典转模型的方法

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"users" : [EVFindUserInfo class],
             @"lives" : [EVNowVideoItem class],
             @"videos" : [EVNowVideoItem class],
             @"news" : [EVBaseNewsModel class],
             @"data": [EVStockBaseModel class]};
}




@end
