//
//  EVWatchBottomItemView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import <UIKit/UIKit.h>

/** 观看页底部按钮 */
typedef NS_ENUM(NSInteger, EVWatchBottomItem) {
    EVWatchBottomItemChat,      // 聊天
    EVWatchBottomItemTimeLine,  // 回放
    EVWatchBottomItemShare,     // 分享
    EVWatchBottomItemGif,       // 礼物
    EVWatchBottomItemLike,      // 点赞
    EVWatchBottomItemlink,
};

@protocol EVWatchBottomItemViewDelegate <NSObject>

- (void)watchBottomViewBtnClick:(UIButton *)button;

@end

@interface EVWatchBottomItemView : UIView

/** 代理 */
@property ( nonatomic, weak ) id<EVWatchBottomItemViewDelegate> delegate;

/** 回放时间轴显示按钮 */
@property ( nonatomic, weak, readonly ) UIButton *timeLineButton;

/** 聊天按钮 */
@property ( nonatomic, weak, readonly ) UIButton *chatButton;

/** 礼物 */
@property ( nonatomic, weak, readonly ) UIButton *giftButtton;

/** 分享 */
@property ( nonatomic, weak, readonly ) UIButton *shareButton;

@property ( nonatomic, weak, readonly ) UIButton *linkButton;

@property ( nonatomic, weak ) NSLayoutConstraint *timeLineConstraint;  // 等级左边约束


- (void)hiddenLeftBtn:(BOOL)hidden;

@end
