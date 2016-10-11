//
//  EVAudience.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudience.h"
#import "NSString+Extension.h"
#import "NSDictionary+JSON.h"
#import "EVSDKLiveMessageEngine.h"
#import "EVSDKLiveEngineParams.h"

@implementation EVAudience

- (void)dealloc
{
//    CCLog(@"CCAudience dealloc");
}

+ (instancetype)audienceWithJSONString:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return [self objectWithDictionary:dict];
}

- (BOOL)isEqual:(id)object
{
    if ( ![object isKindOfClass:[EVAudience class]] )
    {
        return NO;
    }
    else
    {
        if ( object == self )
        {
            return YES;
        }
        else
        {
            EVAudience *target = (EVAudience *)object;
            return [self.name isEqualToString:target.name];
        }
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.guest = [name cc_containString:@"g"];
}

- (void)updateDataWithInfo:(NSDictionary *)info
{
    self.operationType = CCAudienceOperationNone;
    self.name = nil;
    self.nickname = nil;
    self.logourl = nil;
    
    self.name = [info cc_objectWithKey:EVMessageKeyNm];
    self.nickname = [info cc_objectWithKey:EVMessageKeyNk];
    self.logourl = [EVSDKLiveMessageEngine logourlWithLogoSufix:[info cc_objectWithKey:EVMessageKeyLg]];
}

@end
