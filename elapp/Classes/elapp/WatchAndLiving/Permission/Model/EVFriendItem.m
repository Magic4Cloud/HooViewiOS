//
//  EVFriendItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFriendItem.h"
#import "NSString+HLHanZiToPinYin.h"

@implementation EVFriendItem

- (NSString *)pinyin
{
    if ( _pinyin == nil )
    {
        _pinyin = [self.remarks pinYin];
    }
    return _pinyin;
}

- (BOOL)isEqual:(id)object
{
    EVFriendItem *item = (EVFriendItem *)object;
    return [self.imuser isEqualToString:item.imuser];
}

@end
