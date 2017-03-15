//
//  UIImage+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
 //
//  UIImage+Extension.m
//
//  Created by APPLE on 15/5/21.
//  Copyright (c) 2015年 easyvaas. All rights reserved.
//

#import <SDWebImageDownloader.h>
#import <SDImageCache.h>
#import "NSObject+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)cc_imagedataWithMaxLength:(NSUInteger)length
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if ( data.length <= length )
    {
        return data;
    }
    
    CGFloat scale = (CGFloat)((CGFloat)length / data.length);
    data = UIImageJPEGRepresentation(self, scale);
    
    if ( data.length <= length )
    {
        return data;
    }
    
    CGFloat witdth = self.size.width;
    CGFloat height = self.size.height;
    CGFloat ratio = sqrtf(scale);
    CGFloat x = (witdth - ratio * witdth) * 0.5;
    CGFloat y = (height - ratio * height) * 0.5;
    witdth = ratio * witdth;
    height = ratio * height;
    UIImage *image = [self gp_clipImageBy:CGRectMake(x, y, witdth, height)];
    
    return UIImageJPEGRepresentation(image, 0.9);
}

- (UIImage *)cc_imageWithMaxLength:(NSUInteger)length
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if ( data.length <= length )
    {
        return self;
    }
    
    CGFloat scale = (CGFloat)((CGFloat)length / data.length);
    data = UIImageJPEGRepresentation(self, scale);
    
    if ( data.length <= length )
    {
        return [[UIImage alloc] initWithData:data];
    }
    
    CGFloat witdth = self.size.width;
    CGFloat height = self.size.height;
    CGFloat ratio = sqrtf(scale);
    CGFloat x = (witdth - ratio * witdth) * 0.5;
    CGFloat y = (height - ratio * height) * 0.5;
    witdth = ratio * witdth;
    height = ratio * height;
    UIImage *image = [self gp_clipImageBy:CGRectMake(x, y, witdth, height)];
    
    return image;
}

- (UIImage *)cc_roundedImageWithImage {
    UIImage *roundedImage = nil;
    float size = MIN(self.size.width, self.size.height);
    size = MIN(size, 64);
    float radius = size * 0.5;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 1);
    
    CGRect rect = CGRectMake(0, 0, size, size);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [self drawInRect:rect];
    
    roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

- (UIImage *)cc_reSizeImageToSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)cc_centreImageWithSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake((self.size.width - reSize.width) / 2, (self.size.height - reSize.height) / 2, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

/**
 *  根据指定区域裁剪图片
 *
 *  @param rect 指定的区域
 *
 *  @return 裁剪好的图片
 */
- (UIImage *)gp_clipImageBy:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return image;
}

- (instancetype)gp_compressImageWithMaxLength:(double)maxLength {
    CGFloat compression = 0.9f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    CGFloat maxCompression = 0.1f;
    int maxFileSize = maxLength;
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    return [[UIImage alloc] initWithData:imageData];
}

/**
 *  加载一张不被渲染的图片
 *
 *  @param name 图片名
 *
 *  @return 原图片
 */
