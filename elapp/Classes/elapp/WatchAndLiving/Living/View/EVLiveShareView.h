//
//  EVLiveShareView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEnums.h"
#define SAHRE_VIEW_TAG 100

@protocol CCLiveShareViewDelegate <NSObject>

@optional
- (void)liveShareViewDidClickButton:(CCLiveShareButtonType)type;
- (void)liveShareViewDidHidden;

@end

// 分享按钮
@interface EVLiveShareButton : UIButton

@end

@interface EVLiveShareView : UIView

@property (nonatomic, weak) id<CCLiveShareViewDelegate> delegate;

/**
 *  初始化方法, 不会生成透明的蒙板
 *
 *  @return
 */
+ (instancetype)liveShareView;

/**
 *  主要的初始化方法，会自动生成一个透明的背景view包着分享菜单按钮
 *
 *  @param view       该菜单的父控件
 *  @param menuHeight 菜单显示的高度
 *  @param delegate   代理
 *
 *  @return
 */
+ (EVLiveShareView *)liveShareViewToTargetView:(UIView *)view menuHeight:(CGFloat)menuHeight delegate:(id<CCLiveShareViewDelegate>)delegate;

/**
 *  设置距离底部的距离
 *
 *  @param marginBotton <#marginBotton description#>
 */
- (void)setMarginBotton:(CGFloat)marginBotton;

/**
 *  强制隐藏，除此不做任何其他操作
 */
- (void)foreceHideOnly;

@end
