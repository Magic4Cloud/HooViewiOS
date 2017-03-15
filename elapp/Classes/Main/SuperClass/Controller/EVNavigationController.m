//
//  EVNavigationController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNavigationController.h"

#define kNavigationBarTitleFont [[EVAppSetting shareInstance] systemBoldFontWithSize:16.f]

#define NavigationBackImage @"nav_icon_return"

@interface EVNavigationController ()

@end

@implementation EVNavigationController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - public class or instance methods

+ (instancetype)navigationWithWrapController:(UIViewController *)controller
{
    return [[EVNavigationController alloc] initWithRootViewController:controller];
}


#pragma mark - life circle

+ (void)initialize
{
    // 设置导航条的样式，管理了 app 内导航条的初始样式，特别对于相册、umeng 使用 app 默认导航条样式的更为需要
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.tintColor = [UIColor textBlackColor];
    naviBar.barTintColor = [UIColor evNaviBarBgColor];
    naviBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor evTextColorH2],
                                               NSFontAttributeName : kNavigationBarTitleFont};
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, kGlobalSeparatorHeight)];
    shadow.backgroundColor = [UIColor whiteColor];
    [naviBar setShadowImage:[UIImage gp_imageWithView:shadow]];
    
    // 设置导航条的背景图片，高占 64 个像素点，被导航控制器包装的 controller 的 view 从 64 开始计算
    UIView *backgroud = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, ScreenWidth, 64.0f)];
    backgroud.backgroundColor = [UIColor whiteColor];
    [naviBar setBackgroundImage:[UIImage gp_imageWithView:backgroud]
               forBarMetrics:UIBarMetricsDefault];
    
}

@end
