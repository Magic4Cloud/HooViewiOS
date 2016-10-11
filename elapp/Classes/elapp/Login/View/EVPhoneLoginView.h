//
//  EVPhoneLoginView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EVPhoneLoginViewTag)
{
    EVPhoneLoginButton = 300,      // 登录按钮
    EVForgotPasswordButton,        // 忘记密码按钮
    EVSelectRegionButton           // 选择区号
} ;


@class EVPhoneLoginView;

@protocol EVPhoneLogDelegate <NSObject>

@optional

- (void)phoneLoginView:(EVPhoneLoginView *)loginView clickButtonWithTag:(EVPhoneLoginViewTag)tag phoneNum:(NSString *)phoneNumber password:(NSString *) password;

@end

@interface EVPhoneLoginView : UIView

@property (weak, nonatomic) id<EVPhoneLogDelegate> delegate;
@property (strong, nonatomic) UILabel      *contryAndCodelabel;
@property (strong, nonatomic) UITextField  *phoneText;

@end
