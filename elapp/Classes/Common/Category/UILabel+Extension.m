//
//  UILabel+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSAttributedString+Extension.h"

#define kAnimationTime 0.025
#define kTotalAnimationTime 2.0

static NSInteger span = 0;

@implementation UILabel (Extension)

- (void)cc_setEmotionWithText:(NSString *)text{
    self.attributedText = [text cc_attributStringWithLineHeight:self.font.lineHeight];
}

- (NSString *)cc_rawStringFromAttributeString{
    return [self.attributedText cc_rawStringWithCharacterCount:NULL];
}

- (void)animationWithCount:(NSInteger)count
{
    if ( count > 10000 )
    {
        self.text = [NSString shortNumber:count];
        return;
    }
    static NSInteger i = 0;
    i ++;
    if ( span == 0 )
    {
        span = (count / 1000) + 2;
    }
    
    if ( self.text.length == 0 || self.text.integerValue == 0 )
    {
        int startCount = 0;
        self.text = [NSString stringWithFormat:@"%d",startCount];
    }
//    else
//    {
//        NSInteger currValue = self.text.integerValue;
//        currValue += span;
//        if ( currValue >= count )
//        {
//            span = 0;
//            self.text = [NSString stringWithFormat:@"%ld",count];
//            return;
//        }
//        self.text = [NSString stringWithFormat:@"%ld",currValue];
//    }
    
    NSInteger currValue = self.text.integerValue;
    currValue += span;
    if ( currValue >= count || i >= kTotalAnimationTime / kAnimationTime )
    {
        i = 0;
        span = 0;
        self.text = [NSString stringWithFormat:@"%ld",count];
        return;
    }
    self.text = [NSString stringWithFormat:@"%ld",currValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationWithCount:count];
    });

}

- (void)setAttributeTextWithWatch:(NSUInteger)watchCount like:(NSUInteger)likeCount comment:(NSUInteger)commentCount fontSize:(CGFloat)fontSize titleToTitleWhitespaceNumbers:(NSInteger)t_t_space_nums type:(CCCellType)type
{
    if ( !self )
    {
        return;
    }
    UIFont *font;
    if ( fontSize <= 0 )
    {
        // 给他一个默认字体
        font = [[CCAppSetting shareInstance] normalFontWithSize:11.0f];
    }
    else
    {
        font = [[CCAppSetting shareInstance] normalFontWithSize:fontSize];
    }
    // "看"是用来替换成图片的字，空格是图片与数字的间距
    NSMutableString *spaces = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < t_t_space_nums; ++i)
    {
        [spaces appendString:@" "];
    }
    NSString *watch = [NSString stringWithFormat:@"看%@%@", [NSString shortNumber:watchCount], spaces];
    NSString *like = [NSString stringWithFormat:@"看%@%@", [NSString shortNumber:likeCount], spaces];
    NSString *comment = [NSString stringWithFormat:@"看%@%@", [NSString shortNumber:commentCount], spaces];
    NSString *watchImgStr = nil;
    switch ( type )
    {
        case CCCellTypeVideo:
        {
            watchImgStr = @"video_list_icon_watch";
        }
            break;
            
        default:
        {
            watchImgStr = @"video_list_icon_watch";
        }
            break;
    }
    // NSMakeRange(0, 1) 不一定准
    NSAttributedString *introStr = [watch attributeStringWithReplaceRange:NSMakeRange(0, 1) replaceImage:watchImgStr textColor:[UIColor evTextColorH3] font:font];
    NSMutableAttributedString *introduction = [[NSMutableAttributedString alloc] initWithAttributedString:introStr];
    [introduction appendAttributedString:[like attributeStringWithReplaceRange:NSMakeRange(0, 1) replaceImage:@"video_list_icon_love" textColor:[UIColor evTextColorH3] font:font]];
    [introduction appendAttributedString:[comment attributeStringWithReplaceRange:NSMakeRange(0, 1) replaceImage:@"video_list_icon_review" textColor:[UIColor evTextColorH3] font:font]];
    self.attributedText = [introduction mutableCopy];
}

+ (UILabel *)labelWithBackgroundColor:(UIColor *)bgColor
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                          shadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = bgColor;
    label.textColor = textColor;
    label.font = font;
    label.shadowColor = shadowColor;
    label.shadowOffset = shadowOffset;
    
    return label;
}

+ (UILabel *)labelWithDefaultShadowTextColor:(UIColor *)textColor
                                        font:(UIFont *)font
{
    return [UILabel labelWithBackgroundColor:[UIColor clearColor] textColor:textColor font:font shadowColor:[UIColor colorWithHexString:@"#000000" alpha:.5f] shadowOffset:CGSizeMake(.3f, .3f)];
}

+ (UILabel *)labelWithBackgroundColor:(UIColor *)bgColor
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                        textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = bgColor;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    
    return label;
}

+ (UILabel *)labelWithDefaultTextColor:(UIColor *)textColor
                                  font:(UIFont *)font
{
    return [UILabel labelWithBackgroundColor:[UIColor clearColor] textColor:textColor font:font textAlignment:NSTextAlignmentLeft];
}

@end