+ (instancetype)gp_imageFromOriginalName:(NSString *)name {
    UIImage *img = [UIImage imageNamed:name];
    // 使用原模式加载图片
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

/**
 *  创建一个圆环图片
 *
 *  @param name         图片名称
 *  @param boarderWidth 圆环的宽度
 *  @param color        圆环的颜色
 *
 *  @return 所要的图片
 */
+ (instancetype)gp_image:(NSString *)name BoarderWith:(CGFloat)boarderWidth BoardColor:(UIColor *)gp_color{
    UIImage *image = [UIImage imageNamed:name];
    CGRect loopRect = CGRectMake(0, 0, image.size.width + 2 * boarderWidth, image.size.height + 2 * boarderWidth);
    CGRect imgRect = CGRectMake(boarderWidth, boarderWidth, image.size.width , image.size.height);
    // 圆环
    UIGraphicsBeginImageContextWithOptions(loopRect.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:loopRect];
    [[UIColor blueColor] set];
    [path fill];
    // 图片
    UIBezierPath *imgpath = [UIBezierPath bezierPathWithOvalInRect:imgRect];
    [imgpath addClip];
    [imgpath stroke];
    [image drawInRect:imgRect];
    // 获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  把一个view显示的内容生成图片
 *
 *  @param view
 *
 *  @return 生成的图片
 */
+ (instancetype)gp_imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize
{
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  把一个view显示的内容生成图片
 *
 *  @param view
 *
 *  @return 生成的图片
 */
+ (instancetype)gp_imageWithView:(UIView *)view Opaque:(BOOL)opaque {
    // 创建图片上下文
    //    UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,opaque, 0);
    // 获取创建的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 获取控件信息,把信息保存到上下文
    [view.layer renderInContext:ctx];
    // 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  画一个图片水印到当前图片上
 *
 *  @param img   水印图片
 *  @param frame 水印在该图片中的显示位置
 *
 *  @return 处理好的图片
 */
- (instancetype)gp_waterMarkWith:(UIImage *)img inFrameOfCurImage:(CGRect)frame{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 把当前图片渲染到上下文中
    CGRect imgR = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:imgR];
    // 画水印
    [img drawInRect:frame];
    // 获取上下文中的图片
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回图片
    return result;
}

/**
 *  画一个图片水印到当前图片上,默认会显示在图片的右下角
 *
 *  @param img 水印图片
 *
 *  @return 处理好的图片
 */
- (instancetype)gp_waterMarkWith:(UIImage *)img{
    CGFloat w = img.size.width;
    CGFloat h = img.size.height;
    CGFloat x = self.size.width - w;
    CGFloat y = self.size.height - h;
    CGRect fame = CGRectMake(x, y, w, h);
    UIImage *result = [self gp_waterMarkWith:img inFrameOfCurImage:fame];
    return result;
    
}

/**
 *  画一个文字水印在当前图片上
 *
 *  @param str      图片上的文字
 *  @param frame    文字的位置
 *  @param attrInfo 文字样式的信息
 *
 *  @return 处理后的图片
 */
- (instancetype)gp_waterMarkWith:(NSString *)str InRect:(CGRect)frame withAttributes:(NSDictionary *)attrInfo{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 把当前图片渲染到上下文
    CGRect imgR = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:imgR];
    // 画水印
    [str drawInRect:frame withAttributes:attrInfo];
    // 获取上下文图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 返回图片
    return img;
}

/**
 *  画一个文字水印在当前图片上(默认会显示在右下角),此方法必须于- (instancetype)gp_waterMarkWith:(NSString *)str InRect:(CGRect)frame withAttributes:(NSDictionary *)attrInfo 一起拷贝
 *
 *
 *  @param str      图片上的文字
 *  @param attrInfo 文字样式的信息
 *
 *  @return 处理后的图片
 */
- (instancetype)gp_waterMarkWith:(NSString *)str withAttributes:(NSDictionary *)attrInfo
{
    CGFloat maxW = self.size.width * 0.5;
    CGFloat maxH = self.size.height * 0.5;
    CGRect frame = [str boundingRectWithSize:CGSizeMake(maxW, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrInfo context:nil];
    CGFloat strX = self.size.width - frame.size.width;
    CGFloat strY = self.size.height - frame.size.height;
    frame.origin.x = strX;
    frame.origin.y = strY;
    return [self gp_waterMarkWith:str InRect:frame withAttributes:attrInfo];
}

+ (void)gp_imageWithURlString:(NSString *)urlString
                     comoleteOrLoadFromCache:(void(^)(UIImage *image, BOOL loadFromLocal))completeBlokck
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if ( image && completeBlokck )
    {
        completeBlokck(image, YES);
        return;
    }
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *downloadImage, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:downloadImage forKey:urlString];
        [self performBlockOnMainThreadInClass:^{
            if ( image && completeBlokck )
            {
                completeBlokck(image, NO);
                return;
            }
        }];
    }];
}

+ (void)gp_imageWithURlString:(NSString *)urlString comolete:(void(^)(UIImage *image))completeBlokck{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if ( image && completeBlokck )
    {
        completeBlokck(image);
        return;
    }
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *downloadImage, NSData *data, NSError *error, BOOL finished) {
        if ( downloadImage )
        {
            [[SDImageCache sharedImageCache] storeImage:downloadImage forKey:urlString];
            [self performBlockOnMainThreadInClass:^{
                if ( completeBlokck ) {
                    completeBlokck(downloadImage);
                }
            }];
        }
    }];
}

+ (void)gp_downloadWithURLString:(NSString *)urlString complete:(void(^)(NSData *data))completeBlokck
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if ( image && completeBlokck )
    {
        completeBlokck(UIImagePNGRepresentation(image));
        return;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *downloadImage, NSData *data, NSError *error, BOOL finished) {
        [self performBlockOnMainThreadInClass:^{
            if ( completeBlokck ) {
                completeBlokck(data);
            }
        }];
    }];
}

