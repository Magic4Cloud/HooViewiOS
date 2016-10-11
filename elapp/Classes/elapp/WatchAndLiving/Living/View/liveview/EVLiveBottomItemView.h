//
//  EVLiveBottomItemView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVControllerContacter.h"

typedef NS_ENUM(NSInteger, CCLiveBottomLeftItemType)
{
    CCLiveBottomShareItem,//分享
    CCLivebottomFaceItem,//美颜
    CCLiveBottomMuteItem,
    CCLiveBottomToRightItem,
    CCLiveBottomFlashItem,
    CCLiveBottomPlayerItem
};

typedef NS_ENUM(NSInteger, CCLiveBottomRightItemType)
{
    CCLiveBottomToLeftItem = 10,//隐藏
    CCLiveBottomChatItem,//聊天
    CCLiveBottomSendRedPacketItem,//红包
    CCLivebottomCameraItem,//摄像头
};

@protocol CCLiveBottomItemViewDelegate <NSObject>

/**
 *  @author shizhiang, 16-02-27 14:02:15
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
@property ( nonatomic, weak ) id<CCLiveBottomItemViewDelegate> delegate;

/** 发红包按钮 */
@property ( nonatomic, weak ) UIButton *sendRedPacketBtn;

/** 静音按钮 */
@property ( nonatomic, weak, readonly ) UIButton *muteButton;

/** 美颜按钮 */
@property (nonatomic,weak)UIButton *faceButton;

/** 切换摄像头按钮 */
@property (nonatomic,weak)UIButton *cameraButton;

/* 闪光按钮 */
@property (nonatomic,weak)UIButton *flashButton;

@property (nonatomic, weak) UIButton *playerButton;

@property (strong, nonatomic ) NSLayoutConstraint *cameraButtonConstraint;

/* 分享巨右侧距离 */
@property (strong, nonatomic) NSLayoutConstraint *shareButtonConstraint;

@property (strong, nonatomic) NSLayoutConstraint *faceButtonConstraint;



@property (nonatomic,assign) float ImageWid;

@end
