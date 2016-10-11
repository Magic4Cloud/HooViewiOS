//
//  EVMagicEmojiModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVMagicEmojiModel.h"

@implementation EVMagicEmojiModel

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id": @"Id"};
}

- (NSString *)costTypeStr
{
    if (self.costtype == 0)
    {
        return kE_GlobalZH(@"e_yimi");
    }
    else
    {
        return kE_Coin;
    }
}
@end
