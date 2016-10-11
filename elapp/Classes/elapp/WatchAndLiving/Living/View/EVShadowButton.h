//
//  EVShadowButton.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVShadowButton : UIButton

@property (nonatomic,strong) UIColor *normalBackGroundColor;

@property (nonatomic,strong) UIColor *hightBackGroundColor;

@property (nonatomic,strong) UIColor *hightLightBorderColor;
@property (nonatomic,strong) UIColor *normalLightBorderColor;

@property (nonatomic,strong) UIColor *shadowColor;

@property (nonatomic, assign) BOOL bright;

@end

@interface EVWhiteShadowButton : EVShadowButton

@end
