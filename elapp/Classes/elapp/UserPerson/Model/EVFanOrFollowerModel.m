//
//  EVFanOrFollowerModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFanOrFollowerModel.h"
#import "NSString+HLHanZiToPinYin.h"

@implementation EVFanOrFollowerModel


- (NSString *)pinyin
{
    if ( _pinyin == nil )
    {
        _pinyin = [self.remarks pinYin];
    }
    return _pinyin;
}

@end
