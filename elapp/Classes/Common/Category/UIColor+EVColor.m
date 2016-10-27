//
//  UIColor+EVColor.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


@implementation UIColor (EVColor)

//------------------------------------------------
//------------------- 视图颜色 --------------------
//------------------------------------------------
/**< 主色调-淡蓝色:#9ac9ff */
+ (UIColor *)evMainColor {
//    return [UIColor colorWithHexString:@"#9ac9ff"];
    return CCColor(98, 45, 128);
}

/**< 主色配色-深蓝色:#314075 */
+ (UIColor *)evSecondColor {
//    return [UIColor colorWithHexString:@"#314075"];
    return [UIColor whiteColor];
}

/**< 辅色-淡粉色:#ff8da8 */
+ (UIColor *)evAssistColor {
    return [UIColor colorWithHexString:@"#ff8da8"];
}

/**< 底色-近白色:#f4f4f4 */
+ (UIColor *)evBackgroundColor {
    return [UIColor colorWithHexString:@"#f4f4f4"];
}

/**< 线色-分割线颜色:#efefef */
+ (UIColor *)evLineColor {
    return [UIColor colorWithHexString:@"#efefef"];
}

/**< 提示色-深粉色:#ff4a75 */
+ (UIColor *)evRemindColor {
    return [UIColor colorWithHexString:@"#ff4a75"];
}

/**< 辅助颜色-淡紫色:#af86ff */
+ (UIColor *)evPurpleColor {
    return [UIColor colorWithHexString:@"#af86ff"];
}

//------------------------------------------------
//------------------- 字体颜色 --------------------
//------------------------------------------------

/**< 一级字体颜色:#262626 */
+ (UIColor *)evTextColorH1 {
    return [UIColor colorWithHexString:@"#262626"];
}

/**< 二级字体颜色:#858585 */
+ (UIColor *)evTextColorH2 {
    return [UIColor colorWithHexString:@"#858585"];
}

/**< 三级字体颜色:#acacac */
+ (UIColor *)evTextColorH3 {
    return [UIColor colorWithHexString:@"#acacac"];
}


@end
