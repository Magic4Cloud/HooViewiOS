//
//  EVSettingItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSettingItem.h"

@implementation EVSettingItem

+ (instancetype) itemWithIconName:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle type:(EVSettingItemType)type
{
    EVSettingItem *item = [[EVSettingItem alloc] init];
    item.title = title;
    item.iconName = iconName;
    item.subTitle = subTitle;
    item.type = type;
    return item;
}

@end
