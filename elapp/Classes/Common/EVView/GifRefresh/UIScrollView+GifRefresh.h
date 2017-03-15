//
//  UIScrollView+GifRefresh.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRefreshGifFooter.h"

/**
 刷新控件的状态
 */
typedef enum {
    CCRefreshStateIdle = 1,     /**< 普通闲置状态 */
    CCRefreshStatePulling,      /**< 松开就可以进行刷新的状态 */
    CCRefreshStateRefreshing,   /**< 正在刷新中的状态 */
    CCRefreshStateWillRefresh,  /**< 即将刷新的状态 */
    CCRefreshStateNoMoreData,   /**< 所有数据加载完毕，没有更多的数据了 */
} CCRefreshState;

@interface UIScrollView (GifRefresh)

/**
 *  添加头部刷新
 *
 *  @param target 刷新回调的响应者
 *  @param action 刷新回调的方法
 */
- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  添加尾部刷新
 *
 *  @param target 刷新回调的响应者
 *  @param action 刷新回调的方法
 */
- (void)addRefreshFooterWithiTarget:(id)target action:(SEL)action;

/**
 *  添加头部刷新
 *
 *  @param refreshingBlock 刷新回调的block
 */
- (void)addRefreshHeaderWithRefreshingBlock:(void(^)())refreshingBlock;

/**
 *  添加尾部刷新
 *
 *  @param refreshingBlock 刷新回调的block
 */
- (void)addRefreshFooterWithRefreshingBlock:(void(^)())refreshingBlock;

/**
 *  添加头部刷新，并且头部刷新时自动关闭尾部刷新
 *
 *  @param refreshingBlock 刷新回调的block
 */
- (void)addRefreshHeaderAutoEndingFooterWhenRefreshing:(void(^)())refreshingBlock;

/**
 *  添加尾部刷新，并且尾部刷新时自动关闭头部刷新
 *
 *  @param refreshingBlock 刷新回调的block
 */
- (void)addRefreshFooterAutoEndingHeaderWhenRefreshing:(void(^)())refreshingBlock;

/**
 *  头部是否正在刷新
 *
 *  @return YES:正在刷新; NO:不是
 */
- (BOOL)isTableViewHeaderRefreshing;

/**
 *  尾部是否正在刷新
 *
 *  @return YES:正在刷新; NO:不是
 */
- (BOOL)isTableViewFooterRefreshing;

/**
 *  开始头部刷新
 */
- (void)startHeaderRefreshing;

/**
 *  开始尾部刷新
 */
- (void)startFooterRefreshing;

/**
 *  结束头部刷新
 */
- (void)endHeaderRefreshing;

/**
 *  结束尾部刷新
 */
- (void)endFooterRefreshing;

/**
 *  隐藏头部
 */
- (void)hideHeader;

/**
 *  隐藏尾部
 */
- (void)hideFooter;

/**
 *  显示头部
 */
- (void)showHeader;

/**
 *  显示尾部
 */
- (void)showFooter;

/**
 *  设置头部的状态
 *
 *  @param state 状态标识
 */
- (void)setHeaderState:(CCRefreshState)state;

/**
 *  设置尾部的状态
 *
 *  @param state 状态标识
 */
- (void)setFooterState:(CCRefreshState)state;

/**
 *  头部的状态
 *
 *  @return 状态标识
 */
- (CCRefreshState)hederState;

/**
 *  尾部的状态
 *
 *  @return 状态标识
 */
- (CCRefreshState)footerState;

/**
 *  头部的 bounds
 *
 *  @return header bounds
 */
- (CGRect)headerBounds;

/**
 *  尾部的 bounds
 *
 *  @return footer bounds
 */
- (CGRect)footerBounds;

/**
 *  向尾部添加子视图
 *
 *  @param subview 子视图
 */
- (void)addSubviewToFooterWithSubview:(UIView *)subview;

/**
 *  为头部不同状态设置不同的title
 *
 *  @param title 标题
 *  @param state 状态
 */
- (void)setHeaderTitle:(NSString *)title forState:(CCRefreshState)state;

/**
 *  为尾部不同状态设置不同的title
 *
 *  @param title 标题
 *  @param state 状态
 */
- (void)setFooterTitle:(NSString *)title forState:(CCRefreshState)state;

/**
 *  隐藏头部显示上次更新时间的label
 */
- (void)hideHeaderLastUpdateTimeLabel;

/**
 *  隐藏头部显示状态的label
 */
- (void)hideHeaderStateLabel;

/**
 *  设置头部字体的颜色和字体
 *
 *  @param textColor 字色
 *  @param font      字体
 */
- (void)setHeaderTitleTextColor:(UIColor *)textColor font:(UIFont *)font;

/**
 *
 *  上拉刷新的尾部视图
 *
 *  @return 尾部视图
 */
- (EVRefreshGifFooter *)footer;

/**
 *
 *  上拉刷新的头部视图
 *
 *  @return 头部视图
 */
- (EVRefreshGifFooter *)header;

@end
