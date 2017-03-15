//
//  EVLineView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLineView.h"
#import <PureLayout/PureLayout.h>

@implementation EVLineView

#pragma mark - Init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // set backgroundColor
        self.backgroundColor = [UIColor evGlobalSeparatorColor];
    }
    return self;
}

#pragma mark - Public Method
+ (void)addTopLineToView:(UIView *)view {
    if (view) {
        EVLineView *lineView = [EVLineView new];
        [view addSubview:lineView];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    }
}

+ (void)addBottomLineToView:(UIView *)view {
    if (view) {
        EVLineView *lineView = [EVLineView new];
        [view addSubview:lineView];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    }
}

+ (void)addCellBottomDefaultLineToView:(UIView *)view
{
    if (view) {
        EVLineView *lineView = [EVLineView new];
        [view addSubview:lineView];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    }
}

+ (void)addCellTopDefaultLineToView:(UIView *)view
{
    if (view) {
        EVLineView *lineView = [EVLineView new];
        [view addSubview:lineView];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
        [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    }
    
}

@end
