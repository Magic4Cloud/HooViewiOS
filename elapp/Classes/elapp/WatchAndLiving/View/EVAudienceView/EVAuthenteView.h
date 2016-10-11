//
//  EVAuthenteView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVAuthenteView : UIView

/** 官方认证等级 */
@property ( nonatomic ) NSInteger authorityLevel;

@property (nonatomic, weak) NSLayoutConstraint * imageWidthConstraint;

/**
 *
 *  设置个人中心的认证
 */
- (void)setPersonalAuthorityLevel:(NSInteger)authorityLevel;

@end
