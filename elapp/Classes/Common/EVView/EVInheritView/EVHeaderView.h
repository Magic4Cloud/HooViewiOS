//
//  EVHeaderView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EVVipMini = 0,
    EVVipMiddle,
    EVVipMax,
} EVVipSizeType;


@interface EVHeaderImageView : UIImageView

/** 官方认证vip */
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, assign) BOOL border;
@property (nonatomic, assign) EVVipSizeType vipSizeType;    /**< 头像大小 */

/** 初始化头像类
 *  @param urlString 图片地址
 *  @param placeHolderImageName 占位图
 *  @param vip 是否是vip用户
 */
- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName isVip:(NSInteger)vip vipSizeType:(EVVipSizeType)type;

- (void)cc_setImageWithURLString:(NSString *)urlString isVip:(BOOL)vip vipSizeType:(EVVipSizeType)type;

@end

@interface EVHeaderButton : UIButton

@property (nonatomic, assign) EVVipSizeType vipSizeType;    /**< 头像大小 */
@property (nonatomic, assign, readwrite, setter=hasBorder:) BOOL border;    /**< 是否有border */

/** 初始化头像类
 *  @param urlString 图片地址
 *  @param placeHolderImageName 占位图名称
 *  @param vip 是否是vip用户
 */
- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImageStr:(NSString *)placeHolderImageName isVip:(NSInteger)vip vipSizeType:(EVVipSizeType)type;

/** 初始化头像类
 *  @param urlString 图片地址
 *  @param placeHolderImageName 占位图
 *  @param vip 是否是vip用户
 */
- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImageStr:(NSString *)placeHolderImageName isVip:(NSInteger)vip  vipSizeType:(EVVipSizeType)type complete:(void(^)(UIImage *image))complete;

/**
 *
 *  初始化头像类
 *
 *  @param urlString        头像地址
 *  @param placeHolderImage 占位图
 *  @param vip              是否是vip
 *  @param type             头像大小类型
 */
- (void)cc_setBackgroundImageURL:(NSString *)urlString placeholderImage:(UIImage *)placeHolderImage isVip:(BOOL)vip vipSizeType:(EVVipSizeType)type;

@end
