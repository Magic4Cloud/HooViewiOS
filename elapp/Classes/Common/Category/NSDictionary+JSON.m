//
//  NSDictionary+JSON.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
- (NSString *)jsonString {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error)
        return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSData *)jsonData
{
    return [NSJSONSerialization dataWithJSONObject:self
                                           options:0
                                             error:NULL];
}

- (id)cc_objectWithKey:(NSString *)key
{
    id value = self[key];
    
    if ( [value isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    return value;
}

@end