+ (instancetype)imageWithALogoWithSize:(CGSize)size isLiving:(BOOL)isLiving
{
//    EVLog(@"----size:%@", NSStringFromCGSize(size));
    CGSize tempSize = CGSizeMake(floor(size.width), floor(size.height));
    NSString *sizeStr = NSStringFromCGSize(tempSize);
    sizeStr = [sizeStr stringByAppendingString:@"imageSize"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:sizeStr];
    if ( image )
    {
        return image;
    }
    image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:sizeStr];
    if ( image )
    {
        return image;
    }
    
    UIImage *logoImg = isLiving ? [UIImage imageNamed:@"home_pic_loadbackground_blue"] : [UIImage imageNamed:@"home_pic_loadbackground_red"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImg];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    CGSize newSize = CGSizeMake(size.width, size.height);
    CGRect frame = CGRectZero;
    CGFloat minLine = 0;
    
    if (MIN(newSize.width, newSize.height) == 0)
    {
        newSize = CGSizeMake(100, 100);
        minLine = MIN(newSize.width / 2.0, newSize.height / 2.0);
        imageView.bounds = CGRectMake(0, 0, minLine, minLine);
    }
    else
    {
        minLine = MIN(newSize.width, newSize.height);
        if ( MAX(logoImg.size.width, logoImg.size.height) > minLine )
        {
            imageView.bounds = CGRectMake(0, 0, minLine, minLine);
        }
    }
    frame.size = newSize;
    UIView *backgroudV = [[UIView alloc] initWithFrame:frame];
    NSString *colorStr  = isLiving ? [NSString stringWithFormat:@"#F0F7FF"] : [NSString stringWithFormat:@"#FFF4F7"];
    backgroudV.backgroundColor = [UIColor colorWithHexString:colorStr];
    [backgroudV addSubview:imageView];
    imageView.center = backgroudV.center;
    
    image = [UIImage gp_imageWithView:backgroudV];
    [[SDImageCache sharedImageCache] storeImage:image forKey:sizeStr];

    return image;
}

+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)newSize
{
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);

@implementation UIImage (CS_Extensions)

- (UIImage *)cropImage:(CGRect) rect{
    CGAffineTransform rectTransform;
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(DegreesToRadians(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(DegreesToRadians(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(DegreesToRadians(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

-(UIImage*)resizedImageToSize:(CGSize)dstSize {
    CGImageRef imgRef = self.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
    CGFloat scaleRatio = dstSize.width / srcSize.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}



/////////////////////////////////////////////////////////////////////////////



-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale {
    // get the image size (independant of imageOrientation)
    CGImageRef imgRef = self.CGImage;
    CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which depends on the imageOrientation)!
    
    // adjust boundingSize to make it independant on imageOrientation too for farther computations
    UIImageOrientation orient = self.imageOrientation;
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
            break;
        default:
            // NOP
            break;
    }
    
    // Compute the target CGRect in order to keep aspect-ratio
    CGSize dstSize;
    
    if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) )
    {
        //EVLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
        dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
    }
    else
    {
        CGFloat wRatio = boundingSize.width / srcSize.width;
        CGFloat hRatio = boundingSize.height / srcSize.height;
        
        if ( wRatio < hRatio )
        {
            //EVLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
            dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
        }
        else
        {
            //EVLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
            dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
            
        }
    }
    
    return [self resizedImageToSize:dstSize];
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
//    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
//    EVLog(@"self.scale:%f", self.scale);
    // 让缩放值变小，解决太大，导致内存高企，导致crash
    CGFloat scale = 1 / self.scale > 0.7 ? 0.7 : 1 / self.scale;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
//    CGContextDrawImage(bitmap, CGRectMake(-0, -00, 200, 200), [self CGImage]);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    CGContextRelease(bitmap);
    return newImage;
}

- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)scaleImage:(UIImage *)image scaleSize:(CGSize)scaleSize {
    UIGraphicsBeginImageContext(scaleSize);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)newImageWithLeftimage:(UIImage *)leftImage
                        rightImage:(UIImage *)rightImage
                  horizontalMargin:(CGFloat)margin
{
    CGFloat height = MAX(leftImage.size.height, rightImage.size.height);
    CGSize newSize = CGSizeMake(leftImage.size.width + rightImage.size.width + margin, height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    
    // Draw image1
    [leftImage drawInRect:CGRectMake(0, (height - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height)];
    
    // Draw image2
    [rightImage drawInRect:CGRectMake(leftImage.size.width + margin, (height - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (instancetype)grabImageFromViewInheritance:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 1.0f);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImage (TintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color {
    return [self imageWithTintColor:color alpha:1.0f];
}

- (UIImage *)imageWithTintColor:(UIColor *)color alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, 0, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:alpha];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end

#pragma mark - C function
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
