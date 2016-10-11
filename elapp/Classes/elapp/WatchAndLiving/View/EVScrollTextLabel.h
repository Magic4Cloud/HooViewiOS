//
//  EVScrollTextLabel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVScrollTextLabel : UIView

/**
 *  如果要设置属性,所有属性都要在 scroll方法之前设置 否则会无效
 */
@property (nonatomic, copy) NSString *text;  // 滚动的文本
@property (nonatomic, assign) float speed;  //  滚动的速度 0.0~1.0 默认速度是0.5
@property (nonatomic, retain) UIColor *textColor;  //  字体颜色
@property (nonatomic, retain) UIFont *font;  //  字体
@property (nonatomic, assign) float delay;  //  延迟delay秒后开始滚动 默认2.0
@property (strong, nonatomic) NSAttributedString *attributedText;


///**
// *  滚动的方法 配置完成后要调用这个方法字幕 并且只有当文本的长度大于视图宽度时才会滚动
// */
//- (void)scroll;

@end
