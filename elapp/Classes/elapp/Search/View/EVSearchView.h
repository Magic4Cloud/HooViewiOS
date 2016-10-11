//
//  EVSearchView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVSearchView;
@protocol CCSearchViewDelegate <NSObject>

@optional
- (void)searchView:(nonnull EVSearchView *)searchView didBeginSearchWithText:(nullable NSString *)searchText;

- (void)cancelSearch;

- (void)searchView:(nonnull EVSearchView *)searchView didBeginEditing:(nonnull UITextField *)textField;

@end


@interface EVSearchView : UIView

/**
 *  使用类方法进行实例化
 *
 *  @param frame frame
 *
 *  @return 实例
 */
+ (nullable instancetype)instanceWithFrame:(CGRect)frame;

@property (copy, nonatomic, nonnull) NSString *placeHolder;  /**< 占位文字 */
@property (strong, nonatomic, nonnull) UIColor *placeHolderColor; /**< 占位文字的颜色 */
@property (copy, nonatomic, nonnull) NSString *text;  /**< 输入框的文字 */
@property (strong, nonatomic, nonnull) UIColor *textColor; /**< 文字颜色 */
@property (strong, nonatomic, nonnull) UIFont *font; /**< 字体 */

@property (weak, nonatomic, nullable) id<CCSearchViewDelegate> searchDelegate;  /**< 代理 */

/**
 *  开始编辑状态
 */
- (void)begineEditting;

/**
 *  结束编辑状态
 */
- (void)endEditting;

@end
