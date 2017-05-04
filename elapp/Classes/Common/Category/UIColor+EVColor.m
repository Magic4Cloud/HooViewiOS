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
/**< 主色调-紫色:#672F87 */
+ (UIColor *)evMainColor {
    return [UIColor colorWithHexString:@"#672F87"];
}

+ (UIColor *)mainColorAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexString:@"#672F87" alpha:alpha];
}
/**< 主色配色-绿色:#00bf8b  */
+ (UIColor *)evSecondColor {
    return [UIColor colorWithHexString:@"#00bf8b"];
}

/**< 辅色-红色:#ff5756 */
+ (UIColor *)evAssistColor {
    return [UIColor colorWithHexString:@"#ff5756"];
}

/**< 底色-近白色:#f8f8f8 */
+ (UIColor *)evBackgroundColor {
    return [UIColor colorWithHexString:@"#f8f8f8"];
}

/**< 线色-分割线颜色:#efefef */
+ (UIColor *)evLineColor {
    return [UIColor colorWithHexString:@"#efefef"];
}

/**< 提示色-深粉色:#ff4a75 */
+ (UIColor *)evRemindColor {
    return [UIColor colorWithHexString:@"#ff4a75"];
}

/**< 辅助颜色-淡紫色:#a65f5f */
+ (UIColor *)evPurpleColor {
    return [UIColor colorWithHexString:@"#a65f5f"];
}

+ (UIColor *)evTipColor {
    return [UIColor colorWithHexString:@"#5c2d7e" alpha:0.3];
}

//221 221 221
+ (UIColor *)evDDDColor {
    return [UIColor colorWithHexString:@"#dddddd"];
}

+ (UIColor *)evBackGroundLightGrayColor
{
    return [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
}

+ (UIColor *)evBackGroundDeepGrayColor
{
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
}
//227 96 96
+ (UIColor *)evBackGroundDeepRedColor
{
    return [UIColor colorWithRed:227/255.0 green:96/255.0 blue:96/255.0 alpha:1];
}

+ (UIColor *)evBackGroundDeepBlueColor
{
    return [UIColor colorWithRed:101/255.0 green:154/255.0 blue:224/255.0 alpha:1];
}
//------------------------------------------------
//------------------- 字体颜色 --------------------
//------------------------------------------------

/**< 一级黑色颜色:#303030 */
+ (UIColor *)evTextColorH1 {
    return [UIColor colorWithHexString:@"#303030"];
}

/**< 二级灰色字体:#999999 */
+ (UIColor *)evTextColorH2 {
    return [UIColor colorWithHexString:@"#999999"];
}

/**< 三级红色字体:#ff4342 */
+ (UIColor *)evTextColorH3 {
    return [UIColor colorWithHexString:@"#ff4342"];
}


+ (UIColor *)evRedColor {
    return [UIColor colorWithRed:254/255.0 green:79/255.0 blue:80/255.0 alpha:1];
}

+ (UIColor *)evGlobalSeparatorColor
{
    return [UIColor colorWithHexString:@"#d9d9d9"];
}

+ (UIColor *)evNaviBarBgColor
{
    return [UIColor colorWithHexString:@"#fffcf9"];
}

+ (UIColor *)evlightGrayTextColor
{
    return [UIColor colorWithHexString:@"#666666"];
}

+ (UIColor *)textBlackColor
{
    return [UIColor colorWithHexString:@"#303030"];
}

//#f87a2b 248 122 43

+ (UIColor *)liveBackColor
{
    return [UIColor colorWithHexString:@"#f87a2b"];
}

//#672f87  103 47 135
+ (UIColor *)hvPurpleColor
{
    return [UIColor colorWithHexString:@"#672f87"];
}

//#FF6820  255 104 32
+ (UIColor *)evOrangeColor
{
     return [UIColor colorWithHexString:@"#FF6820"];
}
//rgb 255 158 0
+ (UIColor *)evOrangeBgColor
{
    return [UIColor colorWithHexString:@"#FF9E00"];
}
//255 126 40
+ (UIColor *)evEcoinColor
{
    return [UIColor colorWithHexString:@"#FF7E28"];
}
@end
