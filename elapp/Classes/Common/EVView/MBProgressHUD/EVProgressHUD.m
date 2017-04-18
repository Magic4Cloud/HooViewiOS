//
//  EVProgressHUD.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "MBProgressHUD.h"
#import "EVProgressHUD.h"
@implementation EVProgressHUD

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    // 再设置模式
    if (icon) {
        hud.mode = MBProgressHUDModeCustomView;
    }
    else {
        hud.mode = MBProgressHUDModeText;
    }
    hud.square = YES;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [self configStyleForHUD:hud];
    
    [hud hideAnimated:YES afterDelay:1.f];
}

+ (void)configStyleForHUD:(MBProgressHUD *)hud {
    hud.label.textColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = hud.label.textColor;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:nil view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"ic_hook" view:view];
}

#pragma mark 显示一些信息
+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self configStyleForHUD:hud];
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showLoadingMessage:(NSString *)message view:(UIView *)view
{
    [self showLoadingAnimationMessage:message toView:view];
}

+ (void)showLoadingAnimationMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    UIImage *image = [[UIImage imageNamed:@"ic_loading_1"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.customView.backgroundColor = [UIColor clearColor];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = message;
    [self configStyleForHUD:hud];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showMessage:(NSString *)message
{
    return [self showOnlyTextMessage:message forView:nil];
}

+ (void)showIndeterminateForView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
}

+ (void)hideHUDForView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)showMessageInAFlashWithMessage:(NSString *)message {
    [self show:message icon:nil view:nil];
}

+ (void)showProgressMumWithClearColorToView:(UIView *)view {
    [EVProgressHUD showProgressMumWithClearColorToView:view message:nil];
}

+ (void)showProgressMumWithClearColorToView:(UIView *)view
                                    message:(NSString *)message
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    hud.contentColor = [UIColor evMainColor];
    [self configStyleForHUD:hud];
}

+ (void)showOnlyTextMessage:(NSString *)message forView:(UIView *)forView
{
    if (forView == nil) forView = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:forView animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
//    hud.label.lineBreakMode = NSLineBreakByWordWrapping;
    // Move to bottm center.
//    hud.label.textColor = [UIColor whiteColor];
//    hud.offset = CGPointMake(0.f, 0);
//    hud.customView.backgroundColor = [UIColor clearColor];
    [self configStyleForHUD:hud];
    [hud hideAnimated:YES afterDelay:0.5];
}

+ (void)showDetailsMessage:(NSString *)message forView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    [self configStyleForHUD:hud];
    [hud hideAnimated:YES afterDelay:1.5];
}

@end
