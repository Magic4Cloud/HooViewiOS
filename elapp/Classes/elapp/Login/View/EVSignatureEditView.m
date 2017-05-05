//
//  EVSignatureEditView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSignatureEditView.h"
#import "UITextView+WZB.h"

@interface EVSignatureEditView () <UITextViewDelegate>

@property (nonatomic, strong) UIControl *touchLayer;

@property (nonatomic, weak) UIView *backView;

@property (nonatomic, weak) UITextView *inputTextView;



@end

@implementation EVSignatureEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _caninputlen = 100;
        [self addUpView];
        
    }
    return self;
}

- (void)addUpView
{
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyAndVisible];
    self.backgroundColor = [UIColor clearColor];
    self.touchLayer = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.touchLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.touchLayer];
    
    [self.touchLayer addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    self.backView = backView;
    backView.backgroundColor = [UIColor evBackgroundColor];
    backView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 194);
    
    
    UITextView  *inputView = [[UITextView alloc] init];
    [backView addSubview:inputView];
    inputView.delegate = self;
    self.inputTextView = inputView;
    inputView.font = [UIFont textFontB2];
    inputView.layer.cornerRadius = 4;
    inputView.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    inputView.layer.borderWidth = 1;
    inputView.clipsToBounds = YES;
    [inputView becomeFirstResponder];
    
    inputView.placeholder = @"您可以介绍一下自己";
    if ([_type isEqualToString:@"introduce"]) {
        inputView.placeholder = @"您可以介绍填写您的详细资料";
    }
    inputView.placeholderColor = [UIColor colorWithHexString:@"#cccccc"];
    [inputView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [inputView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:19];
    [inputView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
    [inputView autoSetDimension:ALDimensionHeight toSize:120];
    
    UIButton *confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backView addSubview:confirmButton];
    confirmButton.layer.cornerRadius = 6;
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.borderWidth = 1;
    confirmButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    [confirmButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:inputView];
    [confirmButton autoSetDimensionsToSize:CGSizeMake(79, 30)];
    [confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:inputView withOffset:12];
    [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    _confirmButton = confirmButton;
    
    [_confirmButton setBackgroundColor:[UIColor whiteColor]];
    [_confirmButton setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    _confirmButton.enabled = NO;

    
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
        [_confirmButton setBackgroundColor:[UIColor evMainColor]];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.enabled = YES;
    
    
    if (comcatstr.length > _caninputlen)
    {
        [textView setText:[textView.text substringWithRange:NSMakeRange(0, _caninputlen)]];
        
        return NO;
    }
    
    return YES;
}

- (void)setCaninputlen:(int)caninputlen
{
    _caninputlen = caninputlen;
}
- (void)keyBoardShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(0, ScreenHeight - frame.size.height - 194, ScreenWidth, 194);
    }];
    
}

- (void)confirmClick:(UIButton *)btn
{
    [self confirm];
}

- (void)cancelClick:(UIButton *)btn
{
    [self hide];
}
- (void)confirm {
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (self.confirmBlock) {
            self.confirmBlock(self.inputTextView.text);
        }
    }];
}

- (void)hide
{
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 100);
    } completion:^(BOOL finished) {
        
        if (self.hideViewBlock) {
            self.hideViewBlock(self.inputTextView.text);
            
        }
    }];
}

- (void)setOriginText:(NSString *)originText {
    _originText = originText;
    
    
    if (!originText) {
        return;
    }
    _inputTextView.text = originText;
}

- (void)setInputPlaceholder:(NSString *)inputPlaceholder
{
    _inputPlaceholder = inputPlaceholder;
    _inputTextView.placeholder = inputPlaceholder;
}
@end
