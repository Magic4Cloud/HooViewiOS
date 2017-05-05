//
//  EVHVWatchBottomView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHVGiftAniView.h"

@class EVHVChatView,EVNotOpenView,EVHVWatchStockView,EVHVVideoCommentView;
@protocol EVHVWatchBottomViewDelegate <NSObject>

- (void)scrollViewDidSeletedIndex:(NSInteger)index;

@end


@interface EVHVWatchBottomView : UIView

//- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray watchInfo:(EVWatchVideoInfo*)watchInfo;

@property (nonatomic, weak) id<EVHVWatchBottomViewDelegate> delagate;
@property (nonatomic, assign) NSInteger isLiving;
@property (nonatomic, strong) EVHVChatView *chatView;//聊天的view

@property (nonatomic, strong) EVHVVideoCommentView *videoCommentView;//视频的view

@property (nonatomic, strong) EVHVGiftAniView *giftAniView;

@property (nonatomic, weak) EVNotOpenView *notOpenView;

@property (nonatomic, weak) EVHVWatchStockView *watchStockView;


@end
