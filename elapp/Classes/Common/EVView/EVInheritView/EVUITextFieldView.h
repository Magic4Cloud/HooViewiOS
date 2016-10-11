//
//  EVUITextFieldView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCUITextFieldDelegate<NSObject>

@optional
//删除输入的文本
- (void)deleteTextField;

@end

@interface EVUITextFieldView : UITextField


/**
 *  使用类方法进行实例化
 *
 *  @param frame frame
 *
 *  @return 实例
 */

//
//+ (instancetype)instanceWithFrame:(CGRect)frame;
//
//@property (copy, nonatomic, nonnull) NSString *placeHolder;  /**< 占位文字 */
//@property (strong, nonatomic, nonnull) UIColor *placeHolderColor; /**< 占位文字的颜色 */
//@property (strong,nonatomic,nonnull) UIImageView *fieldImage;/**<输入框的图片>*/
//@property (copy, nonatomic, nonnull) NSString *text;  /**< 输入框的文字 */
//@property (strong, nonatomic, nonnull) UIColor *textColor; /**< 文字颜色 */
//@property (strong, nonatomic, nonnull) UIFont *font; /**< 字体 */
//
@end
