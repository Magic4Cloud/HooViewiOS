//
//  EVWatchBottomItemView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import <UIKit/UIKit.h>

/** 观看页底部按钮 */
typedef NS_ENUM(NSInteger, CCWatchBottomItem) {
    CCWatchBottomItemChat,      // 聊天
    CCWatchBottomItemTimeLine,  // 回放
    CCWatchBottomItemShare,     // 分享
    CCWatchBottomItemGif,       // 礼物
    CCWatchBottomItemLike,      // 点赞
};

@protocol CCWatchBottomItemViewDelegate <NSObject>

/**
 *  @author shizhiang, 16-02-27 12:02:43
 *
 *  点击按钮的回调
 *
 *  @param button 被点击的按钮
 */
- (void)watchBottomViewBtnClick:(UIButton *)button;

@end

@interface EVWatchBottomItemView : UIView

/** 代理 */
@property ( nonatomic, weak ) id<CCWatchBottomItemViewDelegate> delegate;

/** 回放时间轴显示按钮 */
@property ( nonatomic, weak, readonly ) UIButton *timeLineButton;

/** 聊天按钮 */
@property ( nonatomic, weak, readonly ) UIButton *chatButton;

/** 礼物 */
@property ( nonatomic, weak, readonly ) UIButton *giftButtton;

/** 分享 */
@property ( nonatomic, weak, readonly ) UIButton *shareButton;

@property ( nonatomic, weak ) NSLayoutConstraint *timeLineConstraint;  // 等级左边约束


/**
 *  @author shizhiang, 16-02-27 19:02:13
 *
 *  隐藏左边的button
 *
 *  @param hidden 是否隐藏
 */
- (void)hiddenLeftBtn:(BOOL)hidden;

@end
