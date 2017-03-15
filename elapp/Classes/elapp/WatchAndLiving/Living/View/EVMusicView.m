//
//  EVMusicView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/11/14.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMusicView.h"
#import <PureLayout.h>


#define kItemWidth    50

@interface EVMusicView ()
@property ( nonatomic, strong ) UIWindow *containerWindow;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *playButton;
@end

@implementation EVMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIWindow *containerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containerWindow.backgroundColor = [UIColor clearColor];
    [containerWindow makeKeyAndVisible];
    self.containerWindow = containerWindow;
    containerWindow.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover)];
    self.tap = tap;
    [containerWindow addGestureRecognizer:tap];
    

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 100)];
    self.contentView.backgroundColor = [UIColor evBackgroundColor];
    [containerWindow addSubview:self.contentView];
    
    UIButton *playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:playButton];
    self.playButton = playButton;
    
    UIButton *stopButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:stopButton];
    
    
    NSArray *items = @[playButton,stopButton];
    
    NSArray *titleItems = @[@"播放",@"停止"];
  
    
    [items autoSetViewsDimensionsToSize:CGSizeMake(kItemWidth, kItemWidth)];
    
    [playButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView withOffset:- (kItemWidth+10)];
    [playButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    
    [stopButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    [stopButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView withOffset:(kItemWidth+10)];

    for (NSInteger i = 0; i < titleItems.count; i++) {
        UIButton *button = items[i];
        [button setTitle:titleItems[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
        button.backgroundColor = [UIColor evMainColor];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(touchButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
}

- (void)hideCover
{
    self.hidden = YES;
    self.containerWindow.hidden = YES;
    
}

- (void)showCover
{
    self.containerWindow.hidden = NO;
    self.hidden = NO;
    
}
- (void)touchButton:(UIButton *)btn
{
     MusicButtonType type = 1000;
    if ([btn.titleLabel.text isEqualToString:@"播放"]) {
        type = MusicButtonTypePlay;
        [btn setTitle:@"暂停" forState:(UIControlStateNormal)];
    }else if ([btn.titleLabel.text isEqualToString:@"暂停"]){
        type = MusicButtonTypePause;
        [btn setTitle:@"继续" forState:(UIControlStateNormal)];
    }else if ([btn.titleLabel.text isEqualToString:@"继续"]) {
        type = MusicButtonTypeResume;
        [btn setTitle:@"暂停" forState:(UIControlStateNormal)];
    }else if ([btn.titleLabel.text isEqualToString:@"停止"]) {
        type = MusicButtonTypeStop;
        [btn setTitle:@"停止" forState:(UIControlStateNormal)];
        [self.playButton setTitle:@"播放" forState:(UIControlStateNormal)];
            
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchMusicButton:button:)]) {
        [self.delegate touchMusicButton:type button:btn];
    }
}

- (void)dealloc
{
    [self.containerWindow resignKeyWindow];
}

@end
