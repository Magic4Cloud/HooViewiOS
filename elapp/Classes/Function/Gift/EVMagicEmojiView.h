//
//  EVMagicEmojiView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVMagicEmojiView, EVMagicEmojiModel, EVStartGoodModel;

@protocol CCMagicEmojiViewDelegate <NSObject>

@optional
/**
 *  切换魔法表情的种类
 *
 *  @param type 表情种类
 */
- (void)switchMagicEmojiKindMagicEmojiView:(EVMagicEmojiView *)magicEmojiView type:(CCPresentType)type;

/**
 *  发送魔法表情
 *
 *  @param magicEmoji 被发送的表情
 */
- (void)sendMagicEmojiWithEmoji:(EVStartGoodModel *)magicEmoji num:(NSInteger)numOfEmoji;

/** 薏米数不足 */
- (void)yimiNotEnough;

/** 云币数不足 */
- (void)yibiNotEnough;

/** 充值云币 */
- (void)rechargeYibi;

/**
 *  连发时候，发送礼物数量改变
 *
 *  @param number 礼物的连发数量
 */
- (void)changeSendAmountOfPresentsWithNumber:(NSInteger)number present:(EVStartGoodModel *)present;

/** 礼物视图隐藏 */
- (void)magicEmojiViewHidden;

/** 发送礼物 */
- (void)magicEmojiSend;

@end

@interface EVMagicEmojiView : UIView

+ (instancetype)magicEmojiViewToTargetView:(UIView *)targetView;

/** 魔法表情视图的代理属性，遵循代理需要实现两个代理方法 */
@property (nonatomic, assign) id<CCMagicEmojiViewDelegate> delegate;

/** 隐藏红包礼物 */
@property ( nonatomic ) BOOL noRedPacket;

/** 页面是否隐藏 */
@property (nonatomic, assign, readonly) BOOL hasHidden;

/** 薏米数 */
@property (nonatomic, assign) NSInteger barley;

/** 云币数 */
@property (nonatomic, assign) NSInteger ecoin;

/** 展示本视图 */
- (void)show;

/** 隐藏本视图 */
- (void)hide;

@end
