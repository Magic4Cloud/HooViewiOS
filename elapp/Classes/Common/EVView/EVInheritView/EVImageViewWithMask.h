//
//  EVImageViewWithMask.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

/**
 当前类的实例imageView高度至少是 kGlobalGrayLayerHeight
  */

#import <UIKit/UIKit.h>

@interface EVImageViewWithMask : UIImageView

@property (weak, nonatomic) UILabel *title;         // ios8.1暂时别用此属性赋值
@property (copy, nonatomic) UIColor *maskColor;             // default is black color
@property (copy, nonatomic) UIColor *bottomMaskColor;       // default is black color
@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) CALayer *bottomMaskLayer;

@end
