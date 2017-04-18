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

@property (nonatomic, assign) NSInteger caninputlen;

@end

@implementation EVSignatureEditView

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
    backView.frame = CGRectMake(0, 200, ScreenWidth, 194);
    
    
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
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backView addSubview:cancelButton];
    [cancelButton setBackgroundColor:[UIColor evGlobalSeparatorColor]];
    [cancelButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.layer.cornerRadius = 6;
    cancelButton.clipsToBounds = YES;
    [cancelButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:confirmButton withOffset:-16];
    [cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:inputView withOffset:12];
    [cancelButton autoSetDimensionsToSize:CGSizeMake(79, 30)];
    [cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [EVNotificationCenter addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([_type isEqualToString:@"introduce"]) {
        _caninputlen = 100 - comcatstr.length;
    } else {
        _caninputlen = 20 - comcatstr.length;
    }
    
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (_caninputlen >= 0) {
        return YES;
    }
    else {
        NSInteger len = text.length + _caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)keyBoardShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, ScreenHeight - frame.size.height - 194, ScreenWidth, 194);
    
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

@end
