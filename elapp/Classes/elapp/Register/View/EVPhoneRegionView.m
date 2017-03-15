//
//  EVPhoneRegionView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPhoneRegionView.h"
#import <PureLayout.h>


#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@interface EVPhoneRegionView()<TTTAttributedLabelDelegate>

@property (weak,  nonatomic)  UIView      *loginBackroungView;//整个登录的UIView
@property (weak,  nonatomic) UIImageView  *loginBackground;//背景图片
@property (weak,  nonatomic) UIButton     *areaschosen;    //地区选着
@property (weak,  nonatomic) UILabel      *serviceagreement;//服务条款与协议
@property (weak,  nonatomic) UIButton     *cancelBtn;       //取消按钮

@end

@implementation EVPhoneRegionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  setUI];
    }
    return self;
}

//设置UI
- (void)setUI
{
    //定制全局适配尺寸
    CGFloat buttonH = cc_absolute_x(60);
    CGFloat btnimageH = cc_absolute_x(160);
    self.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];

  
    UIView *bgCodeView = [[UIView alloc] init];
    bgCodeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgCodeView];
    [bgCodeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
    [bgCodeView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [bgCodeView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    _contryAndCodelabel = [[UILabel alloc] init];
    _contryAndCodelabel.text = [NSString stringWithFormat:@"%@  +86",kEChina];
    _contryAndCodelabel.textColor = [UIColor colorWithHexString:@"#262626"];
    _contryAndCodelabel.font = [UIFont systemFontOfSize:16.f];
    [bgCodeView addSubview:_contryAndCodelabel];
    [_contryAndCodelabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_contryAndCodelabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    UIButton *imageBtn = [[UIButton alloc] init];
    [imageBtn setImage:[UIImage imageNamed:@"home_icon_next"] forState:UIControlStateNormal];
    
    [bgCodeView addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(verificationbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.tag = CCRegionSelectRegionButton;
    imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, btnimageH, 0, 0);
    [imageBtn autoSetDimensionsToSize:CGSizeMake(cc_absolute_x(200.0f), buttonH)];
    [imageBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.f];
    [imageBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //手机输入框
    UITextField *phoneText = [[UITextField alloc] init];
    phoneText.placeholder = kLogin_phone;
    phoneText.textColor = [UIColor colorWithHexString:@"#262626"];
    [phoneText setValue:[UIColor colorWithHexString:@"#ACACAC"]forKeyPath:@"_placeholderLabel.textColor"];
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    phoneText.borderStyle = UITextBorderStyleNone;
    phoneText.clearsOnBeginEditing = NO;
    phoneText.backgroundColor = [UIColor whiteColor];
    phoneText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:phoneText];
    self.phoneText = phoneText;
    [phoneText autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [phoneText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bgCodeView withOffset:cc_absolute_x(1.0f)];
    [phoneText autoAlignAxis:ALAxisVertical toSameAxisOfView:bgCodeView];
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    phoneIcon.frame = CGRectMake(0, 0, 15, 60);
    phoneText.leftView = phoneIcon;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.frame = CGRectMake(0, 0, cc_absolute_x(39.0f), cc_absolute_y(25.0f));
    [closebtn setImage:[UIImage imageNamed:@"land_clean"] forState:UIControlStateNormal];
    phoneText.rightView = closebtn;
    phoneText.rightViewMode = UITextFieldViewModeWhileEditing;
    [closebtn addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *verificationView = [[UIView alloc]init];
    [self addSubview:verificationView];
    verificationView.backgroundColor = [UIColor whiteColor];
    [verificationView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneText withOffset:1];
    [verificationView autoAlignAxis:ALAxisVertical toSameAxisOfView:bgCodeView];
    [verificationView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    
    // 验证码输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.placeholder = kVerify_num;
    [textField setValue:[UIColor colorWithHexString:@"#ACACAC"]forKeyPath:@"_placeholderLabel.textColor"];
    textField.tintColor = [UIColor textBlackColor];
    [verificationView addSubview:textField];
    [textField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:verificationView withOffset:0];
    [textField autoSetDimensionsToSize:CGSizeMake(ScreenWidth-108, 60)];
    [textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:verificationView withOffset:15.0f];
    UIImageView *textIcon = [[UIImageView alloc] init];
    textIcon.frame = CGRectMake(0, 0, 15, 60);
    phoneText.leftView = textIcon;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.verifyInputField = textField;

    // 右侧获取计时按钮
    UIButton *verifyCodeBtn = [[UIButton alloc] init];
    [verificationView addSubview:verifyCodeBtn];
    [verifyCodeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:textField withOffset:-102.f];
    [verifyCodeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16.0f];
    [verifyCodeBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:textField];
    [verifyCodeBtn autoSetDimension:ALDimensionWidth toSize:85.0f];
    [verifyCodeBtn autoSetDimension:ALDimensionHeight toSize:25.0f];
    verifyCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#FF8DA8"];
    [verifyCodeBtn setTitle:kSend_verify_num forState:UIControlStateNormal];
    [verifyCodeBtn.titleLabel setFont:EVNormalFont(13.0f)];
    [verifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifyCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#FF8DA8"].CGColor;
    verifyCodeBtn.layer.borderWidth = 1.f;
    verifyCodeBtn.layer.cornerRadius = 3.0f;
    verifyCodeBtn.tag = CCInternationalCodeButton;
    [verifyCodeBtn addTarget:self action:@selector(verificationbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerificationCode = verifyCodeBtn;
    
    
    //手机输入框
    UITextField *passwordText = [[UITextField alloc] init];
    passwordText.placeholder = kSetting_password;
    passwordText.textColor = [UIColor colorWithHexString:@"#262626"];
    [passwordText setValue:[UIColor colorWithHexString:@"#ACACAC"]forKeyPath:@"_placeholderLabel.textColor"];
    passwordText.borderStyle = UITextBorderStyleNone;
    passwordText.clearsOnBeginEditing = NO;
    passwordText.backgroundColor = [UIColor whiteColor];
    passwordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:passwordText];
    passwordText.secureTextEntry = YES;
    self.passwordTextField = passwordText;
    [passwordText autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    [passwordText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:verificationView withOffset:cc_absolute_x(1.0f)];
    [passwordText autoAlignAxis:ALAxisVertical toSameAxisOfView:bgCodeView];
    passwordText.leftView = phoneIcon;
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    passwordText.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *closepasswordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passwordText.rightView = closepasswordbtn;
    closepasswordbtn.frame = CGRectMake(0, 0, cc_absolute_x(39.0f), cc_absolute_y(25.0f));
    [closepasswordbtn setImage:[UIImage imageNamed:@"land_clean"] forState:UIControlStateNormal];
    [closepasswordbtn addTarget:self action:@selector(deletepasswordText) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    confirmButton.tag = CCConfimButton;
    confirmButton.backgroundColor = [UIColor evMainColor];
    confirmButton.layer.cornerRadius = 3;
    confirmButton.clipsToBounds = YES;
    [confirmButton autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 40, 40)];
    [confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordText withOffset:20];
    [confirmButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [confirmButton addTarget:self action:@selector(verificationbuttonClicked:) forControlEvents:(UIControlEventTouchDown)];
    
    
    //服务条款与协议
    TTTAttributedLabel *serviceagreement = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:serviceagreement];
    _attributedLabel = serviceagreement;
    [serviceagreement autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:cc_absolute_x(50.0f)];
    [serviceagreement autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [serviceagreement autoSetDimension:ALDimensionHeight toSize:cc_absolute_y(20.0f)];
    UIColor *textColor = [UIColor colorWithHexString:@"#ACACAC"];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString: kRegist_agree_user_protocol attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:textColor}];
    serviceagreement.attributedText = attrStr;
    serviceagreement.delegate = self;
    [serviceagreement setLinkAttributes:@{NSForegroundColorAttributeName:textColor}];
    [serviceagreement setActiveLinkAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor]}];
    [serviceagreement addLinkToAddress:@{@"key":@"1"} withRange:NSMakeRange(8, 4)];
    
}

//服务条款跟 隐私协议的代理方法
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
//    [self gotoShowTermWithType:CCPrivacyPolicy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRegionView:clickButtonWithTag:)])
    {
        if ([addressComponents[@"key"] isEqualToString:@"1"])
        {
            [self.delegate phoneRegionView:self clickButtonWithTag:CCServiceButton];
        }
    }
}

//监听点击事件
- (void)verificationbuttonClicked:(UIButton *)button
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(phoneRegionView:clickButtonWithTag:)])
    {
        [self.delegate phoneRegionView:self clickButtonWithTag:button.tag];
    }
}


- (void)deletepasswordText
{
    self.passwordTextField.text = @"";
}

//取消文版输入框
- (void)deleteText
{
    self.phoneText.text = @"";
}

@end
