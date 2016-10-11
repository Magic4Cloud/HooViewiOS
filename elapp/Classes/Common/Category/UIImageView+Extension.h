//
//  UIImageView+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

// 头像加载
- (void)cc_setUserIconWithDefaultPlaceHoderURLString:(NSString *)urlString;

// 视频封面加载
- (void)cc_setVideoThumbWithDefaultPlaceHoderURLString:(NSString *)urlString;

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName;

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placehloder;


- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placehloder complete:(void(^)(UIImage *image))complete;

/**
 *  把图片做成圆形的
 */
// 以下方法慎用
//- (void)cc_setImageWithDefaultPlaceHoderURLString:(NSString *)urlString;
- (void)cc_setRoundImageWithURL:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName;
- (void)cc_setRoundImageWithDefaultPlaceHoderURLString:(NSString *)urlString;
- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName complete:(void(^)(UIImage *image))complete;
- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName completeBlock:(void(^)(UIImage *image))complete;


@end
