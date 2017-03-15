//
//  EVHVLoginView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef NS_ENUM(NSUInteger, EVLoginClickType) {
    EVLoginClickTypeClose,
    EVLoginClickTypeProtocol,
    EVLoginClickTypeNext,
    EVLoginClickTypeWeChat,
    EVLoginClickTypeQQ,
    EVLoginClickTypeWeiBo,
    EVLoginClickTypeHidePwd,
};



@protocol EVHVLoginViewDelegate <NSObject>

- (void)loginViewButtonType:(EVLoginClickType)type button:(UIButton *)button;

- (void)attributedLabelButton;

@end

@interface EVHVLoginView : UIView

@property (nonatomic, weak) id <EVHVLoginViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextField *PhoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *userProtocol;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatLogin;
@property (weak, nonatomic) IBOutlet UIButton *qqLogin;
@property (weak, nonatomic) IBOutlet UIButton *weiBoLogin;
@property (weak, nonatomic) IBOutlet UIButton *hidePwdButton;


@end
