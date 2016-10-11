//
//  EVLoadingView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


 
#import <UIKit/UIKit.h>

/**
 *  定义点击感叹号的block回调的类型。
 */
typedef void(^ClickBlock)();



@interface EVLoadingView : UIView

@property (nonatomic,copy)NSString *failTitle;

- (void)showLoadingView;

- (void)destroy;

/**
 *  显示请求失败时候的图片。
 *  @clickBlock         点击失败按钮的block.
 */
- (void)showFailedViewWithClickBlock:(ClickBlock)block;

@end
