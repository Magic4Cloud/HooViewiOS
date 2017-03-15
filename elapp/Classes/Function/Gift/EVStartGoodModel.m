//
//  EVStartGoodModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVStartGoodModel.h"

@implementation EVStartGoodModel

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id": @"ID"};
}

- (UIImage *)costImage
{
    NSString *iconStr = nil;
    if ( self.costtype == 0 ) // 表情
    {
        iconStr = @"living_icon_yimi";
    }
    else    // 礼物
    {
        iconStr = @"living_icon_money";
    }
    UIImage *iconImage = [UIImage imageNamed:iconStr];
    return iconImage;
}

+ (EVStartGoodModel *)modelWithDict:(NSDictionary *)dict
{
    EVStartGoodModel *startModel = [[EVStartGoodModel alloc]init];
    startModel.name = dict[@"nk"];
    startModel.ID = [dict[@"gid"] integerValue];
    startModel.selectNum = [dict[@"gct"] integerValue];
    startModel.pic = dict[@"glg"];
    startModel.anitype = [dict[@"gtp"] integerValue];
    startModel.giftName = dict[@"gnm"];
    
    return startModel;
}

@end
