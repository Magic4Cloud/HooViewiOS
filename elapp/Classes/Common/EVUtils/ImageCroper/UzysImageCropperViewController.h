//
//  UzysImageCropperViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysImageCropper.h"
#import "ARCHelper.h"

@protocol UzysImageCropperDelegate;
@class  UzysImageCropper;

@interface UzysImageCropperViewController : UIViewController 

@property (nonatomic,strong) UzysImageCropper *cropperView;
@property (nonatomic, assign) id <UzysImageCropperDelegate> delegate;
- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize originImage:(BOOL)originImage;

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize;

- (void)actionRotation:(id) senders;
@end

@protocol UzysImageCropperDelegate <NSObject>
- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image;
- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper;
@end
