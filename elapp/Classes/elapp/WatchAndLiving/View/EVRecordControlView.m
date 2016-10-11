//
//  EVRecordControlView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRecordControlView.h"
#import <PureLayout.h>

/** 观看页底部按钮 */
typedef NS_ENUM(NSInteger, CCWatchBottomItem) {
    CCWatchBottomItemChat,      // 聊天
    CCWatchBottomItemTimeLine,  // 回放
    CCWatchBottomItemShare,     // 分享
    CCWatchBottomItemGif,       // 礼物
    CCWatchBottomItemLike       // 点赞
};

@implementation EVControlSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _bufferProgressColor = [UIColor colorWithHexString:@"#9ac9ff"];
    }
    return self;
}

- (void)setBufferProgress:(CGFloat)bufferProgress
{
    if ( isnan(bufferProgress) )
    {
        return;
    }
    
    _bufferProgress = bufferProgress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // fix by 施志昂 配合服务器测试 让服务器给一个超大的数
    if( isnan(_bufferProgress) || isinf(_bufferProgress) )
    {
        return;
    }
    if (self.bufferProgress >= 0.985) {
        self.bufferProgress = 0.985;
    }
    CGRect re = [self trackRectForBounds:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(re.origin.x, re.origin.y, self.bufferProgress * rect.size.width, re.size.height) cornerRadius:0.5 * re.size.height];
    [_bufferProgressColor set];
    [path fill];
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * resultView = [super hitTest:point withEvent:event];
    if ( (point.y >= -10) && (point.y < (lastBounds.size.height + 10)) )
    {
        float value = 0;
        value = point.x - self.bounds.origin.x;
        value = value / self.bounds.size.width;
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return resultView;
}
@end

@interface EVRecordControlView ()

@property (nonatomic,weak) EVControlSlider *slider;
@property (nonatomic,weak) UIButton *pauseOrPlayButton;
@property (nonatomic, assign) BOOL sliderDrap;
@property (weak, nonatomic) UILabel *processingTimeLbl;  /**< 显示当前播放时间进度及总时长 */

@end

@implementation EVRecordControlView

- (void)setUp
{
    UIButton *pauseOrPlayButton = [[UIButton alloc] init];
    pauseOrPlayButton.tag = RECORD_BTN_PALY_OR_PAUSE;
    [pauseOrPlayButton setImage:[UIImage imageNamed:@"living_icon_pause"] forState:UIControlStateNormal];
    [pauseOrPlayButton setImage:[UIImage imageNamed:@"living_icon_play"] forState:UIControlStateSelected];
    [self addSubview:pauseOrPlayButton];
    [pauseOrPlayButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [pauseOrPlayButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    self.pauseOrPlayButton = pauseOrPlayButton;
    
    EVControlSlider *slider = [[EVControlSlider alloc] init]	;
    [slider addTarget:self action:@selector(sliderTouchIn) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(valueChage) forControlEvents:UIControlEventValueChanged];
    slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#ffffff" alpha:.6f];
    slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#0095ff"];
    [slider setThumbImage:[UIImage imageNamed:@"living_icon_timeline"] forState:UIControlStateNormal];
    slider.maximumValue = 1000000;
    [slider.layer setShadowColor:[UIColor blackColor].CGColor];
    [slider.layer setShadowOffset:CGSizeMake(0, 1)];
    [slider.layer setShadowOpacity:0.6];//不透明度。0为全透明。
    [slider.layer setShadowRadius:1];
    slider.layer.masksToBounds = YES;
    [self insertSubview:slider belowSubview:self.pauseOrPlayButton];
    [slider autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [slider autoSetDimension:ALDimensionHeight toSize:43];
    self.slider = slider;
    
    for (UIButton *item in self.subviews)
    {
        if ( [item isKindOfClass:[UIButton class]] )
        {
            [item addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    // 当前播放时间进度显示
    CGFloat LblFontSize = 14.0f;
    UILabel *processingTimeLbl = [[UILabel alloc] init];
    processingTimeLbl.textColor = [UIColor whiteColor];
    processingTimeLbl.textAlignment = NSTextAlignmentLeft;
    processingTimeLbl.font = [[CCAppSetting shareInstance] normalFontWithSize:LblFontSize];
    processingTimeLbl.font = [UIFont systemFontOfSize:LblFontSize];
    [self addSubview:processingTimeLbl];
    [processingTimeLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pauseOrPlayButton withOffset:10];
    [processingTimeLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.pauseOrPlayButton];
    [processingTimeLbl autoSetDimension:ALDimensionHeight toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    [processingTimeLbl autoSetDimension:ALDimensionWidth toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    self.processingTimeLbl = processingTimeLbl;
    self.processingTimeLbl.hidden = YES;
    
    // 礼物
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setImage:[UIImage imageNamed:@"living_icon_gif_more"] forState:UIControlStateNormal];
    _giftButtton = giftBtn;
    [giftBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.tag = CCWatchBottomItemGif;
    [self addSubview:giftBtn];
    [giftBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [giftBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.pauseOrPlayButton];
    
    // 分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"living_icon_share"] forState:UIControlStateNormal];
    _shareButton = shareBtn;
    [shareBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = CCWatchBottomItemShare;
    [self addSubview:shareBtn];
    [shareBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.pauseOrPlayButton];
    [shareBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:giftBtn withOffset:-10];
    
}

- (void)watchBottomBtnClick:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(watchBottomViewBtnClick:)] )
    {
        [self.delegate watchBottomViewBtnClick:button];
    }
}

- (void)valueChage
{
    CCLog(@"valueChage -- %f",self.slider.value);
    [self updatingProcessingTime];
}

- (void)sliderTouchIn
{
    CCLog(@"sliderTouchIn");
    self.sliderDrap = YES;
    if ( [self.delegate respondsToSelector:@selector(recordInfoViewDidBeginDrag:)] )
    {
        [self.delegate recordInfoViewDidBeginDrag:self];
    }
}

- (void)sliderTouchOut
{
    self.sliderDrap = NO;
    CGFloat value = self.slider.value;
    
    if ( [self.delegate respondsToSelector:@selector(recordInfoViewDidDragToNewProgress:)] )
    {
        [self.delegate recordInfoViewDidDragToNewProgress:value];
    }
}

- (void)buttonDidClicked:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(recordInfoView:didClickButton:)] )
    {
        [self.delegate recordInfoView:self didClickButton:button];
    }
}

/**
 *  更新当前播放时间进度
 */
- (void)updatingProcessingTime
{
    NSInteger processingTime = self.slider.value;
    NSInteger maxValue = self.slider.maximumValue;

    if ( maxValue == 1000000 )
    {
        self.processingTimeLbl.hidden = YES;
    }
    else
    {
        NSString *processingStr = [self convertToMinuteString:processingTime];
        NSString *maxStr = [self convertToMinuteString:maxValue];
        self.processingTimeLbl.text = [NSString stringWithFormat:@"%@/%@",processingStr,maxStr];
        self.processingTimeLbl.hidden = NO;
    }
}

#pragma mark - helper
- (UILabel *)addShadowForLabel:(UILabel *)targetLab {
    [targetLab.layer setShadowColor:[UIColor blackColor].CGColor];
    [targetLab.layer setShadowOffset:CGSizeMake(0, 1)];
    [targetLab.layer setShadowOpacity:0.6];
    [targetLab.layer setShadowRadius:1];
    [targetLab.layer setMasksToBounds:YES];
    return targetLab;
}


- (NSString *)convertToMinuteString:(NSInteger)sec {
    if (sec <= 0) {
        return @"00:00";
    } else {
        NSInteger seconds;
        NSInteger minutes;
        if (sec < 3600) {
            seconds = sec % 60;
            minutes = (sec / 60) % 60;
        } else {
            seconds = sec % 60;
            minutes = sec / 60;
        }
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
}

#pragma mark - setter method
- (void)setPause:(BOOL)pause
{
    _pause = pause;
    self.pauseOrPlayButton.userInteractionEnabled = YES;
    self.pauseOrPlayButton.selected = pause;
    CCLog(@"play button did change state - %@", (pause ? @"pause": @"playing"));
}

- (void)setBufferProgress:(CGFloat)bufferProgress
{
    _bufferProgress = bufferProgress;
    self.slider.bufferProgress = bufferProgress / self.maxProgress;
}

- (void)setMaxProgress:(CGFloat)maxProgress
{
    _maxProgress = maxProgress;
    self.slider.maximumValue = maxProgress;
}

- (void)setCurrProgress:(CGFloat)currProgress
{
    _currProgress = currProgress;
    
    self.slider.value = currProgress;
    [self updatingProcessingTime];
}


@end
