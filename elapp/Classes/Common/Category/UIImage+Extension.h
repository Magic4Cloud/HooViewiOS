//
//  UIImage+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCHelper.h"

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,         //从上到下
    GradientTypeLeftToRight = 1,         //从左到右
    GradientTypeUpleftToLowright = 2,    //左上到右下
    GradientTypeUprightToLowleft = 3,    //右上到左下
};

@interface UIImage (Extension)


+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

/**
 *  给定最大的尺寸压缩至指定尺寸
 *
 *  @param length
 *
 *  @return
 */
- (NSData *)cc_imagedataWithMaxLength:(NSUInteger)length;

/**
 *  <#Description#>
 *
 *  @param length <#length description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)cc_imageWithMaxLength:(NSUInteger)length;

/**
 *  获取圆形图片
 *
 *  @return 圆形图片
 */
- (UIImage*)cc_roundedImageWithImage;

/**
 *  获取指定大小的图片
 *
 *  @param reSize 要得到的大小
 *
 *  @return 指定大小的图片
 */
- (UIImage *)cc_reSizeImageToSize:(CGSize)reSize;

/**
 *  获取该图片中间位置的指定大小图片
 *
 *  @param reSize 要得到的大小
 *
 *  @return 指定大小的图片
 */
- (UIImage *)cc_centreImageWithSize:(CGSize)reSize;

/**
 *  根据指定区域裁剪图片
 *
 *  @param rect 指定的区域
 *
 *  @return 裁剪好的图片
 */
- (UIImage *)gp_clipImageBy:(CGRect)rect;

/**
 *  加载一张不被渲染的图片
 *
 *  @param name 图片名
 *
 *  @return 原图片
 */
+ (instancetype)gp_imageFromOriginalName:(NSString *)name;

/**
 *  创建一个圆环图片
 *
 *  @param name         图片名称
 *  @param boarderWidth 圆环的宽度
 *  @param color        圆环的颜色
 *
 *  @return 所要的图片
 */
+ (instancetype)gp_image:(NSString *)name BoarderWith:(CGFloat)boarderWidth BoardColor:(UIColor *)gp_color;

/**
 *  把一个view显示的内容生成图片
 *
 *  @param view
 *
 *  @return 生成的图片
 */
+ (instancetype)gp_imageWithView:(UIView *)view;

/**  *
 *  @param color     颜色
 *  @param imageSize 尺寸
 *
 *  @return 指定尺寸和颜色的图片
 */
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

/**
 *  把一个view显示的内容生成图片
 *
 *  @param view
 *
 *  @return 生成的图片
 */
+ (instancetype)gp_imageWithView:(UIView *)view Opaque:(BOOL)opaque;

/**
 *  画一个图片水印到当前图片上
 *
 *  @param img   水印图片
 *  @param frame 水印在该图片中的显示位置
 *
 *  @return 处理好的图片
 */
- (instancetype)gp_waterMarkWith:(UIImage *)gp_img inFrameOfCurImage:(CGRect)frame;

/**
 *  画一个图片水印到当前图片上,默认会显示在图片的右下角
 *
 *  @param img 水印图片
 *
 *  @return 处理好的图片
 */
- (instancetype)gp_waterMarkWith:(UIImage *)gp_img;

/**
 *  画一个文字水印在当前图片上
 *
 *  @param str      图片上的文字
 *  @param frame    文字的位置
 *  @param attrInfo 文字样式的信息
 *
 *  @return 处理后的图片
 */
- (instancetype)gp_waterMarkWith:(NSString *)str InRect:(CGRect)frame withAttributes:(NSDictionary *)attrInfo;

/**
 *  画一个文字水印在当前图片上(默认会显示在右下角),此方法必须于- (instancetype)gp_waterMarkWith:(NSString *)str InRect:(CGRect)frame withAttributes:(NSDictionary *)attrInfo 一起拷贝
 *
 *
 *  @param str      图片上的文字
 *  @param attrInfo 文字样式的信息
 *
 *  @return 处理后的图片
 */
- (instancetype)gp_waterMarkWith:(NSString *)str withAttributes:(NSDictionary *)attrInfo;

/**
 *  获取指定路径的图片
 *
 *  @param urlString      图片路径
 *  @param completeBlokck 获取成功后的操作
 */
+ (void)gp_imageWithURlString:(NSString *)urlString comolete:(void(^)(UIImage *image))completeBlokck;

/**
 *
 *  加载图片,并告诉调用者是否从本地加载
 *
 *  @param urlString
 *  @param completeBlokck 
 */
+ (void)gp_imageWithURlString:(NSString *)urlString
      comoleteOrLoadFromCache:(void(^)(UIImage *image, BOOL loadFromLocal))completeBlokck;

/**
 *  下载图片
 *
 *  @param urlString
 *  @param completeBlokck 
 */
+ (void)gp_downloadWithURLString:(NSString *)urlString
                        complete:(void(^)(NSData *data))completeBlokck;

/**
 *  获取指定大小带有logo的image
 *
 *  @param size 宽高
 *
 *  @return 带有logo的图片
 */
+ (instancetype)imageWithALogoWithSize:(CGSize)size isLiving:(BOOL)isLiving;

/**
 *  缩放某个图片到特定的尺寸，原图片保持原有的宽高比，其他区域自动填充
 *
 *  @param image   要缩放的图片
 *  @param newSize 新图片的尺寸
 *
 *  @return 缩放后的图片
 */
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)newSize;

@end


@interface UIImage (CS_Extensions)

/**
 *  旋转图片
 *
 *  @param radians 旋转的角度
 *  @param degrees 
 *
 *  @return 旋转后的图片
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  把图片切割指定大小
 *
 *  @param boundingSize 切割到的尺寸
 *  @param scale        <#scale description#>
 *
 *  @return <#return value description#>
 */
- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)cropImage:(CGRect) rect;
- (UIImage *)fixOrientation;
+ (UIImage *)scaleImage:(UIImage *)image scaleSize:(CGSize)scaleSize;

/**
 *
 *  两张图片和成一张（左右排列）
 *
 *  @param leftImage  左边的图片
 *  @param rightImage 右边的图片
 *  @param margin     两张图片的水平间距
 *
 *  @return 新图片
 */
+ (UIImage *)newImageWithLeftimage:(UIImage *)leftImage
                        rightImage:(UIImage *)rightImage
                  horizontalMargin:(CGFloat)margin;

+ (instancetype)grabImageFromViewInheritance:(UIView *)view;

@end


@interface UIImage (TintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)color alpha:(CGFloat)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
