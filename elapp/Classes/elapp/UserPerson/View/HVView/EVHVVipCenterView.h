//
//  EVHVVipCenterView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/8.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVUserModel.h"

@protocol EVHVVipCenterDelegate <NSObject>

- (void)backButton;

- (void)reportButton;

@end

@interface EVHVVipCenterView : UIView

@property (nonatomic, weak) UIImageView *userHeadIgeView;

@property (nonatomic, weak) UIButton *reportBtn;

@property (nonatomic, weak) id <EVHVVipCenterDelegate> delegate;
@property (nonatomic, strong) EVUserModel *userModel;
@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;
- (instancetype)initWithFrame:(CGRect)frame isTextLive:(BOOL)istextlive;
@end
