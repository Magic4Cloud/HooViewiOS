//
//  EVPasswordView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^nextClick)(UIButton *btn);

@interface EVPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *hidePwdButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (copy, nonatomic) nextClick nextClick;

@end
