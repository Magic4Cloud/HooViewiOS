//
//  UIViewController+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "EVWatchVideoInfo.h"
#import "EVAlertManager.h"
#import "EVLiveViewController.h"
#import "EVSettingLivingPWDView.h"
#import "EVPayVideoViewController.h"
#import "EVYunBiViewController.h"
#import "EVUserAsset.h"
// 付费直播 是否支付过
#define kPaymentKey             @"payment"

@interface UIViewController ()

@end

@implementation UIViewController (Extension)

#pragma mark - public instance methods

- (void)playVideoWithVideoInfo:(EVWatchVideoInfo *)videoInfo permission:(EVLivePermission)permission

{
    if ( (videoInfo.vid == nil || [videoInfo.vid isEqualToString:@""]) && (videoInfo.name == nil || [videoInfo.name isEqualToString:@""]))
    {
        return;
    }

    if ( permission == EVLivePermissionPassWord )
    {
        if ( videoInfo.password && ![videoInfo.password isEqualToString:@""] )
        {
            [self playWithVideoInfo:videoInfo];
            return;
        }
        // 显示密码输入页面
        [self showPasswordInputPageWithVideoInfo:videoInfo];
    }
    else if (permission == EVLivePermissionPay)
    {
        [self showVideoPayViewWithVid:videoInfo.vid videoInfo:videoInfo complete:nil];
    }
    else
    {
        [self playWithVideoInfo:videoInfo];
    }
}

- (void)playWithVideoInfo:(EVWatchVideoInfo *)videoInfo
{

}

- (void)showPasswordInputPageWithVideoInfo:(EVWatchVideoInfo *)videoInfo
{
    // 创建直播密码页
    __weak typeof(self) weakself = self;
    __block EVWatchVideoInfo *videoInfoTemp = videoInfo;
    
    [EVSettingLivingPWDView showAndCatchResultWithSuperView:self.view.window offsetY:.0f complete:^(NSString * _Nullable password) {
        if ( password.length > 0 )
        {
            videoInfoTemp.password = [password mutableCopy];
            
            [weakself playWithVideoInfo:videoInfoTemp];
        }
    }];
}


- (void)showVideoPayViewWithVid:(NSString *)vid videoInfo:(EVWatchVideoInfo *)videoInfo complete:(void(^)(BOOL paySuccess))completeBlock {
    WEAK(self);
    [EVPayVideoViewController fetchDataWithVid:vid complete:^(NSDictionary *retinfo, NSError *error) {
        if (error || retinfo == nil) {
            return ;
        }
        // 已经支付过了
        if (retinfo[@"price"]  == nil || [retinfo[@"price"] integerValue] <= 0) {
            [weakself playWithVideoInfo:videoInfo];
            return;
        }
        
        UINavigationController *navController = weakself.navigationController;
        // 当前 navigation 堆栈中最顶层的 VC
        UIViewController *currentVC;
        if ([self p_currentViewController:navController]) {
            currentVC = [self p_currentViewController:navController];
        } else {
            if (self) {
                currentVC = self;
            } else {
                currentVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            }
        }
        
        EVPayVideoViewController *payVC = [EVPayVideoViewController new];
        payVC.vid               = vid;
        payVC.payInfoDictionary = retinfo;
        UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:payVC];
        [currentVC presentViewController:payNav animated:YES completion:nil];
        
        // 处理支付页的回调
        WEAK(payVC);
        [payVC setPayCallBack:^(BOOL isPay, BOOL isRecharge, NSString *ecion) {
            if (isRecharge) {
                [self p_goToRechargeWithEcion:ecion updateEcion:^(NSString *ecion) {
                    [weakpayVC updateEcion:ecion];
                } navController:payNav];
                return ;
            }
            
            if (videoInfo) {
                if (isPay) {
                    [weakself playWithVideoInfo:videoInfo];
                } else {
                }
            } else {
                if (isPay) {
                    [self p_popToCurrentViewController:navController];
                    if (completeBlock) {
                        completeBlock(YES);
                    }
                } else {
                    [self p_popToFromViewController:navController];
                }
            }
        }];
    }];
}

- (BOOL)popToCurrentViewController {
    return [self p_popToCurrentViewController:self.navigationController];
}


- (void)p_popToFromViewController:(UINavigationController *)navController {
    NSMutableArray *viewControllerStack = [NSMutableArray arrayWithArray:navController.viewControllers];
    if (!navController || viewControllerStack.count <= 1) {
        return;
    }
    for (NSInteger i = 0; i < viewControllerStack.count; i++) {
        UIViewController *vc = viewControllerStack[i];
        if (vc == self && i > 0) {
            UIViewController *fatherVC = viewControllerStack[i - 1];
            [navController popToViewController:fatherVC animated:NO];
            break;
        }
    }
}

