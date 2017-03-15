//
//  EVGetVirifyCodeView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGetVirifyCodeView.h"
#import <PureLayout.h>

@implementation EVGetVirifyCodeView

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addCustomSubviews];
    }
    
    return self;
}


#pragma mark - event response

- (void)getVerifyCodeButtonClick
{
    if ( self.getVerifyCode )
    {
        self.getVerifyCode();
    }
}


#pragma mark - private methods

- (void)addCustomSubviews
{
    // 左侧图片
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_pic_verification_shield"]];
    [self addSubview:icon];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
    [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [icon autoSetDimensionsToSize:CGSizeMake(24, 24)];
    
    // 验证码输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.placeholder = kE_GlobalZH(@"verify_num");
    textField.font = EVNormalFont(15.0f);
    textField.tintColor = [UIColor evTextColorH3];
    [self addSubview:textField];
    [textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:icon withOffset:16.0f];
    self.verifyInputField = textField;
    
    // 右侧获取计时按钮
    UIButton *verifyCodeBtn = [[UIButton alloc] init];
    [self addSubview:verifyCodeBtn];
    [verifyCodeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:textField withOffset:.0f];
    [verifyCodeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16.0f];
    [verifyCodeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [verifyCodeBtn autoSetDimension:ALDimensionWidth toSize:82.0f];
    [verifyCodeBtn autoSetDimension:ALDimensionHeight toSize:22.0f];
    [verifyCodeBtn setTitle:kE_GlobalZH(@"send_verify_num") forState:UIControlStateNormal];
    [verifyCodeBtn.titleLabel setFont:EVNormalFont(12.0f)];
    [verifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifyCodeBtn.layer.borderColor = [UIColor evAssistColor].CGColor;
    verifyCodeBtn.layer.borderWidth = .5f;
    verifyCodeBtn.layer.cornerRadius = 3.0f;
    verifyCodeBtn.backgroundColor = [UIColor evAssistColor];
    [verifyCodeBtn addTarget:self action:@selector(getVerifyCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.verifyBtn = verifyCodeBtn;
    
    // 顶部分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [self addSubview:topLine];
    [topLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [topLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
    // 底部分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [self addSubview:bottomLine];
    [bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeTop];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

@end
