//
//  EVLiveBottomItemView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVControllerContacter.h"

typedef NS_ENUM(NSInteger, EVLiveBottomLeftItemType)
{
    EVLiveBottomShareItem,//分享
    EVLivebottomFaceItem,//美颜
    EVLiveBottomMuteItem,
    EVLiveBottomToRightItem,
    EVLiveBottomFlashItem,
    EVLiveBottomPlayerItem,
    EVLiveBottomLinkItem
};

typedef NS_ENUM(NSInteger, EVLiveBottomRightItemType)
{
    EVLiveBottomToLeftItem = 10,//隐藏
    EVLiveBottomChatItem,//聊天
    EVLiveBottomSendRedPacketItem,//红包
    EVLivebottomCameraItem,//摄像头
};

@protocol EVLiveBottomItemViewDelegate <NSObject>

/**
 *
 *  直播下面的按钮时间
 *
 *  @param button 被点击的按钮
 */
- (void)liveBottomItemViewButtonClick:(UIButton *)button;

@end

@interface EVLiveBottomItemView : UIView

//数据连接类
@property (nonatomic, strong) EVControllerContacter *contacter;
/** 代理 */
@property ( nonatomic, weak ) id<EVLiveBottomItemViewDelegate> delegate;

/** 发红包按钮 */
@property ( nonatomic, weak ) UIButton *sendRedPacketBtn;

/** 静音按钮 */
@property ( nonatomic, weak, readonly ) UIButton *muteButton;

/** 美颜按钮 */
@property (nonatomic, weak) UIButton *faceButton;

/** 切换摄像头按钮 */
@property (nonatomic, weak) UIButton *cameraButton;

/* 闪光按钮 */
@property (nonatomic, weak) UIButton *flashButton;

@property (nonatomic, weak) UIButton *playerButton;

@property (nonatomic, weak) UIButton *linkButton;

@property (strong, nonatomic ) NSLayoutConstraint *cameraButtonConstraint;

/* 分享巨右侧距离 */
@property (strong, nonatomic) NSLayoutConstraint *shareButtonConstraint;

@property (strong, nonatomic) NSLayoutConstraint *faceButtonConstraint;



@property (nonatomic,assign) float ImageWid;

@end
