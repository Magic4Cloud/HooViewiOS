//
//  EVVideoFunctions.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVVideoFunctions.h"
#import "SDImageCache.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIWindow+Extension.h"

@implementation EVVideoFunctions

+ (UIImageView *)blurBackgroundImageView:(NSString *)imageUrl {
    UIImageView *blurBackgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blurBackgroundImgV.clipsToBounds = YES;
    [blurBackgroundImgV setBackgroundColor:[UIColor whiteColor]];
    blurBackgroundImgV.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *originalImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl];
    if ( !originalImg )
    {
        originalImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        if ( !originalImg )
        {
            if (!imageUrl)   // 推送过来
            {
                originalImg = [UIImage imageNamed:@"home_living_tuisong_bejing"];
            }
            else    // 有封面url但没有加载到封面
            {
                originalImg = [UIImage imageWithALogoWithSize:CGSizeMake(ScreenWidth, ScreenHeight) isLiving:NO];
            }
        }
    }
    
    [blurBackgroundImgV setImageToBlur:originalImg blurRadius:-40.0f completionBlock:nil];
    
    return blurBackgroundImgV;
}

+ (void)setTopLeftAndTopRightCorner:(UIView *)view {
    [self p_setCornerToView:view byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}

+ (void)setBottomLeftAndBottomRightCorner:(UIView *)view {
    [self p_setCornerToView:view byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
}

+ (void)p_setCornerToView:(UIView *)view byRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:corners
                                           cornerRadii:CGSizeMake(6.0, 6.0)];
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path  = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (void)handleReportAction {
    UIAlertController *alertController = [[UIAlertController alloc] init];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [EVProgressHUD showSuccess:@"举报成功"];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = [keyWindow visibleViewController];
    if (!rootVC) {
        rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    [rootVC presentViewController:alertController animated:YES completion:nil];
}

@end
