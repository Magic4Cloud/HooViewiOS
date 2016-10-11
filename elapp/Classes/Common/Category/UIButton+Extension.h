//
//  UIButton+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 * Set the backgroundImageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)cc_setBackgroundImageURL:(NSString *)imageURL forState:(UIControlState)state placeholderImage:(UIImage *)placeHolder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)cc_setImageURL:(NSString *)imageURL forState:(UIControlState)state placeholderImage:(UIImage *)placeHolder;

/**
 *  空方法，不要使用
 */
- (void)fontFamily_addAppAppearanceNotification;

@end

@interface UIButton (BackButtonItem)

/** 导航栏返回按钮 */
- (instancetype)initWithTitle:(NSString *)title;

@end

@interface UIButton (GreenOrWhiteBtn)

/**
 *  绿底白字
 */
- (void)greenBackAndWhiteTitle;
/**
 *  白底绿字
 */
- (void)whiteBackAndGreenTitle;

@end
