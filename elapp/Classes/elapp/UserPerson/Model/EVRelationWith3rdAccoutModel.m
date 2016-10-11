//
//  EVRelationWith3rdAccoutModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVRelationWith3rdAccoutModel.h"

@implementation EVRelationWith3rdAccoutModel

- (id)initWithCoder:(NSCoder *)decoder{
    EVRelationWith3rdAccoutModel *item = [[[self class] alloc] init];
    item.expire_time = [decoder decodeObjectForKey:@"expire_time"];
    item.token = [decoder decodeObjectForKey:@"token"];
    item.type = [decoder decodeObjectForKey:@"type"];
    item.login = [decoder decodeBoolForKey:@"login"];
    
    return item;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.expire_time forKey:@"expire_time"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeBool:self.login forKey:@"login"];
}

@end
