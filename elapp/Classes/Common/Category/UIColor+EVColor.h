//
//  UIColor+EVColor.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor (EVColor)

//------------------------------------------------
//------------------- 视图颜色 --------------------
//------------------------------------------------
+ (UIColor *)evMainColor;       /**< 主色调-紫色:#9ac9ff */
+ (UIColor *)mainColorAlpha:(CGFloat)alpha;
+ (UIColor *)evSecondColor;     /**< 主色配色-绿色:#00bf8b */
+ (UIColor *)evAssistColor;     /**< 辅色-红色:#ff5756 */
+ (UIColor *)evBackgroundColor; /**< 底色-近白色:#f8f8f8 */
+ (UIColor *)evLineColor;       /**< 线色-分割线颜色:#efefef */
+ (UIColor *)evRemindColor;     /**< 提示色-深粉色:#ff5756 */
+ (UIColor *)evPurpleColor;     /**< 辅助颜色-淡紫色:#a65f5f */
+ (UIColor *)evTipColor;        /**< 提示颜色-淡紫色:#5C2D7E */
+ (UIColor *)evDDDColor;


/**
 深灰色  153  153  153
 */
+ (UIColor *)evBackGroundDeepGrayColor;
/**
 背景浅灰颜色 248 248 248
 */
+ (UIColor *)evBackGroundLightGrayColor;


/**
 红色   rgb 254 79 80

 @return
 */
+ (UIColor *)evRedColor;
/**
 背景深蓝色  101 154 224
 */
+ (UIColor *)evBackGroundDeepBlueColor;


/**
 背景深红色  227 96 96
 */
+ (UIColor *)evBackGroundDeepRedColor;
//------------------------------------------------
//------------------- 字体颜色 --------------------
//------------------------------------------------

+ (UIColor *)evTextColorH1;     /**< 一级黑色颜色:#303030 */
+ (UIColor *)evTextColorH2;     /**< 二级灰色字体:#999999 */
+ (UIColor *)evTextColorH3;     /**< 三级红色字体:#ff4342 */
+ (UIColor *)evGlobalSeparatorColor;// 线的颜色/
+ (UIColor *)evNaviBarBgColor;   //状态头的颜色

+ (UIColor *)evlightGrayTextColor;

+ (UIColor *)textBlackColor;


+ (UIColor *)liveBackColor; /**< 直播颜色 248 122 43 */

+ (UIColor *)hvPurpleColor; /**< 紫色颜色 103 47 135  #672f87*/


+ (UIColor *)evOrangeColor; /**< 橘黄色 255 104 32  #FF6820*/

/**
 橘黄色背景颜色
 */
+ (UIColor *)evOrangeBgColor;

+ (UIColor *)evEcoinColor; /**< 橘黄色 255 126 40  #FF7E28*/
@end
