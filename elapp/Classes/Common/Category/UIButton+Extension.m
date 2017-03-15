//
//  UIButton+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "UIButton+Extension.h"
#import "UIButton+WebCache.h"
#define kNavigationItemMargin 0

@implementation UIButton (Extension)

- (void)cc_setBackgroundImageURL:(NSString *)imageURL forState:(UIControlState)state placeholderImage:(UIImage *)placeHolder{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:state placeholderImage:placeHolder];
}
- (void)cc_setImageURL:(NSString *)imageURL forState:(UIControlState)state placeholderImage:(UIImage *)placeHolder{
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:state placeholderImage:placeHolder];
}

- (void)fontFamily_addAppAppearanceNotification{

}

@end

@implementation UIButton (BackButtonItem)

- (instancetype)initWithTitle:(NSString *)title {
    if ( self = [super init] )
    {
        self.frame = CGRectMake(kNavigationItemMargin, .0f, 44.0f, 44.0f);
        
        [self setTitle:title forState:UIControlStateNormal];
        
        [self.titleLabel setFont:[[EVAppSetting shareInstance] normalFontWithSize:15.0f]];
        [self setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentEdgeInsets = UIEdgeInsetsMake(.0f, -6.0f, .0f, .0f);
    }
    return self;
}

@end

@implementation UIButton (GreenOrWhiteBtn)

- (void)greenBackAndWhiteTitle
{
    self.backgroundColor = [UIColor evMainColor];
    self.titleLabel.tintColor = [UIColor whiteColor];
}

- (void)whiteBackAndGreenTitle
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.tintColor = [UIColor evMainColor];
}

@end
