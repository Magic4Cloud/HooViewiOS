//
//  CCButton.h
//  oupai
//
//  Created by 罗潇 on 2016/9/25.
//  Copyright © 2016年 yizhibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVButton : UIControl {
    
    NSMutableDictionary *_titles;       // NSString
    NSMutableDictionary *_titleColors;  // UIColor
    NSMutableDictionary *_titleShadows; // UIColor
    NSMutableDictionary *_images;       // UIImage
    NSMutableDictionary *_backgrounds;  // UIImage
    
}


@property(nonatomic, assign) CGPoint titleCenter; // default is center in background
@property(nonatomic, assign) CGPoint imageCenter; // default is center in background

@property(nonatomic,readonly,retain) UILabel     *titleLabel;
@property(nonatomic,readonly,retain) UIImageView *imageView;
@property(nonatomic,readonly,retain) UIImageView *background;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (UIColor *)titleShadowColorForState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;

@end
