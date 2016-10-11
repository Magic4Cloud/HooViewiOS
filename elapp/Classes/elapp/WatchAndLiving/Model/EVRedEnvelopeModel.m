//
//  EVRedEnvelopeModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRedEnvelopeModel.h"

@implementation EVRedEnvelopeItemModel

- (BOOL)isEqual:(id)object
{
    if ( self == object )
    {
        return YES;
    }
    
    if ( [object isKindOfClass:[EVRedEnvelopeItemModel class]] )
    {
        EVRedEnvelopeItemModel *temp = ( EVRedEnvelopeItemModel * )object;
        return [temp.name isEqualToString:self.name];
    }
    
    return NO;
}

@end

@implementation EVRedEnvelopeModel

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"hb" : [EVRedEnvelopeItemModel class]};
}

@end
