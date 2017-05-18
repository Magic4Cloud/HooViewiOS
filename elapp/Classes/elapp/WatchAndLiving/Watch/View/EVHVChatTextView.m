//
//  EVHVChatTextView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVChatTextView.h"
#import "YZInputView.h"
#import "NSString+Extension.h"

static NSUInteger const kMaxLimitNum = 140;

@interface EVHVChatTextView ()<UITextFieldDelegate, UITextViewDelegate>


@end

@implementation EVHVChatTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundColor = [UIColor whiteColor];
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    
    UIButton *giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    giftButton.backgroundColor = [UIColor colorWithHexString:@"#d66d6d"];
    giftButton.layer.masksToBounds = YES;
    giftButton.layer.cornerRadius = 17.5;
    giftButton.tag = EVHVChatTextViewTypeGift;
    [self addSubview:giftButton];
    self.giftButton = giftButton;
    [giftButton setImage:[UIImage imageNamed:@"btn_gift_n"] forState:(UIControlStateNormal)];
    [giftButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [giftButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [giftButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
    [giftButton autoSetDimensionsToSize:CGSizeMake(35, 35)];
    
    
    YZInputView *commentBtn = [[YZInputView alloc] init];
    [self addSubview:commentBtn];
    commentBtn.placeholder = @" 加入聊天吧";
    self.commentBtn = commentBtn;
    commentBtn.delegate = self;
    commentBtn.returnKeyType = UIReturnKeySend;
    commentBtn.layer.borderWidth = 1;
    commentBtn.layer.borderColor = [UIColor evLineColor].CGColor;
    commentBtn.layer.cornerRadius = 6;
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4];
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    self.commentBtnRig = [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:67];
    commentBtn.maxNumberOfLines = 4;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == EVHVChatTextViewTypeSend) {
        self.sendButton.selected = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatViewButtonType:)]) {
        [self.delegate chatViewButtonType:btn.tag];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = kMaxLimitNum - comcatstr.length;
    
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatViewButtonType:)]) {
            [self.delegate chatViewButtonType:EVHVChatTextViewTypeSend];
        }
        self.sendButton.selected = NO;
        return NO;
    }
    
    if (caninputlen >= 0) {
        self.sendButton.selected = YES;
        
        if (comcatstr.length == 0) {
            self.sendButton.selected = NO;
        }
        return YES;
    }
    else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        self.sendButton.selected = NO;
        return NO;
    }
    
}

@end
