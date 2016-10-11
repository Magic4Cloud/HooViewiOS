//
//  EVAlertManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCAlertView;

@interface EVAlertManager : NSObject

/**
 *  初始化
 *
 *  @return 单例的alertView
 */
+ (instancetype)shareInstance;

/**
 *  使用取消、确定按钮初始化alertView
 *
 *  @param title        按钮
 *  @param message      具体内容
 *  @param cancelTitle  取消按钮
 *  @param comfirmTitle 确定按钮
 *  @param comfirmBlock 确定回调
 *  @param cancelBlock  取消回调
 *
 */
- (UIAlertView *)performComfirmTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelTitle
                        comfirmTitle:(NSString *)comfirmTitle
                         WithComfirm:(void(^)())comfirmBlock
                              cancel:(void(^)())cancelBlock;

- (UIAlertView *)performComfirmTitle:(NSString *)title
                             message:(NSString *)message
                        comfirmTitle:(NSString *)comfirmTitle
                         WithComfirm:(void(^)())comfirmBlock;


- (void)configAlertViewWithTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                 WithCancelBlock:(void(^)(UIAlertView *alertView))Cancelblock;


//- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle WithComfirm:(void(^)())comfirmBlock;

- (UIAlertView *)performEditComfirmTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelTitle
                            comfirmTitle:(NSString *)comfirmTitle
                             WithComfirm:(void(^)(NSString *editMessage))comfirmBlock
                                  cancel:(void(^)())cancelBlock;

- (UIAlertView *)performEditComfirmTitle:(NSString *)title
                            keyboardType:(UIKeyboardType)type
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelTitle
                            comfirmTitle:(NSString *)comfirmTitle
                             WithComfirm:(void(^)(NSString *editMessage))comfirmBlock
                                  cancel:(void(^)())cancelBlock;

@end
