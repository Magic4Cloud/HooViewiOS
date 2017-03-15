//
//  EVConsultTopView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/25.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGSegmentedControlStatic;
@protocol EVConsultTopViewDelegate <NSObject>

- (void)topViewDidSeleteIndex:(NSInteger)index;

- (void)didSeleteSearch;

@end

@interface EVConsultTopView : UIView

@property (nonatomic, weak) UIButton *searchButton;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) id<EVConsultTopViewDelegate> delegate;
//对应按钮
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scroll;
@end
