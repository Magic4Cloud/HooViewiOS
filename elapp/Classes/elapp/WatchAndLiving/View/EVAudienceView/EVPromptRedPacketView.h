//
//  EVPromptRedPacketView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//  文件说明：红包提示，在云票下面

#import <UIKit/UIKit.h>
@class EVRedEnvelopeItemModel;

@protocol CCPromptRedPacktViewDelegate <NSObject>

/**
 *  @author shizhiang, 16-03-17 20:03:20
 *
 *  展示红包
 *
 *  @param model 红包信息
 */
- (void)showRedPacktWithItem:(EVRedEnvelopeItemModel *)model;

@end

@interface EVPromptRedPacketView : UIView

@property ( nonatomic, weak ) id<CCPromptRedPacktViewDelegate> delegate;

/** 红包模型 */
@property ( nonatomic, strong ) EVRedEnvelopeItemModel *model;

/**
 *  @author shizhiang, 16-03-17 20:03:06
 *
 *  添加红包
 *
 *  @param model 红包信息
 */
- (void)pushRedPacket:(EVRedEnvelopeItemModel *)model;

@end
