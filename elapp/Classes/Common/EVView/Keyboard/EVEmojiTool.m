//
//  EVEmojiTool.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVEmojiTool.h"
#import "EVFace.h"
#import "EVFaceAttachment.h"

@interface EVEmojiTool ()

@property ( nonatomic, strong ) NSRegularExpression *regx;

@end

@implementation EVEmojiTool

+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    static EVEmojiTool *tool;
    dispatch_once(&onceToken, ^{
        tool = [[EVEmojiTool alloc] init];
    });
    return tool;
}

static NSArray *_emojis;
+ (void)load{
    [self emojiArray];
}

+ (NSArray *)emojiArray{
    if ( _emojis == nil ) {
        NSString *faceFileName = @"expression.plist";
        _emojis = [EVFace faceArrayWithFileName:faceFileName];
    }
    return _emojis;
}

+ (EVFace *)faceWithFaceString:(NSString *)faceString{
    for (EVFace *item in _emojis) {
        if ( [item.faceString isEqualToString:faceString] ) {
            return item;
        }
    }
    return nil;
}

+ (NSString *)rawStringFromAttributString:(NSAttributedString *)arrtibuteString characterCount:(NSInteger *)countP{
    __block NSInteger emojiStringLength = 0;
    NSMutableString *text = [NSMutableString string];
    NSRange range = NSMakeRange(0, arrtibuteString.length);
    [arrtibuteString enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if ( [attrs[@"NSAttachment"] isKindOfClass:[EVFaceAttachment class]] ) {
            EVFaceAttachment *att = attrs[@"NSAttachment"];
            [text appendString:att.faceString];
            emojiStringLength++;
        } else {
            NSString *str = [arrtibuteString.string substringWithRange:range];
            NSUInteger lengthStr = [EVEmojiTool calStrLengthAttStr:str limit:30];
            emojiStringLength += lengthStr;
            [text appendString:str];
        }
    }];
    NSString *result = [text copy];
//    result = [result stringByReplacingEmojiUnicodeWithCheatCodes];
    if ( countP != NULL ) {
        *countP = emojiStringLength;
    }
    return result;
}

+ (NSInteger)calStrLengthAttStr:(NSString *)attStr limit:(NSInteger)limit
{
    NSUInteger numOfWord = 0;
    NSUInteger j = 0;           // 统计2个英文字符
    for ( NSUInteger i = 0; i < attStr.length; i++  )
    {
        NSString *onewordStr = [attStr substringWithRange:NSMakeRange(i, 1)];
        const char *onewordChar = [onewordStr cStringUsingEncoding:NSASCIIStringEncoding];
        if ( onewordChar )  // 如果是英文，j+1，当j = 2时，字数+1，并把j置为0
        {
            if (limit && numOfWord >= limit)
            {
                numOfWord += 1;
                j = 0;
            }
            else
            {
                j++;
                if ( 2 == j )
                {
                    numOfWord += 1;
                    j = 0;
                }
            }
        }
        else
        {
            numOfWord += 1;
        }
    }
    return numOfWord;
}

+ (NSMutableAttributedString *)attributStringByString:(NSString *)text lineHeight:(CGFloat)lineHeight{
//    text = [text stringByReplacingEmojiCheatCodesWithUnicode];
    EVEmojiTool *tool = [EVEmojiTool shareTool];
    NSArray *results = [tool.regx matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableAttributedString *result= [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < results.count; i++) {
        NSTextCheckingResult *item = results[i];
        NSMutableAttributedString *itemAttr = nil;
        NSAttributedString *faceAttributeString = [self faceAttributStringWithFace:[text substringWithRange:item.range] lineHeight:lineHeight];
        if ( i == 0 ) {
            itemAttr = [[NSMutableAttributedString alloc] initWithString:[text substringWithRange:NSMakeRange(0, item.range.location)]];
            [itemAttr appendAttributedString:faceAttributeString];
        } else  {
            NSTextCheckingResult *preItem = results[i - 1];
            NSInteger preLocation = preItem.range.location + preItem.range.length;
            NSString *textString = [text substringWithRange:NSMakeRange(preLocation, item.range.location - preLocation)];
            itemAttr = [[NSMutableAttributedString alloc] initWithString:textString];
            [itemAttr appendAttributedString:faceAttributeString];
            if ( i == (NSInteger)results.count - 1 && item.range.location + item.range.length < text.length ) {
                [itemAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[text substringFromIndex:item.range.location + item.range.length]]];
            }
        }
        [result appendAttributedString:itemAttr];
    }
    if ( results.count == 0 ) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    }
    if ( results.count == 1 )
    {
        NSTextCheckingResult *item = results[0];
        NSRange range = NSMakeRange(item.range.location + item.range.length, text.length - item.range.location - item.range.length);
        NSString *itemStr = [text substringWithRange:range];
        NSMutableAttributedString *itemAttr = [[NSMutableAttributedString alloc] initWithString:itemStr];
        [result appendAttributedString:itemAttr];
    }
    return result;
}

+ (NSAttributedString *)faceAttributStringWithFace:(NSString *)faceString lineHeight:(CGFloat)lineHeight{
    EVFace *face = [EVEmojiTool faceWithFaceString:faceString];
    if ( face == nil ) {
        return [[NSMutableAttributedString alloc] initWithString:faceString];
    }
    return [EVFaceAttachment attributedStringWith:face lineHeight:lineHeight];
}

- (NSRegularExpression *)regx
{
    if ( !_regx )
    {
        NSString *pattern = @"\\[(.*?)\\]";
        _regx = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    }
    return _regx;
}

@end
