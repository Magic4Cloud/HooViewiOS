//
//  EVTextLiveToolBar.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVTextLiveToolBar.h"
#import "YZInputView.h"


//来限制最大输入只能100个字符
#define MAX_LIMIT_NUMS     1000
@interface EVTextLiveToolBar ()<UITextViewDelegate>

@property (nonatomic, strong) NSLayoutConstraint *inputViewHig;


@property (nonatomic, strong) NSLayoutConstraint *lineViewHig;

@property (nonatomic, strong) NSLayoutConstraint *sendButtonHig;
@property (nonatomic, strong) NSLayoutConstraint *sendButtonWid;
@end

@implementation EVTextLiveToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    [self addInputView];
    
    
}

- (void)addInputView
{
    self.backgroundColor  = [UIColor whiteColor];
    YZInputView *inputTextView = [[YZInputView alloc] init];
    inputTextView.placeholder = @"快来聊天吧";
    inputTextView.placeholderColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self addSubview:inputTextView];
    inputTextView.delegate = self;
    inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    inputTextView.backgroundColor = [UIColor whiteColor];
    inputTextView.font = [UIFont textFontB2];
    self.inputTextView = inputTextView;
    [inputTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [inputTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:68];
    [inputTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [inputTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    // 设置文本框最大行数
    _inputTextView.maxNumberOfLines = 4;


    
    UIView *lineView  = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor evGlobalSeparatorColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:65];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [lineView autoSetDimension:ALDimensionWidth toSize:2];
    self.lineViewHig  = [lineView autoSetDimension:ALDimensionHeight toSize:49-10];
    
    
    UIButton *sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    [sendButton setImage:[UIImage imageNamed:@"btn_send_n"] forState:(UIControlStateNormal)];
    [sendButton setImage:[UIImage imageNamed:@"btn_send_s"] forState:(UIControlStateSelected)];
    [sendButton autoSetDimension:ALDimensionHeight toSize:49];
    [sendButton autoSetDimension:ALDimensionWidth toSize:65];
    [sendButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (comcatstr.length <= 0) {
        self.sendButton.selected = NO;
    }else {
        self.sendButton.selected = YES;
    }
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}


- (void)sendMessage:(UIButton *)send
{
    if (send.selected == NO) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageBtn:textToolBar:)]) {
        [self.delegate sendMessageBtn:send textToolBar:self];
        self.inputTextView.text = nil;
        self.sendButton.selected = NO;
        [self.inputTextView textDidChange];
    }
}
@end
