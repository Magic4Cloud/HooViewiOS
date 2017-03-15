//
//  EVHVVerifyCodeView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVHVVerifyCodeViewDelegate <NSObject>

- (void)nextButton;
- (void)timeButton:(UIButton *)btn;

@end
@interface EVHVVerifyCodeView : UIView
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) id<EVHVVerifyCodeViewDelegate> delegate;

@end
