//
//  EVPhoneLoginView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPhoneLoginView.h"
#import "PureLayout.h"

#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@interface EVPhoneLoginView()<EVPhoneLogDelegate>

@property (weak,  nonatomic) UIView       *loginBackroungView;//整个登录的UIView
@property (weak,  nonatomic) UIImageView  *loginBackground;//背景图片
@property (weak,  nonatomic) UILabel      *loginTitle;     //login的标题
@property (weak,  nonatomic) UIImageView  *phoneIcon;       //手机图标
@property (weak,  nonatomic) UIImageView  *passwordIcon;    //密码图标
@property (weak,  nonatomic) UITextField  *passwordText;    //密码输入框
@property (weak,  nonatomic) UIButton     *confirmBtn;      //确认按钮
@property (weak,  nonatomic) UIButton     *forgotPassword;  //忘记密码
@property (weak,  nonatomic) UIView       *line ;           // 线
@property (weak,  nonatomic) UIButton     *cancelBtn;       //取消按钮
@property (weak,  nonatomic) UIView       *backgroundPhoneView; //背景颜色的View 用来装着uitext的
@property (weak,  nonatomic) UIView       *backgroundPasswordView;//密码的背景颜色
@property (weak,  nonatomic) UIButton     *internationalCode; //国际区号选择
@property (weak,  nonatomic) UILabel      *internationallabel;//国际区域默认

@end

@implementation EVPhoneLoginView

- (void)dealloc
{
    EVLog(@"phonelogin dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];

    //背景View
    UIView *bgCodeView = [[UIView alloc] init];
    [self addSubview:bgCodeView];
    [bgCodeView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [bgCodeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
    [bgCodeView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    bgCodeView.backgroundColor = [UIColor whiteColor];
    _contryAndCodelabel = [[UILabel alloc] init];
    _contryAndCodelabel.text = [NSString stringWithFormat:@"%@  +86",kEChina];
    _contryAndCodelabel.textColor = [UIColor  colorWithHexString:@"#262626"];
    _contryAndCodelabel.font = [UIFont systemFontOfSize:15.f];
    _contryAndCodelabel.textAlignment = NSTextAlignmentLeft;
    _contryAndCodelabel.backgroundColor = [UIColor clearColor];
    [bgCodeView addSubview:_contryAndCodelabel];
    [_contryAndCodelabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_contryAndCodelabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    UIButton *imageBtn = [[UIButton alloc] init];
    [imageBtn setImage:[UIImage imageNamed:@"home_icon_next"] forState:UIControlStateNormal];
    [bgCodeView addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(phoneLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.tag = EVSelectRegionButton;
    [imageBtn autoSetDimensionsToSize:CGSizeMake(14, 26)];
    [imageBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.f];
    [imageBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //手机输入框
    UITextField *phoneText = [[UITextField alloc] init];
    phoneText.placeholder = kE_GlobalZH(@"login_phone");
    phoneText.textColor = [UIColor colorWithHexString:@"#262626"];
    [phoneText setValue:[UIColor colorWithHexString:@"#ACACAC"]forKeyPath:@"_placeholderLabel.textColor"];
    phoneText.clearsOnBeginEditing = NO;
    phoneText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:phoneText];
    phoneText.backgroundColor = [UIColor whiteColor];
    self.phoneText = phoneText;
    [phoneText autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [phoneText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bgCodeView withOffset:1.0f];
    [phoneText autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [phoneText autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    phoneIcon.frame = CGRectMake(0, 0, 20, 60);
    phoneText.leftView = phoneIcon;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.frame = CGRectMake(0, 0, 39,25);
    [closebtn setImage:[UIImage imageNamed:@"land_clean"] forState:UIControlStateNormal];
    phoneText.rightView = closebtn;
    phoneText.rightViewMode = UITextFieldViewModeWhileEditing;
    [closebtn addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];

    
    //密码输入框
    UITextField *passwordText = [[UITextField alloc] init];
    passwordText.placeholder = kE_GlobalZH(@"e_password");
//    passwordText.tintColor = [UIColor redColor];
    passwordText.backgroundColor = [UIColor whiteColor];
    [passwordText setValue:[UIColor colorWithHexString:@"#ACACAC"]forKeyPath:@"_placeholderLabel.textColor"];
    passwordText.secureTextEntry = YES;
    passwordText.textColor = [UIColor colorWithHexString:@"#262626"];
    passwordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:passwordText];
    self.passwordText = passwordText;
    [passwordText autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [passwordText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneText withOffset:1];
    [passwordText autoAlignAxis:ALAxisVertical toSameAxisOfView:phoneText];
    [passwordText autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    
    UIImageView *passwordIcon = [[UIImageView alloc] init];
    passwordIcon.frame = CGRectMake(0, 0, 20, 60);
    passwordText.leftView = passwordIcon;
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    UIButton *passwordclose = [UIButton buttonWithType:UIButtonTypeCustom];
    passwordclose.frame = CGRectMake(0, 0, cc_absolute_x(39.0f), cc_absolute_y(25.0f));
    [passwordclose setImage:[UIImage imageNamed:@"land_clean"] forState:UIControlStateNormal];
    passwordText.rightView = passwordclose;
    passwordText.rightViewMode = UITextFieldViewModeWhileEditing;
    [passwordclose addTarget:self action:@selector(deleteText1) forControlEvents:UIControlEventTouchUpInside];

    //登录按钮
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle: kE_GlobalZH(@"e_login") forState: UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(phoneLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
//fix by 王伟
    confirmBtn.tag = EVPhoneLoginButton;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    [confirmBtn autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 40, 40)];
    [confirmBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:passwordText];
    [confirmBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordText withOffset:30];
    self.confirmBtn.layer.cornerRadius = 6;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.borderColor = [UIColor evMainColor].CGColor;
    self.confirmBtn.backgroundColor = [UIColor evMainColor];
    
    //忘记密码
    UIButton *forgotPassword = [[UIButton alloc] init];
    [forgotPassword setTitle:kE_GlobalZH(@"forget_password") forState:UIControlStateNormal];
    forgotPassword.backgroundColor = [UIColor clearColor];
    forgotPassword.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [forgotPassword setTitleColor:[UIColor colorWithHexString:@"#ACACAC"] forState:(UIControlStateNormal)];
    [forgotPassword addTarget:self action:@selector(phoneLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
// fix by 王伟
    forgotPassword.tag = EVForgotPasswordButton;
    [self addSubview:forgotPassword];
    [forgotPassword autoSetDimensionsToSize:CGSizeMake(cc_absolute_x(150.0f), cc_absolute_y(15.0f))];
    [forgotPassword autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:confirmBtn withOffset:cc_absolute_size_y(20.f, 736.f)];
    [forgotPassword autoAlignAxis:ALAxisVertical toSameAxisOfView:confirmBtn];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    [line autoSetDimensionsToSize:CGSizeMake(cc_absolute_x(53.f), cc_absolute_y(0.5f))];
    [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:forgotPassword withOffset:cc_absolute_x(2.0f)];
    [line autoAlignAxis:ALAxisVertical toSameAxisOfView:forgotPassword];

}

- (void)phoneLoginClicked:(UIButton *)buttn
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(phoneLoginView:clickButtonWithTag:phoneNum:password:)] )
    {
        [self.delegate phoneLoginView:self clickButtonWithTag:buttn.tag phoneNum:self.phoneText.text password:self.passwordText.text];
    }
}

#pragma marck - 点击取消文本框内容
- (void)deleteText
{
    self.phoneText.text = @"";
}

-(void)deleteText1
{
    self.passwordText.text = @"";
}
@end
