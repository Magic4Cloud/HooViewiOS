//
//  EVLineView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVLineView : UIView

/**
 *  为目标视图 >>“顶部”<< 添加一条APP中统一规格的线
 *
 *  @param view 目标视图
 */
+ (void)addTopLineToView:(UIView *)view;

/**
 *  为目标视图 >>“底部”<< 添加一条APP中统一规格的线
 *
 *  @param view 目标视图
 */
+ (void)addBottomLineToView:(UIView *)view;


+ (void)addCellBottomDefaultLineToView:(UIView *)view;

+ (void)addCellTopDefaultLineToView:(UIView *)view;
@end
