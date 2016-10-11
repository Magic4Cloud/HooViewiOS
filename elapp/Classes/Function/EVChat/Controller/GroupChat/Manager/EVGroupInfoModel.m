//
//  EVGroupInfoModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupInfoModel.h"

@implementation EVGroupInfoModel

+(instancetype)modelWithTitle:(NSString *)title infoText:(NSString *)infoText icon:(NSString *)icon detailText:(NSString *)detailText clazz:(NSString *)clazz;

{
    EVGroupInfoModel *model = [[EVGroupInfoModel alloc] init];
    model.title = title;
    model.infoText= infoText;
    model.icon = icon;
    model.detailText = detailText;
    model.clazz = clazz;
    
    return model;
}


@end
