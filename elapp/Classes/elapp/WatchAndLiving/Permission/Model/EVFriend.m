//
//  EVFriend.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFriend.h"

@implementation EVFriend

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames{
    return @{ @"id": @"friendId"};
}

- (BOOL)isEqual:(id)object
{
    if ( object == self )
    {
        return YES;
    }
    
    if ( [object isKindOfClass:[self class]] )
    {
        return [[object friendId] isEqualToString:self.friendId];
    }
    
    return NO;
}

@end
