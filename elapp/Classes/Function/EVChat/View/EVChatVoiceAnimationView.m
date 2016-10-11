//
//  EVChatVoiceAnimationView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatVoiceAnimationView.h"
#import <PureLayout.h>
#import "EMCDDeviceManager.h"

#define TITLE_SLIDE     kE_GlobalZH(@"release_finger_not_send")
#define TITLE_PRESS     kE_GlobalZH(@"slide_finger_not_send")

#define IMAGE_W         77
#define IMAGE_H         73

#define CCVoiceImage(i) [NSString stringWithFormat:@"chatroom_voice%d",(i)]

@interface EVChatVoiceAnimationView ()

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIImageView *animtaionView;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation EVChatVoiceAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
       
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:0.6];
    self.layer.cornerRadius = 4;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = TITLE_PRESS;
    [titleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
    
    UIImageView *animtaionView = [[UIImageView alloc] init];
    [self addSubview:animtaionView];
    animtaionView.image = [UIImage imageNamed:@"chatroom_voice1"];
    [animtaionView autoSetDimensionsToSize:CGSizeMake(IMAGE_W, IMAGE_H)];
    [animtaionView autoAlignAxis:ALAxisVertical toSameAxisOfView:titleLabel];
    [animtaionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:titleLabel withOffset:-22];
    self.animtaionView = animtaionView;
}

- (void)setState:(CCChatVoiceAnimationViewState)state
{
    if ( _state != state )
    {
        _state = state;
        
        if ( state == CCChatVoiceAnimationViewHidden )
        {
            self.hidden = YES;
            return;
        }
        self.hidden = NO;
        self.titleLabel.text = (state == CCChatVoiceAnimationViewHoldOn) ? TITLE_PRESS : TITLE_SLIDE;
        self.titleLabel.textColor = (state == CCChatVoiceAnimationViewHoldOn) ? [UIColor whiteColor] : CCAppMainColor;
        
        self.animtaionView.image = (state == CCChatVoiceAnimationViewHoldOn) ? [UIImage imageNamed:CCVoiceImage(1)] : [UIImage imageNamed:@"chatroom_voice_back"];
        
        if ( state == CCChatVoiceAnimationViewHoldOn )
        {
            [self startListenerVoiceRate];
        }
        else
        {
            [self stopListenerVoiceRate];
        }
        
    }
}

- (void)dismiss
{
    [self.animtaionView stopAnimating];
    self.hidden = YES;
}

- (void)startListenerVoiceRate
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
}

- (void)stopListenerVoiceRate
{
    [_timer invalidate];
    _timer = nil;
}

- (void)updateImage
{
    if ( self.state != CCChatVoiceAnimationViewHoldOn )
    {
        return;
    }
    self.animtaionView.image = [UIImage imageNamed:CCVoiceImage(1)];
    
    double voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    
    NSInteger rate = (voiceSound / 0.125 + 2);
    rate = rate > 8 ? 8 : rate;
    
    self.animtaionView.image = [UIImage imageNamed:CCVoiceImage(rate)];
    
}

@end
