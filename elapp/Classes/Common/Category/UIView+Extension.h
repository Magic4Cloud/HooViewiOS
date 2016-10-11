//
//  UIView+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

@interface UIView (Extension)

//-(void)setFontFamily:(NSString*)fontFamily affectSubviews:(BOOL)affectSubviews;

/**
 *  设置UILabel、UIButton、UINavigationBar的字体，以及子视图的字体
 *
 *  @param affectSubviews 该视图的子视图的字体是否和该视图的字体相同，YES表示相同，No表示不同
 */
- (void)setNormalFontAffectSubviews:(BOOL)affectSubviews;

//- (void)backGroundColor_addAppAppearanceNotification;
//- (void)removeAppAppearanceNotification;

/**
 *  获得一个圆形视图
 */
- (void)setRoundCorner;

/**
 *  弹性放大动画显示动画
 */
- (void)scaleBoundceAnimationShowComplete:(void(^)())complete;

// 立即执行complete
- (void)scaleBoundceAnimationShowImmediatelyComplete:(void (^)())complete;

/**
 *  弹性缩小动画
 */
- (void)scaleBoundceAnimationHiddenComplete:(void(^)())complete;;

/**
 *  弹性放大动画
 *
 *  @param start   开始的缩放比例
 *  @param transit 过渡的缩放比例
 *  @param end     结束的缩放比例
 */
- (void)scaleBoundceAnimationStart:(CGFloat)start transit:(CGFloat)transit end:(CGFloat)end;

@end
