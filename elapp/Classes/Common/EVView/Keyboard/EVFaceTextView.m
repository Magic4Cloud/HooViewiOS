//
//  EVFaceTextView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFaceTextView.h"
#import "EVFace.h"
#import "EVFaceAttachment.h"
#import "NSAttributedString+Extension.h"

#define kDefaultTextFieldHeight 44

#define kDefaultComfirmButtonWidth 65
#define kDefaultFont [UIFont systemFontOfSize:15]

#define kDefaultComfirmButtonHeight kDefaultTextFieldHeight
#define kDefauntComfirmTitle kOK
#define kDefaultPlaceHolder kE_GlobalZH(@"see_title")  
#define kDefaultLayerCorner 3
#define kDefauntEmojiKeyBackGroundColor [UIColor colorWithHexString:@"#1f1f1f" alpha:0.8]

#define kKeyBoardHeight 210
#define kCellMargin 15
#define kBorderMargin 20
#define kItemWH 45
// 38

#define kGroupSize 21

#define kButtonWH 35

@interface EVFaceTextView ()
{
    NSInteger _emojiStringLength;
}

@end

@implementation EVFaceTextView


- (NSString *)rawString
{
    _emojiStringLength = 0;
    
    NSString *result = [self.attributedText cc_rawStringWithCharacterCount:&_emojiStringLength];
    return result;
}

- (NSInteger)emojiStringLength
{
    [self rawString];
    return _emojiStringLength;
}

- (void)inputFace:(EVFace *)face
{
    if ( face.deleteFace )
    {
        if ( self.attributedText.length == 0 ) {
            return;
        }
        [self deleteBackward];
        return;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSAttributedString *faceAttributeString = [EVFaceAttachment attributedStringWith:face lineHeight:self.font.lineHeight];
    // place to select place
    [attrString replaceCharactersInRange:self.selectedRange withAttributedString:faceAttributeString];
    NSRange range = NSMakeRange(0, attrString.length);
    // reset select location
    CGFloat location = self.selectedRange.location;
    // reset attribute
    [attrString addAttribute:NSFontAttributeName value:self.font range:range];
    if ( self.textColor )
    {
        [attrString addAttributes:@{NSForegroundColorAttributeName: self.textColor} range:NSMakeRange(0, attrString.length)];
    }
    self.attributedText = attrString;
    self.selectedRange = NSMakeRange(location + 1, 0);
}

@end
