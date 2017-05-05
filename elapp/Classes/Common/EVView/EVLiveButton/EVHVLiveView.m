//
//  EVHVLiveView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVLiveView.h"


@interface EVHVLiveView ()

@property (nonatomic, weak) UIButton *liveButton;

@property (nonatomic, weak) UIButton *videoButton;

@property (nonatomic, weak) UIButton *picButton;

@property (nonatomic, weak) NSLayoutConstraint *liveWid;
@property (nonatomic, weak) NSLayoutConstraint *liveHig;

@property (nonatomic, weak) NSLayoutConstraint *videoWid;
@property (nonatomic, weak) NSLayoutConstraint *VideoHig;

@property (nonatomic, weak) NSLayoutConstraint *picWid;
@property (nonatomic, weak) NSLayoutConstraint *picHig;

@end

@implementation EVHVLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIButton *liveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:liveButton];
    liveButton.tag = EVLiveButtonTypeLive;
    self.liveButton = liveButton;
    [liveButton setImage:[UIImage imageNamed:@"btn_launch_n"] forState:(UIControlStateNormal)];
    [liveButton setImage:[UIImage imageNamed:@"btn_cancel_n"] forState:(UIControlStateSelected)];
    [liveButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [liveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [liveButton autoSetDimensionsToSize:CGSizeMake(44, 44)];
//    self.liveWid  =  [liveButton autoSetDimension:ALDimensionWidth toSize:44];
//    self.liveHig =    [liveButton autoSetDimension:ALDimensionHeight toSize:44];
    
    UIButton *videoButton =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:videoButton];
    self.videoButton = videoButton;
    videoButton.tag = EVLiveButtonTypeVideo;
    [videoButton setImage:[UIImage imageNamed:@"btn_vedio_n"] forState:(UIControlStateNormal)];
    [videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [videoButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [videoButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    self.videoWid =   [videoButton autoSetDimension:ALDimensionWidth toSize:0];
    self.VideoHig =   [videoButton autoSetDimension:ALDimensionHeight toSize:0];
    
    UIButton *picButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:picButton];
    self.picButton = picButton;
    picButton.tag = EVLiveButtonTypePic;
    [picButton setImage:[UIImage imageNamed:@"btn_word_n"] forState:(UIControlStateNormal)];
    [picButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [picButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [picButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    self.picWid =   [picButton autoSetDimension:ALDimensionWidth toSize:0];
    self.picHig =   [picButton autoSetDimension:ALDimensionHeight toSize:0];
}


- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == EVLiveButtonTypeLive) {
        
        
        
        
         btn.selected = !btn.selected;
    }
    if (self.buttonBlock) {
        self.buttonBlock(btn.tag,btn);
    }
    if (btn.tag == EVLiveButtonTypeLive) {
        if (btn.selected == YES) {
            self.videoWid.constant = 44;
            self.VideoHig.constant = 44;
            self.picWid.constant = 44;
            self.picHig.constant = 44;
        }else {
            self.videoWid.constant = 0;
            self.VideoHig.constant = 0;
            self.picWid.constant = 0;
            self.picHig.constant = 0;
        }
    }
    
}
@end
