//
//  EVLiveTitleTextView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveTitleTextView.h"

@interface EVLiveTitleTextView ()

@property ( weak, nonatomic ) UITextView *placeholderLabel;

@end

@implementation EVLiveTitleTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        
        UITextView *placeholderLabel = [[UITextView alloc] init];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        self.placeholderLabel = placeholderLabel;
        self.placeholderLabel.userInteractionEnabled = NO;
        self.placeholderLabel.editable = NO;
        [self addSubview:placeholderLabel];
        [CCNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged
{
    self.placeholderLabel.hidden = self.attributedText.length != 0 && self.text.length != 0;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.placeholderLabel.hidden = self.attributedText.length != 0 && self.text.length != 0;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.placeholderLabel.hidden = self.attributedText.length != 0 && self.text.length != 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderLabel.frame = self.bounds;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
    self.placeholderLabel.font = CCNormalFont(17);
    self.placeholderLabel.textColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.5];
}

@end
