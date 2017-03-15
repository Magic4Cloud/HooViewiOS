//
//  EVLiveAnchorSendRedPacketView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVLiveAnchorSendRedPacketView;

@protocol CCLiveAnchorSendRedPacketViewDelegate <NSObject>

/**
 *
 *  直播过程中主播发红包
 *
 *  @param sendPacketView 填写红包信息的视图
 *  @param packets        抢红包的人数
 *  @param ecoins         发送的金额
 *  @param greetings      祝福语
 */
- (void)liveAnchorSendPacketViewView:(EVLiveAnchorSendRedPacketView *)sendPacketView
                             packets:(NSInteger)packets
                              ecoins:(NSInteger)ecoins
                           greetings:(NSString *)greetings;

@end

@interface EVLiveAnchorSendRedPacketView : UIView

/** 代理 */
@property ( nonatomic, weak ) id<CCLiveAnchorSendRedPacketViewDelegate> delegate;


@property (nonatomic, assign) long long anchorEcoinCount;
/**
 *
 *  显示发红包界面
 */
- (void)show;

/**
 *
 *  收起发红包界面
 */
- (void)dismiss;

@end
