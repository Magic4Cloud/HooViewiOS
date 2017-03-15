//
//  EVHVPhoneRegistView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHVPhoneRegistView.h"
#import <TTTAttributedLabel.h>


@interface EVHVPhoneRegistView ()<UITextFieldDelegate,TTTAttributedLabelDelegate>
@property (nonatomic, weak) TTTAttributedLabel *attributedLabel;
@end

@implementation EVHVPhoneRegistView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.phoneTextFiled becomeFirstResponder];
    [self.userProtocol setImage:[UIImage imageNamed:@"ic_Check_n"] forState:(UIControlStateSelected)];
    NSString * oneStr = @"  同意 用户协议";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",oneStr]];
    //修改某个范围内字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH1]  range:NSMakeRange(2,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evMainColor]  range:NSMakeRange(5,4)];
//    //在某个范围内增加下划线
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    [self.userProtocol setAttributedTitle:str forState:(UIControlStateNormal)];
    
    NSString *loginStr = @"您已注册，点击立即登录";
    NSMutableAttributedString *loginAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",loginStr]];
    //修改某个范围内字的颜色
    [loginAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH2]  range:NSMakeRange(0,5)];
    [loginAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor evMainColor]  range:NSMakeRange(5,6)];
    [self.loginButton setAttributedTitle:loginAttStr forState:(UIControlStateNormal)];
    self.phoneTextFiled.delegate = self;
    
    
    //    /服务条款与协议
    TTTAttributedLabel *serviceagreement = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:serviceagreement];
    _attributedLabel = serviceagreement;
    [serviceagreement autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userProtocol withOffset:10];
    [serviceagreement autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_userProtocol];
    [serviceagreement autoSetDimension:ALDimensionHeight toSize:22];
    [serviceagreement autoSetDimension:ALDimensionWidth toSize:100];
    UIColor *textColor = [UIColor colorWithHexString:@"#ACACAC"];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"同意 用户协议" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:textColor}];
    serviceagreement.attributedText = attrStr;
    serviceagreement.font = [UIFont systemFontOfSize:16.f];
    serviceagreement.delegate = self;
    [serviceagreement setLinkAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor]}];
    [serviceagreement setActiveLinkAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [serviceagreement addLinkToAddress:@{@"key":@"1"} withRange:NSMakeRange(3, 4)];
    
    


}


//服务条款跟 隐私协议的代理方法
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    //    [self gotoShowTermWithType:CCPrivacyPolicy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonUserProtocol)])
    {
        if ([addressComponents[@"key"] isEqualToString:@"1"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(buttonUserProtocol)]) {
                [self.delegate buttonUserProtocol];
            }
        }
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 只能输入数字、字母
    NSString *regex = @"[a-z0-9A-Z]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (range.length == 1){
        return YES;
    }else if (![pred evaluateWithObject:string] || textField.text.length >= 11) {
        
        return NO;
    }
    return YES;
}

- (IBAction)userProtrol:(UIButton *)sender {
    sender.selected = !sender.selected;
   
    
}

- (IBAction)nextButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextButton)]) {
        [self.delegate nextButton];
    }
}
- (IBAction)LoginBtn:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginBtn)]) {
        [self.delegate loginBtn];
    }
}

@end
