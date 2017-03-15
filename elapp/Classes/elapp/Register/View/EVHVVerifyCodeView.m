//
//  EVHVVerifyCodeView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHVVerifyCodeView.h"

@interface EVHVVerifyCodeView ()<UITextFieldDelegate>
@property (nonatomic, weak) UILabel *codeLabel;
@end


@implementation EVHVVerifyCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.timeButton addTarget:self action:@selector(timeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.codeTextFiled.delegate = self;
    self.codeTextFiled.hidden = YES;
    [self.codeTextFiled becomeFirstResponder];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.textBackView addGestureRecognizer:tap];
    
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *codeLabel = [[UILabel alloc] init];
        CGFloat backViewF = self.textBackView.frame.size.width;
        CGFloat codeLabelWid = (backViewF - 80) / 4;
        int  codeLabelInt = (int)codeLabelWid;
        codeLabel.frame = CGRectMake((i*29)+(i*codeLabelInt),20,codeLabelInt, 30);
        codeLabel.backgroundColor = [UIColor whiteColor];
        codeLabel.font = [UIFont systemFontOfSize:16.f];
        codeLabel.textColor = [UIColor evTextColorH2];
        codeLabel.textAlignment = NSTextAlignmentCenter;
        [self.textBackView addSubview:codeLabel];
        self.codeLabel = codeLabel;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.codeLabel addGestureRecognizer:tap];
        
        codeLabel.tag = 1000+i;
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake((i*29)+(i*codeLabelInt), CGRectGetMaxY(codeLabel.frame)+5, codeLabelInt, 1);
        lineLabel.backgroundColor = [UIColor evLineColor];
        [self.textBackView addSubview:lineLabel];
    }

    NSString * oneStr = @"没有收到短信? 再次发送 (60秒)";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",oneStr]];
    //修改某个范围内字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH1]  range:NSMakeRange(0,12)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evMainColor]  range:NSMakeRange(13,5)];
    [self.timeButton setAttributedTitle:str forState:(UIControlStateNormal)];
    [self.timeButton setEnabled:NO];
}

- (void)tapClick
{
    [self.codeTextFiled becomeFirstResponder];
}

- (IBAction)nextButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextButton)]) {
        [self.delegate nextButton];
    }
}

- (void)timeClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeButton:)]) {
        [self.delegate timeButton:btn];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger textLength = textField.text.length;
    if (range.length == 1) {
        UILabel *codeLabel  =  [self viewWithTag:(range.location+1000)];
        [UIView animateWithDuration:2 animations:^{
            [codeLabel setText:@""];
            [codeLabel setFont:[UIFont systemFontOfSize:16.f]];
        } completion:^(BOOL finished) {
            
        }];
        return YES;
    }else {
        if (textLength >= 4) {
            return NO;
        }
        UILabel *codeLabel  =  [self viewWithTag:(range.location+1000)];
        [UIView animateWithDuration:2 animations:^{
            [codeLabel setText:string];
            [codeLabel setFont:[UIFont systemFontOfSize:16]];
        } completion:^(BOOL finished) {
            
        }];
    }
   
  
 
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.codeTextFiled resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


@end
