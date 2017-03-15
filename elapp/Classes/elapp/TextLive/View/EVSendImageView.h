//
//  EVSendImageView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVSendImageDelegate <NSObject>

- (void)chooseImageButton:(UIButton *)btn;

- (void)chooseButton:(UIButton *)btn;

- (void)SGSegmentedIndex:(NSInteger)index;

@end

@class CCVerticalLayoutButton;
@interface EVSendImageView : UIView
;
@property (nonatomic, weak) id<EVSendImageDelegate> delegate;

@property (nonatomic, strong) NSLayoutConstraint *imageButtonBottonHig;

@property (nonatomic, weak) UIView *imageButtonBottom;

@property (nonatomic, weak) CCVerticalLayoutButton *photoBtn;
@property (nonatomic, weak) CCVerticalLayoutButton *cameraBtn;
@end
