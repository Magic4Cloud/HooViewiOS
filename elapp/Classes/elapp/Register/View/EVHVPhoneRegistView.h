//
//  EVHVPhoneRegistView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EVHVPhoneRegistViewDelegate <NSObject>

- (void)buttonUserProtocol;
- (void)nextButton;

- (void)loginBtn;


@end

@interface EVHVPhoneRegistView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *userProtocol;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) id<EVHVPhoneRegistViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
