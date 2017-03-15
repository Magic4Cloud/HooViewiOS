//
//  EVMovingConvexView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

#define CCMovingConvexView_HEIGHT  40

@protocol EVMovingConvexViewDelegate <NSObject>

- (void)movingConvexViewDidUpdatePercent:(CGFloat)percent;
- (void)movingUpdateToIndex:(NSInteger)index;

@end

@interface EVMovingConvexView : UIView

@property (nonatomic,weak) id<EVMovingConvexViewDelegate> delegate;

- (instancetype)initWithPointCount:(NSInteger)pointCount;

@property (nonatomic, assign) CGFloat scrollPercent;

@end
