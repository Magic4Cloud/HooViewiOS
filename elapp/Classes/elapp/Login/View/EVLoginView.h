//
//  EVLoginView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EVLoginButton = 1000,          // 登录按钮
    EVRegistButton,                // 注册按钮
    EVWeibobtn,                    // 微博按钮
    EVWeixinbtn,                   // 微信按钮
    EVQQbtn,                       // QQ按钮
} EVLoginViewButtonTag;

@class EVLoginView;
@class EVLoginInfo;

@protocol CCLogWindowDelegate <NSObject>

@optional
- (void)loginView:(EVLoginView *)loginView clickButtonWithTag:(EVLoginViewButtonTag)tag;

- (void)attributedLabelButton;

@end

@interface EVLoginView : UIView

@property ( weak, nonatomic ) id<CCLogWindowDelegate> delegate;

@property (nonatomic, strong) EVLoginInfo  *loginfo;

@end
