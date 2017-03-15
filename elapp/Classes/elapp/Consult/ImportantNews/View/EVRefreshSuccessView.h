//
//  EVRefreshSuccessView.h
//  elapp
//
//  Created by Lcrnice on 17/1/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVRefreshSuccessView : UIView

+ (void)showRefreshSuccessViewTo:(UIView *)view newsCount:(NSUInteger)count offsetY:(CGFloat)offsetY;
+ (void)showRefreshSuccessViewTo:(UIView *)view newsCount:(NSUInteger)count;

@end
