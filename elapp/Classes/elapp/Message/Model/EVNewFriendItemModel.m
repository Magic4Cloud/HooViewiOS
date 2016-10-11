//
//  EVNewFriendItemModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNewFriendItemModel.h"

@interface EVNewFriendItemModel ()

@property (nonatomic, copy)NSString *nickname;

@end

@implementation EVNewFriendItemModel


+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    EVNewFriendItemModel *item = [[EVNewFriendItemModel alloc] init];
    item.update_time = [dict objectForKey:@"time"];
    item.content = kE_GlobalZH(@"message_followed_you");
    NSDictionary *content = [dict objectForKey:@"content"];
    item.contentDic = content;
    NSDictionary *data = [content objectForKey:@"data"];
    NSString *nickname = [data objectForKey:@"nickname"];
    NSString *name = [data objectForKey:@"name"];
    item.name = name;
    item.nickname = nickname;
    item.icon = [data objectForKey:@"logourl"];
    if (nickname.length == 0)
    {
        if (name.length > 0)
        {
            item.title = name;
        }
        else
        {
            item.title = @"";
        }
    }
    else
    {
        item.title = [NSString stringWithFormat:@"%@",nickname];
    }
    
    return item;
}

- (NSString *)title
{
    return self.nickname;
}

@end
