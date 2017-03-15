//
//  EVMarketTextView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/12.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMarketTextView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"

#define kMaxLength 140


@interface EVMarketTextView ()<UITextFieldDelegate>



@end

@implementation EVMarketTextView

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
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.frame = CGRectMake(0, 0, ScreenWidth, 49);
    
    UITextField *inputTextFiled = [[UITextField alloc] init];
    [self addSubview:inputTextFiled];
    [inputTextFiled autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [inputTextFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [inputTextFiled autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 110, 25)];
    inputTextFiled.delegate = self;
    inputTextFiled.tintColor = [UIColor evMainColor];
    inputTextFiled.textColor = [UIColor evTextColorH1];
    inputTextFiled.font = [UIFont textFontB2];
    self.inPutTextFiled = inputTextFiled;
    inputTextFiled.returnKeyType = UIReturnKeySend;
    
    UIButton *sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    [sendButton setImage:[UIImage imageNamed:@"btn_send_n"] forState:(UIControlStateNormal)];
    [sendButton setImage:[UIImage imageNamed:@"btn_send_s"] forState:UIControlStateSelected];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [sendButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [sendButton autoSetDimensionsToSize:CGSizeMake(54, 49)];
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel *numLabel = [[UILabel alloc] init];
    [self addSubview:numLabel];
    self.numLabel = numLabel;
    numLabel.font = [UIFont textFontB3];
    numLabel.textColor = [UIColor evTextColorH2];
    [numLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:54];
    [numLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [numLabel autoSetDimensionsToSize:CGSizeMake(100, 20)];
    numLabel.textAlignment = NSTextAlignmentRight;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:UITextFieldTextDidChangeNotification object:inputTextFiled];
    
}

- (void)dealloc {
    [EVNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:_inPutTextFiled];
}

-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length > 0) {
        self.sendButton.selected = YES;
    }
    else {
        self.sendButton.selected = NO;
    }
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
    if (toBeString.length > kMaxLength) {
        textField.text = [toBeString substringToIndex:kMaxLength];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] )
    {
        [textField resignFirstResponder];
        return NO;
    }
    else
    {
        NSString * replacedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ( replacedText.length > 140 )
        {
            textField.text = [replacedText substringToIndex:140];
            return NO;
        }
    }
    
    return YES;
}

- (void)sendClick:(UIButton *)btn
{
    if (self.commentBlock) {
        self.commentBlock(_inPutTextFiled.text);
    }
    
}
@end
