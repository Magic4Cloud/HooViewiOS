//
//  EVHVWatchTopView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, EVHVWatchViewType) {
    EVHVWatchViewTypeBack,
    EVHVWatchViewTypeFull,
    EVHVWatchViewTypeShare,
    EVHVWatchViewTypePause,
    EVHVWatchViewTypeReport,
    
};

@protocol  EVHVWatchTopViewDelegate <NSObject>

- (void)watchButttonClickType:(EVHVWatchViewType)type button:(UIButton *)button;

@end

@interface EVHVWatchTopView : UIView

@property (nonatomic, weak) id <EVHVWatchTopViewDelegate> delegate;

@property (nonatomic, assign) BOOL pause;

@property (nonatomic, weak) UIButton *pauseButton;

@property (nonatomic, strong) UIButton * fullButton;

@property (nonatomic, strong) UIButton * shareButton;
- (void)gestureHideView;
@end
