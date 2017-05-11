//
//  EVHVEyesModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVEyesModel.h"
#import "EVCoreDataClass.h"

@implementation EVHVEyesModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"eyesID":@"id"};
}

//自定义转换
/// Dic -> model
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if (_eyesID && _eyesID.length>0)
    {
        //已读对比
        self.haveRead = [[EVCoreDataClass shareInstance] checkHaveReadNewsid:_eyesID ];
    }

    return YES;
}
@end
