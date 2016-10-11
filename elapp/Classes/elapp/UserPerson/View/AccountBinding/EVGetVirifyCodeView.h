//
//  EVGetVirifyCodeView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVGetVirifyCodeView : UIView

@property (weak, nonatomic) UITextField *verifyInputField;  /**< 验证码输入框 */
@property (weak, nonatomic) UIButton *verifyBtn;  /**< 获取验证码 */

@property (copy, nonatomic) void(^getVerifyCode)();  /**< 获取验证码 */

@end
