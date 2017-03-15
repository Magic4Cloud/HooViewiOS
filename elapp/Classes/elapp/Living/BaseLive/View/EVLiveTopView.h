//
//  EVLiveTopView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVLiveTopViewDelegate <NSObject>

- (void)segmentedDidSeletedIndex:(NSInteger)index;

- (void)didSearchButton;

@end

@interface EVLiveTopView : UIView

@property (nonatomic, weak) id<EVLiveTopViewDelegate> delegate;

- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

@end
