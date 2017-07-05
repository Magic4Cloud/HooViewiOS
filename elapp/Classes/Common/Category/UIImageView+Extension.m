//
//  UIImageView+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSObject+Extension.h"


@implementation UIImageView (Extension)

- (void)cc_setUserIconWithDefaultPlaceHoderURLString:(NSString *)urlString {
    [self cc_setImageWithURLString:urlString placeholderImageName:@"avatar"];
}

- (void)cc_setVideoThumbWithDefaultPlaceHoderURLString:(NSString *)urlString {
    [self cc_setImageWithURLString:urlString placeholderImageName:@"home_recommend_place_holder"];
}

- (void)cc_setImageWithDefaultPlaceHoderURLString:(NSString *)urlString {
//    [self cc_setImageWithURLString:urlString placeholderImageName:@"home_recommend_place_holder"];
    // avatar
    [self cc_setImageWithURLString:urlString placeholderImageName:@"avatar"];
}

- (void)cc_setImageWithURLString:(NSString *)urlString
            placeholderImageName:(NSString *)placeHolderImageName
{
    NSURL *imgRRL = [NSURL URLWithString:urlString];
    UIImage *placeHoderImg = [UIImage imageNamed:placeHolderImageName];
    [self sd_setImageWithURL:imgRRL
            placeholderImage:placeHoderImg];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placehloder
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placehloder];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placehloder complete:(void(^)(UIImage *image))complete
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placehloder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( complete ) {
            complete(image);
        }
    }];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName complete:(void(^)(UIImage *image))complete
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeHolderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( complete && image )
        {
            complete(image);
        }
    }];
}

- (void)cc_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName completeBlock:(void (^)(UIImage *))complete
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeHolderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( complete ) {
            complete(image);
        }
    }];
}

- (void)cc_setRoundImageWithDefaultPlaceHoderURLString:(NSString *)urlString {
    // [self cc_setRoundImageWithURL:urlString placeholderImageName:@"home_recommend_place_holder"];
//    [self cc_setRoundImageWithURL:urlString placeholderImageName:@"avatar"];
    [self cc_setImageWithURLString:urlString placeholderImageName:@"avatar"];
}

- (void)cc_setRoundImageWithURL:(NSString *)urlString placeholderImageName:(NSString *)placeHolderImageName
{
    UIImage *placeHolderImage = [[UIImage imageNamed:placeHolderImageName] cc_roundedImageWithImage];
    NSURL *url = [NSURL URLWithString:urlString];
    self.image = placeHolderImage;
    NSString *cacheKey = [NSString stringWithFormat:@"%@_round", urlString];

    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
    if(cacheImage != nil)
    {
        [self setImage:cacheImage];
    }
    else
    {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [self performBlockOnMainThread:^{
                UIImage *roundImage = [image cc_roundedImageWithImage];
                [[SDImageCache sharedImageCache] storeImage:roundImage forKey:cacheKey completion:nil];
                if ( roundImage == nil ) {
                    roundImage = placeHolderImage;
                }
                [self setImage:roundImage];
            }];
        }];
    }
}


@end
