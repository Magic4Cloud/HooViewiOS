//
//  EVLiveBottomItemView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveBottomItemView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVLiveEvents.h"

@interface EVLiveBottomItemView ()

/** 左边的容器 */
@property ( nonatomic, weak ) UIView *leftView;

/** 右边的容器 */
@property ( nonatomic, weak ) UIView *rightView;

/** 右边距离右边的约束 */
@property ( nonatomic, weak ) NSLayoutConstraint *rightViewRightConstraint;

@end

@implementation EVLiveBottomItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger tag = button.tag;
    switch (tag) {
        case CCLivebottomCameraItem:
        {
            self.cameraButton.selected = !self.cameraButton.selected;
            self.flashButton.highlighted = self.cameraButton.selected;
            self.flashButton.userInteractionEnabled = !self.cameraButton.selected;
            CCLog(@"user interaction enable = %d", self.flashButton.userInteractionEnabled);
        }
            break;
        case CCLiveBottomFlashItem:
        {
            self.cameraButton.userInteractionEnabled = self.flashButton.selected;
            self.flashButton.selected = !self.flashButton.selected;
            [self.contacter boardCastEvent:EVLiveToggleFlashLightButtonDidClicked withParams:nil];
        }
            break;
        default:
            break;
    }
    if ( tag == CCLiveBottomToRightItem )
    {
        self.rightViewRightConstraint.constant = -10;
    }
    else if ( tag == CCLiveBottomToLeftItem )
    {
        self.rightViewRightConstraint.constant = DEVICEWIDTH - 10;
    }
    else if (tag == CCLivebottomFaceItem)
    {
        button.selected = !button.selected;
        if ( self.delegate && [self.delegate respondsToSelector:@selector(liveBottomItemViewButtonClick:)] )
        {
            [self.delegate liveBottomItemViewButtonClick:button];
        }
    }
    else if (tag == CCLiveBottomPlayerItem) {
         button.selected = !button.selected;
        if ( self.delegate && [self.delegate respondsToSelector:@selector(liveBottomItemViewButtonClick:)] )
        {
            [self.delegate liveBottomItemViewButtonClick:button];
        }
    }
    else
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(liveBottomItemViewButtonClick:)] )
        {
            [self.delegate liveBottomItemViewButtonClick:button];
        }
    }
   
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)addRightView
{
    // 右边
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor clearColor];
    [self addSubview:rightView];
    self.rightView = rightView;
    [rightView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [rightView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.rightViewRightConstraint = [rightView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [rightView autoSetDimension:ALDimensionWidth toSize:DEVICEWIDTH - 20];
    
    // 向左
    UIButton *toLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toLeftButton setImage:[UIImage imageNamed:@"living_icon_more"] forState:UIControlStateNormal];
    toLeftButton.tag = CCLiveBottomToLeftItem;
    [toLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:toLeftButton];
    [toLeftButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    
    // 聊天
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatButton setImage:[UIImage imageNamed:@"living_icon_talk"] forState:UIControlStateNormal];
    chatButton.tag = CCLiveBottomChatItem;
    [chatButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:chatButton];
    [chatButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toLeftButton withOffset:10];
    
   
    // adapt hidden by 佳南
    // 发红包
    UIButton *sendRedPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendRedPacketBtn setImage:[UIImage imageNamed:@"living_icon_redpacket"] forState:UIControlStateNormal];
    sendRedPacketBtn.tag = CCLiveBottomSendRedPacketItem;
    [sendRedPacketBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:sendRedPacketBtn];
    [sendRedPacketBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    _sendRedPacketBtn = sendRedPacketBtn;
    _sendRedPacketBtn.hidden = sendRedPacketBtn.hidden = YES;
    self.ImageWid = sendRedPacketBtn.imageView.image.size.width;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"living_icon_share"] forState:UIControlStateNormal];
    shareButton.tag = CCLiveBottomShareItem;
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareButton];
    [shareButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:rightView withOffset:-(10 + self.ImageWid)];
   
    
    
    /** 摄像头切换 */
    UIButton *cameraButton = [[UIButton alloc] init];
    cameraButton.tag = CCLivebottomCameraItem;
    [cameraButton setImage:[UIImage imageNamed:@"living_icon_change"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightView addSubview:cameraButton];
    self.cameraButton = cameraButton;
    [cameraButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:rightView withOffset:-(20+self.ImageWid * 2)];
    self.cameraButton = cameraButton;
    
   
    // 分享

    
    // 美颜按钮 ios8 以上才会支持美颜
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setImage:[UIImage imageNamed:@"living_icon_beauty_close"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"living_icon_beauty"] forState:UIControlStateSelected];
    faceButton.tag = CCLivebottomFaceItem;
    faceButton.selected = YES;
    [rightView addSubview:faceButton];
    [faceButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    if ( !([NSString isBeautyFaceAvailable] && IOS8_OR_LATER))
    {
        faceButton.hidden = YES;
    }
    self.faceButton = faceButton;
    self.shareButtonConstraint =  [faceButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:rightView withOffset:-(10 * 3 + self.ImageWid * 3)];
    
    
    // 美颜按钮 ios8 以上才会支持美颜
    UIButton *playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playerButton setTitle:@"开始" forState:(UIControlStateNormal)];
    [playerButton setTitle:@"停止" forState:(UIControlStateSelected)];
    [playerButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    playerButton.tag = CCLiveBottomPlayerItem;
    playerButton.selected = NO;
    [rightView addSubview:playerButton];
    self.playerButton = playerButton;
    _playerButton.hidden = playerButton.hidden = YES;
    [playerButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
  
//    self.faceButton = faceButton;
    self.shareButtonConstraint =  [playerButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:rightView withOffset:-(10 * 4 + self.ImageWid * 4)];
    
    [@[toLeftButton,cameraButton,sendRedPacketBtn,shareButton,chatButton, faceButton,playerButton]autoAlignViewsToAxis:ALAxisHorizontal];
}

- (void)addLeftView
{
    // 左边
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    leftView.layer.cornerRadius = 34.f / 2.f;
    [self addSubview:leftView];
    self.leftView = leftView;
    [leftView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.rightView];
    [leftView autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 20];
    [leftView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightView withOffset:-20];
    
    // 向右
    UIButton *toRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toRightButton setImage:[UIImage imageNamed:@"living_icon_packup"] forState:UIControlStateNormal];
    toRightButton.tag = CCLiveBottomToRightItem;
    [toRightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:toRightButton];
    [toRightButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    
    
    // 静音
    UIButton *muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [muteButton setImage:[UIImage imageNamed:@"living_icon_mute"] forState:UIControlStateNormal];
    [muteButton setImage:[UIImage imageNamed:@"living_icon_mute_on"] forState:UIControlStateSelected];
    _muteButton = muteButton;
    muteButton.tag = CCLiveBottomMuteItem;
    [muteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:muteButton];
    [muteButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:leftView withOffset:34];
    [muteButton autoSetDimension:ALDimensionWidth toSize:ScreenWidth/2-20-34];
    
    // 闪光
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setImage:[UIImage imageNamed:@"living_icon_flash"] forState:UIControlStateNormal];
    [flashButton setImage:[UIImage imageNamed:@"living_icon_flash_close"] forState:UIControlStateSelected];
    [flashButton setImage:[UIImage imageNamed:@"living_icon_flash_nor"] forState:UIControlStateHighlighted];
    flashButton.tag = CCLiveBottomFlashItem;
    [flashButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:flashButton];
    self.flashButton = flashButton;
    [flashButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:toRightButton];
    [flashButton autoSetDimension:ALDimensionWidth toSize:ScreenWidth/2-20-34];
    
   
    [@[toRightButton, muteButton, flashButton] autoAlignViewsToAxis:ALAxisHorizontal];
}

- (void)setUI
{
    [self addRightView];
    [self addLeftView];
}

@end
