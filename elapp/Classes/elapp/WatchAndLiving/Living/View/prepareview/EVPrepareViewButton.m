//
//  EVPrepareViewButton.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPrepareViewButton.h"

#define kInerMargin 12

#define kImageViewPercent 0.6
#define kTitleViewPercent 0.1

@implementation EVPrepareViewButton

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageViewFrame = self.imageView.frame;
    
    CGFloat superW = self.bounds.size.width;
    CGFloat superH = self.bounds.size.height;
    
    CGFloat imageH = superH * kImageViewPercent;
    CGFloat imageW = imageH;
    imageViewFrame.size.height = imageH;
    imageViewFrame.size.width = imageW;
    self.imageView.frame = imageViewFrame;
    
    CGFloat titleH = titleFrame.size.height;
    
    CGFloat imageCenterY = imageH * 0.5;
    CGFloat imageCenterX = superW * 0.5;
    self.imageView.center = CGPointMake(imageCenterX, imageCenterY);
    
    CGFloat titlCenterY = superH - 0.5 * titleH;
    CGFloat titlCenterX = imageCenterX;
    self.titleLabel.center = CGPointMake(titlCenterX, titlCenterY);
}

@end
