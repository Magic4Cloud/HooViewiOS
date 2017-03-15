//
//  EVTextViewWithPlaceHolderAndClearButton.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTextViewWithPlaceHolderAndClearButton.h"

@interface EVTextViewWithPlaceHolderAndClearButton ()<UITextViewDelegate>
{
    UILabel *_placeHolderLabel;
}

@end

@implementation EVTextViewWithPlaceHolderAndClearButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super initWithCoder:aDecoder] ) {
        self.delegate = self;
        self.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame] ) {
        self.delegate = self;
        self.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    }
    return self;
}

- (void)addPlaceHoldLabel {
    CGRect frame = [self.placeHolder boundingRectWithSize:CGSizeMake(ScreenWidth - 34.0f, self.frame.size.height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [[EVAppSetting shareInstance] normalFontWithSize:14]} context:nil];
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth - 34.0f, frame.size.height + 20)];
    _placeHolderLabel.text = self.placeHolder;
    _placeHolderLabel.textColor = [UIColor evGlobalSeparatorColor];
    _placeHolderLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14];
    _placeHolderLabel.numberOfLines = 0;
    if ( ![self.text isEqualToString:@""] ) {
        [self addSubview:_placeHolderLabel];
    } else {
        
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = placeHolder;
    }
    
    [self addPlaceHoldLabel];
}

#pragma mark - UITextView delegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 1) {
        _placeHolderLabel.hidden = YES;
    } else {
        _placeHolderLabel.hidden = NO;
    }
}

@end
