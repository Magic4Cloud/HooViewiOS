//
//  EVHVLoginView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHVLoginView.h"
#import <TTTAttributedLabel.h>

@interface EVHVLoginView ()<UITextFieldDelegate,TTTAttributedLabelDelegate>

@property (nonatomic, weak) TTTAttributedLabel *attributedLabel;


@end

@implementation EVHVLoginView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.closeButton.tag = EVLoginClickTypeClose;
    self.nextButton.tag = EVLoginClickTypeNext;
    self.userProtocol.tag = EVLoginClickTypeProtocol;
    self.weChatLogin.tag = EVLoginClickTypeWeChat;
    self.qqLogin.tag = EVLoginClickTypeQQ;
    self.weiBoLogin.tag = EVLoginClickTypeWeiBo;
    self.hidePwdButton.tag = EVLoginClickTypeHidePwd;
    self.passwordTextFiled.secureTextEntry = YES;
    [self.hidePwdButton setImage:[UIImage imageNamed:@"btn_visible_n"] forState:(UIControlStateSelected)];
//    [self.weChatLogin setImage:[UIImage imageNamed:@"btn_wechat_s"] forState:(UIControlStateSelected)];
//    [self.qqLogin setImage:[UIImage imageNamed:@"btn_qq_s"] forState:(UIControlStateSelected)];
//    [self.weiBoLogin setImage:[UIImage imageNamed:@"btn_weibo_s"] forState:(UIControlStateSelected)];
    //    /服务条款与协议
    TTTAttributedLabel *serviceagreement = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:serviceagreement];
    _attributedLabel = serviceagreement;
    [serviceagreement autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nextButton withOffset:10];
    [serviceagreement autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [serviceagreement autoSetDimension:ALDimensionHeight toSize:30];
    UIColor *textColor = [UIColor colorWithHexString:@"#ACACAC"];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"你还没有账号?点击注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:textColor}];
    serviceagreement.attributedText = attrStr;
    serviceagreement.font = [UIFont systemFontOfSize:16.f];
    serviceagreement.delegate = self;
    [serviceagreement setLinkAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor]}];
    [serviceagreement setActiveLinkAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [serviceagreement addLinkToAddress:@{@"key":@"1"} withRange:NSMakeRange(7, 4)];
    
    [self.closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.userProtocol addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weChatLogin addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqLogin addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiBoLogin addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidePwdButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

//服务条款跟 隐私协议的代理方法
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    //    [self gotoShowTermWithType:CCPrivacyPolicy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabelButton)])
    {
        if ([addressComponents[@"key"] isEqualToString:@"1"])
        {
            [self.delegate attributedLabelButton];
        }
        
    }
}


- (void)buttonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewButtonType:button:)]) {
        [self.delegate loginViewButtonType:btn.tag button:btn];
    }
    
    if (btn.tag == EVLoginClickTypeHidePwd) {
        if (btn.selected) {
            btn.selected = NO;
            self.passwordTextFiled.secureTextEntry = YES;
        }else {
            btn.selected = YES;
            self.passwordTextFiled.secureTextEntry = NO;
        }
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.PhoneTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.PhoneTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
    return YES;
}

@end
