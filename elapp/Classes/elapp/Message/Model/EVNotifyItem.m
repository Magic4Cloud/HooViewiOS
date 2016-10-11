//
//  EVNotifyItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotifyItem.h"


@implementation EVNotifyItem

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id" : @"Id"};
}

- (void)setLastest_content:(NSDictionary *)lastest_content
{
    _lastest_content = lastest_content;
    id data = [lastest_content objectForKey:@"data"];
    if ( [data isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary *dic = (NSDictionary *)data;
        NSString *text = [dic objectForKey:@"text"];
        if (text) {
            self.content = text;
        }
        else if ( [dic objectForKey:@"name"])
        {
            NSString *nickName = [dic objectForKey:@"nickname"];
            NSString *name = [dic objectForKey:@"name"];
            if (nickName.length == 0)
            {
                if (name.length > 0)
                {
                    nickName = name;
                }
                else
                {
                    nickName = @" ";
                }
            }
            self.content = [NSString stringWithFormat:@"\"%@\"%@",nickName,kE_GlobalZH(@"message_follow_you")];
        }
        else if ([dic objectForKey:@"graphic"])
        {
            self.content = kE_GlobalZH(@"kMessage_image");
        }
        
    }
}


@end
