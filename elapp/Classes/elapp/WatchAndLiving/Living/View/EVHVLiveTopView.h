//
//  EVHVLiveTopView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, EVHVLiveTopViewType) {
    EVHVLiveTopViewTypeClose,
    EVHVLiveTopViewTypeMute,
    EVHVLiveTopViewTypeTurn,
    EVHVLiveTopViewTypeShare,
};


@protocol EVHVLiveTopViewDelegate <NSObject>

- (void)liveTopViewButtonType:(EVHVLiveTopViewType)type button:(UIButton *)button;

@end

@interface EVHVLiveTopView : UIView

@property (nonatomic, weak) id<EVHVLiveTopViewDelegate> delegate;

@end
