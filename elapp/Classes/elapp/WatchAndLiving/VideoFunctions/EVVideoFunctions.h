//
//  EVVideoFunctions.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface EVVideoFunctions : NSObject

/**< 生成一张模糊背景图 */
+ (UIImageView *)blurBackgroundImageView:(NSString *)imageUrl;

/**< 给左上角、右上角加圆角 */
+ (void)setTopLeftAndTopRightCorner:(UIView *)view;

/**< 给左下角、右下角加圆角 */
+ (void)setBottomLeftAndBottomRightCorner:(UIView *)view;

/** "举报"操作 */
+ (void)handleReportAction;

@end
