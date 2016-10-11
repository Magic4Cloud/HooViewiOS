//
//  EVStrokeLabel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//
//  带有描边的label

#import <UIKit/UIKit.h>

@interface EVStrokeLabel : UILabel

/** 文字描边颜色 */
@property (nonatomic, strong) UIColor *strokeColor;

/** 文字描边宽度 */
@property (nonatomic, assign) CGFloat strokeWidth;

@end
