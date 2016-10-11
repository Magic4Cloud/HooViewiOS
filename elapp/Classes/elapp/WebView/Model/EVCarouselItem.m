//
//  EVCarouselItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCarouselItem.h"

@implementation EVCarouselItem

- (void)setContent:(NSDictionary *)content
{
    _content = content;
    self.data = content[kData];
    self.type = [content[kType] integerValue];
}

- (NSString *)noticeID
{
    if ( self.type == CCCarouselItemForecast )
    {
        return self.data[@"notice_id"];
    }
    return nil;
}

- (NSString *)activetyID
{
    if ( self.type == CCCarouselItemActivity )
    {
        return self.data[@"activity_id"];
    }
    return nil;
}

- (NSString *)web_url
{
    if ( self.type == CCCarouselItemWebType )
    {
        return self.data[@"web_url"];;
    }
    return nil;
}

- (NSString *)title
{
    if ( self.type == CCCarouselItemWebType )
    {
        return self.data[@"title"];;
    }
    return nil;
}

- (BOOL)isEqual:(id)object
{
    if ( self == object )
    {
        return YES;
    }
    
    if ( [object isKindOfClass:[EVCarouselItem class]] )
    {
        EVCarouselItem *temp = ( EVCarouselItem * )object;
        
        return [temp.thumb isEqualToString:self.thumb] && self.type == temp.type;
    }
    
    return NO;
}

@end
