//
//  EVPhoneRegionView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

typedef NS_ENUM(NSInteger, CCPhoneVerificationCodeBtnTag)
{
    CCInternationalCodeButton = 1000,      // 获取验证码
    CCCancelbutton,                        // 取消按钮
    CCRegionSelectRegionButton,            // 选择区号
    CCServiceButton,                       // 服务条款
    CCPrivateButton,                        // 隐私协议
    CCConfimButton                          //确定按钮
} ;

@class EVPhoneRegionView;

@protocol CCPhoneRegionViewDelegate <NSObject>

@optional
- (void)phoneRegionView:(EVPhoneRegionView *)RegionView clickButtonWithTag:(CCPhoneVerificationCodeBtnTag)tag;
@end

@interface EVPhoneRegionView : UIView

@property (strong,  nonatomic) UITextField  *phoneText;      //手机号码输入
@property (strong,  nonatomic) UILabel  *contryAndCodelabel;
@property (weak, nonatomic) id<CCPhoneRegionViewDelegate> delegate;
@property (strong,  nonatomic) UIButton *getVerificationCode;

@property (strong, nonatomic) TTTAttributedLabel *attributedLabel;


@property (weak, nonatomic) UITextField *passwordTextField;

@property (weak, nonatomic) UIButton *confirmButton;//确定

@property (weak, nonatomic) UITextField  *verifyInputField;//验证码

@end
