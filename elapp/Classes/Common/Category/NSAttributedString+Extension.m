//
//  NSAttributedString+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "NSAttributedString+Extension.h"
#import "EVEmojiTool.h"

@implementation NSAttributedString (Extension)

- (NSString *)cc_rawStringWithCharacterCount:(NSInteger *)countP {
    return [EVEmojiTool rawStringFromAttributString:self characterCount:countP];
}

@end
