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

@property (nonatomic, copy) NSString *originText;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic,copy) HideViewBlock hideViewBlock;

@end