- (BOOL)p_popToCurrentViewController:(UINavigationController *)navController {
    BOOL popSuccess = NO;
    if ([navController.viewControllers lastObject] == self || navController.viewControllers.count < 1) {
        return popSuccess;
    }
    if ([[navController viewControllers] containsObject:self]) {
        [navController popToViewController:self animated:NO];
        popSuccess = YES;
    }
    
    return popSuccess;
}

- (void)p_goToRechargeWithEcion:(NSString *)ecion updateEcion:(void(^)(NSString *ecion))updateEcionBlock {
    [self p_goToRechargeWithEcion:ecion updateEcion:updateEcionBlock navController:self.navigationController];
}

- (void)p_goToRechargeWithEcion:(NSString *)ecion updateEcion:(void(^)(NSString *ecion))updateEcionBlock navController:(UINavigationController *)navController {
    EVYunBiViewController *yibiVC = [[EVYunBiViewController alloc] init];
    EVUserAsset *asset = [[EVUserAsset alloc] init];
    asset.ecoin  = [ecion integerValue];
    yibiVC.asset = asset;
    [yibiVC setUpdateEcionBlock:^(NSString *ecion) {
        if (updateEcionBlock) {
            updateEcionBlock(ecion);
        }
    }];
    if (navController) {
        yibiVC.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:yibiVC animated:YES];
    } else {
        yibiVC.isPresented = YES;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:yibiVC] animated:YES completion:nil];
    }
}



- (UIViewController *)p_currentViewController:(UINavigationController *)navController {
    UIViewController *lastVC = [navController.viewControllers lastObject];
    if (navController.viewControllers.count == 0) {
        return nil;
    }
    if (!lastVC) {
        return nil;
    }
    
    return lastVC;
}
- (void)checkLiveNeedToContinueStart:(void(^)())normalStart
                      continueLiving:(void(^)())continueLiving
{
    
    
        if ( normalStart )
        {
            normalStart();
        }
}

- (void)requestForecastLivingWithForecastItem:(CCForeShowItem *)item
                                     delegate:(id)delegate
{
//    EVLiveViewController *liveVC = [EVLiveViewController liveViewControllerWith:item];
//    liveVC.delegate = delegate;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:liveVC];
//    [self presentViewController:nav animated:YES completion:nil];
}


- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
                                audioOnly:(BOOL)audioOnly
                                 delegate:(id)delegate
{
    NSString *firstLiveFlagKey = @"guaranteSafeLive";
    BOOL isFirstLive = [[CCUserDefault objectForKey:firstLiveFlagKey] boolValue];
    if ( isFirstLive == NO )
    {
        [[EVAlertManager shareInstance] configAlertViewWithTitle:kTooltip message:kE_GlobalZH(@"illegal_living") cancelTitle:kE_GlobalZH(@"i_konw") WithCancelBlock:^(UIAlertView *alertView) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [self realRequestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:audioOnly delegate:delegate];
            [CCUserDefault setObject:[NSNumber numberWithBool:YES] forKey:firstLiveFlagKey];
        }];
    }
    else
    {
        [self realRequestNormalLivingPageForceImage:forceImage allowList:allowList audioOnly:audioOnly delegate:delegate];
    }
}

- (void)realRequestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
                                audioOnly:(BOOL)audioOnly
                                 delegate:(id)delegate
{
    EVLiveViewController *liveVC = [[EVLiveViewController alloc] init];
    liveVC.foreCapture = forceImage;
    liveVC.delegate = delegate;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)requestActivityLivingWithActivityInfo:(NSDictionary *)params
                                     delegate:(id)delegate
{
    EVLiveViewController *liveVC = [EVLiveViewController liveViewControllerWithActivityInfo:params];
    liveVC.delegate = delegate;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIButton *)addBackToTopButtonToSuperView:(UIView *)superView
                        OffsetYToBottom:(CGFloat)offsetY_Bottom
                                             action:(SEL)action
{
    CGFloat backToTopButtonHeight = 40.0f;
    UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
    top.frame = CGRectMake(ScreenWidth - 15.0f - backToTopButtonHeight, superView.bounds.size.height - offsetY_Bottom - backToTopButtonHeight - 15.0f, backToTopButtonHeight, backToTopButtonHeight);
    [top setImage:[UIImage imageNamed:@"personal_top"] forState:UIControlStateNormal];
    [top addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:top];
    top.hidden = YES;
    
    return top;
}

#pragma mark - private methods
@end
