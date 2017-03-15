//
//  EVPromptRedPacketView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVRedEnvelopeItemModel;

@protocol CCPromptRedPacktViewDelegate <NSObject>

- (void)showRedPacktWithItem:(EVRedEnvelopeItemModel *)model;

@end

@interface EVPromptRedPacketView : UIView

@property ( nonatomic, weak ) id<CCPromptRedPacktViewDelegate> delegate;

/** 红包模型 */
@property ( nonatomic, strong ) EVRedEnvelopeItemModel *model;

/**
 *
 *  添加红包
 *
 *  @param model 红包信息
 */
- (void)pushRedPacket:(EVRedEnvelopeItemModel *)model;

@end
