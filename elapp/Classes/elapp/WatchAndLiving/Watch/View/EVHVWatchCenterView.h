//
//  EVHVWatchCenterView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"

typedef NS_ENUM(NSInteger, EVHVWatchCenterType) {
    EVHVWatchCenterTypeHeadImage,
    EVHVWatchCenterTypeFollow,
};

@protocol EVHVWatchCenterViewDelegate <NSObject>

- (void)watchCenterViewType:(EVHVWatchCenterType)type;

@end


@interface EVHVWatchCenterView : UIView

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, weak) id<EVHVWatchCenterViewDelegate> delegate;

@end
