//
//  EVDanmuModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVDanmuModel.h"

@implementation EVDanmuModel

+ (EVDanmuModel *)modelFromDictionary:(NSDictionary *)dic comment:(NSString *)comment
{
    EVDanmuModel * danmuModel = [[EVDanmuModel alloc] init];
    NSDictionary *exbrDict = dic[@"exbr"];
    danmuModel.anchor_level = [[dic objectForKey:@"anchor_level"] integerValue];
    danmuModel.content = [NSString stringWithFormat:@"%@",comment];
    danmuModel.level = [[dic objectForKey:@"level"] integerValue];
    danmuModel.logo = [exbrDict objectForKey:@"lg"];
    danmuModel.name = [exbrDict objectForKey:@"nm"];
    danmuModel.nickname = [exbrDict objectForKey:@"nk"];
    danmuModel.type = [[dic objectForKey:@"type"] integerValue];
    danmuModel.vip_level = [[dic objectForKey:@"vip_level"] integerValue];
    return danmuModel;
}

@end
