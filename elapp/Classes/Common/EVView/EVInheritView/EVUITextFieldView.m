//
//  EVUITextFieldView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVUITextFieldView.h"

@interface EVUITextFieldView ()<UITextFieldDelegate>

@property (weak,nonatomic) UIImageView *fieldIcon;/**<textfield 的图标>*/
@property (weak,nonatomic) UITextField *textField;/**<文本输入框>*/
@property (weak,nonatomic) UIButton    *deleteField;/**<删除编辑的文本>*/

@end
@implementation EVUITextFieldView

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetMaxX(self.bounds) - 40, (CGRectGetMinY(self.bounds) + CGRectGetMaxY(self.bounds))* 0.5 - 15, 30, 30);
}


/**
 * 01. 通过类方法创建一个实例
 * 02. 复写initWithFrame方法，添加控件，添加约束
 * 03. 复写setter方法
 * 04. 实现textfield的代理方法，并且给出外部的代理方法，完成相应的响应
 */
//
//+(instancetype)instanceWithFrame:(CGRect)frame
//{
//    CCUITextFieldView *textFiel = [[CCUITextFieldView alloc] initWithFrame:frame];
//    return textFiel;
//}



@end
