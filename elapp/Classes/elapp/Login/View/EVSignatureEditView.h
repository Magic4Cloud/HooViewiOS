//
//  EVSignatureEditView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HideViewBlock)(NSString *inputTextStr);
typedef void(^ConfirmBlock)(NSString *inputTextStr);

@interface EVSignatureEditView : UIWindow

@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, copy) NSString *originText;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString * inputPlaceholder;
@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic,copy) HideViewBlock hideViewBlock;
//最大输入长度
@property (nonatomic, assign) int caninputlen;
@end
