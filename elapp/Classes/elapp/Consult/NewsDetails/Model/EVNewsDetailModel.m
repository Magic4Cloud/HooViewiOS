//
//  EVNewsDetailModel.m
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsDetailModel.h"
#import "EVHVVideoCommentModel.h"
@implementation EVTagModel

@end

@implementation EVAuthorModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"descriptionStr":@"description",
             };
}


@end

@implementation EVStockModel

@end


@implementation EVNewsDetailModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"tag" : [EVTagModel class],@"stock" : [EVStockModel class],@"recommendNews" : [EVNewsModel class],@"posts" : [EVHVVideoCommentModel class]};
}



@end
