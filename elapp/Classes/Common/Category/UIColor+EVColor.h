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
+ (UIColor *)evMainColor;       /**< 主色调-淡蓝色:#9ac9ff */
+ (UIColor *)evSecondColor;     /**< 主色配色-深蓝色:#314075 */
+ (UIColor *)evAssistColor;     /**< 辅色-淡粉色:#ff8da8 */
+ (UIColor *)evBackgroundColor; /**< 底色-近白色:#f4f4f4 */
+ (UIColor *)evLineColor;       /**< 线色-分割线颜色:#efefef */
+ (UIColor *)evRemindColor;     /**< 提示色-深粉色:#ff4a75 */
+ (UIColor *)evPurpleColor;     /**< 辅助颜色-淡紫色:#af86ff */

//------------------------------------------------
//------------------- 字体颜色 --------------------
//------------------------------------------------

+ (UIColor *)evTextColorH1;     /**< 一级字体颜色:#262626 */
+ (UIColor *)evTextColorH2;     /**< 二级字体颜色:#858585 */
+ (UIColor *)evTextColorH3;     /**< 三级字体颜色:#acacac */


@end
