//
//  EVVideoTopicItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVVideoTopicItem.h"

@interface EVVideoTopicItem ()
{
    UIImage *_select_icon_image;
    UIImage *_supericon_image;
}

@end

@implementation EVVideoTopicItem

- (UIImage *)selecticon_image
{
    if ( _select_icon_image )
    {
        return _select_icon_image;
    }
    
    if ( self.selecticon_imagePath == nil )
    {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:self.selecticon_imagePath];
    
    if ( data )
    {
        _select_icon_image = [[UIImage alloc] initWithData:data];
    }
    
    return _select_icon_image;
}

- (UIImage *)supericon_image
{
    if ( _supericon_image )
    {
        return _supericon_image;
    }
    
    if ( self.supericon_imagePath == nil )
    {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:self.supericon_imagePath];
    
    if ( data )
    {
         _supericon_image = [[UIImage alloc] initWithData:data];
    }
    
    return _supericon_image;
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id" : @"topic_id"};
}
@end
