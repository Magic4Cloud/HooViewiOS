//
//  EVProgressHUD.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EVProgressHUD : NSObject

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (void)showMessage:(NSString *)message;
+ (void)showIndeterminateForView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;

+ (void)showLoadingMessage:(NSString *)message view:(UIView *)view;
+ (void)hideHUD;

// 闪现显示提示信息
+ (void)showMessageInAFlashWithMessage:(NSString *)message;

// 透明的加载提示菊花视图
+ (void)showProgressMumWithClearColorToView:(UIView *)view;

/**
 *  透明的加载提示菊花视图(带有文字)
 *
 *  @param view    父视图
 *  @param message 提示文字
 */
+ (void)showProgressMumWithClearColorToView:(UIView *)view
                                    message:(NSString *)message;


+ (void)showOnlyTextMessage:(NSString *)message forView:(UIView *)forView;

+ (void)showDetailsMessage:(NSString *)message forView:(UIView *)view;

@end
