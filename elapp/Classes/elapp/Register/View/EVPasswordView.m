//
//  EVPasswordView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVPasswordView.h"


@interface EVPasswordView ()<UITextFieldDelegate>

@end

@implementation EVPasswordView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pwdTextFiled.secureTextEntry = YES;
    [self.pwdTextFiled becomeFirstResponder];
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = [UIColor evMainColor];
    [self.hidePwdButton setImage:[UIImage imageNamed:@"btn_visible_n"] forState:(UIControlStateSelected)];
}

- (IBAction)nextButton:(UIButton *)sender {
    if (self.nextClick) {
        self.nextClick(sender);
    }
}

- (IBAction)hidePwdButton:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        self.pwdTextFiled.secureTextEntry = YES;
    }else {
        sender.selected = YES;
        self.pwdTextFiled.secureTextEntry = NO;
    }
}

@end
