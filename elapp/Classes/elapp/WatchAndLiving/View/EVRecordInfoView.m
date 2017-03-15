//
//  EVRecordInfoView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRecordInfoView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "UIView+Extension.h"

#define buttonWH 47

@implementation EVBufferSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _bufferProgressColor = [UIColor colorWithHexString:[EVAppSetting shareInstance].appMainColorString alpha:0.5];
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
    if( isnan(_bufferProgress) || isinf(_bufferProgress) )
    {
        return;
    }
    
    CGRect re = [self trackRectForBounds:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(re.origin.x, re.origin.y, self.bufferProgress * rect.size.width, re.size.height) cornerRadius:0.5 * re.size.height];
     [_bufferProgressColor set];
    [path fill];
}

@end

@interface EVRecordInfoView ()

@property (nonatomic,weak) UIView *cover;
@property (nonatomic,weak) EVBufferSlider *slider;
@property (nonatomic,weak) UIButton *pauseOrPlayButton;
@property (nonatomic, assign) BOOL sliderDrap;
@property (weak, nonatomic) UILabel *remainingTimeLbl;  /**< 显示剩余时长 */
@property (weak, nonatomic) UILabel *processingTimeLbl;  /**< 显示当前播放时间进度 */
@property (nonatomic, assign) BOOL hasHidden;

@end

@implementation EVRecordInfoView

- (void)dealloc
{
    EVLog(@"CCRecordInfoView dealloc");
}

+ (instancetype)recordInfoViewToSuperView:(UIView *)view height:(CGFloat)height
{
    UIView *cover = [[UIView alloc] init];
    cover.hidden = YES;
    cover.backgroundColor = [UIColor clearColor];
    [view addSubview:cover];
    [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    EVRecordInfoView *recordView = [[EVRecordInfoView alloc] init];
    recordView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5f];
    [view addSubview:recordView];
    recordView.cover = cover;
    [recordView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:34.0f];
    [recordView autoSetDimension:ALDimensionHeight toSize:buttonWH];
    [recordView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [recordView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    recordView.layer.cornerRadius = buttonWH / 2.0;
    recordView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:recordView action:@selector(coverTap:)];
    recordView.hasHidden = YES;
    [cover addGestureRecognizer:tap];
    return recordView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)coverTap:(UITapGestureRecognizer *)tap
{
    tap.enabled = NO;
    [self scaleBoundceAnimationHiddenComplete:^{
        self.cover.hidden = YES;
        tap.enabled = YES;
        _hasHidden = YES;
        if ( [self.delegate respondsToSelector:@selector(recordInfoViewDidAutoHidden:)] )
        {
            [self.delegate recordInfoViewDidAutoHidden:self];
        }
    }];
}

- (void)showComplete:(void (^)())complete
{
    _hasHidden = NO;
    __weak typeof(self) wself = self;
    [self scaleBoundceAnimationShowImmediatelyComplete:^{
        wself.cover.hidden = NO;
    }];
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    
    CGSize buttonSize = CGSizeMake(buttonWH, buttonWH);
    
    UIButton *pauseOrPlayButton = [[UIButton alloc] init];
    pauseOrPlayButton.tag = RECORD_BTN_PALY_OR_PAUSE;
    [pauseOrPlayButton setImage:[UIImage imageNamed:@"living_icon_pause"] forState:UIControlStateNormal];
    [pauseOrPlayButton setImage:[UIImage imageNamed:@"living_icon_play"] forState:UIControlStateSelected];
    [pauseOrPlayButton autoSetDimensionsToSize:buttonSize];
    [self addSubview:pauseOrPlayButton];
    [pauseOrPlayButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [pauseOrPlayButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    self.pauseOrPlayButton = pauseOrPlayButton;
    
    EVBufferSlider *slider = [[EVBufferSlider alloc] init];
    [slider addTarget:self action:@selector(sliderTouchIn) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(valueChage) forControlEvents:UIControlEventValueChanged];
    slider.maximumTrackTintColor = CCARGBColor(0, 0, 0, 0.5);
    slider.minimumTrackTintColor = [UIColor evMainColor];
    [slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self addSubview:slider];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:buttonWH / 2.0f];
    [slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:pauseOrPlayButton withOffset:- buttonWH / 2.0f * (2 / 3.0f)];
    [slider autoAlignAxis:ALAxisHorizontal toSameAxisOfView:pauseOrPlayButton];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    self.slider = slider;
    
    for (UIButton *item in self.subviews)
    {
        if ( [item isKindOfClass:[UIButton class]] )
        {
            [item addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 剩余时长的显示
    CGFloat LblFontSize = 10.0f;
    CGFloat LblBottomEdge = (buttonWH / 2.0f - LblFontSize) / 2.0f - 1.5f;
    UILabel *remainingTimeLbl = [[UILabel alloc] init];
    remainingTimeLbl.textColor = [UIColor whiteColor];
    remainingTimeLbl.textAlignment = NSTextAlignmentRight;
    remainingTimeLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:LblFontSize];
    [self addSubview:remainingTimeLbl];
    [remainingTimeLbl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:LblBottomEdge];
    [remainingTimeLbl autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.slider];
    [remainingTimeLbl autoSetDimension:ALDimensionHeight toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    [remainingTimeLbl autoSetDimension:ALDimensionWidth toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    self.remainingTimeLbl = remainingTimeLbl;
    
    // 当前播放时间进度显示
    UILabel *processingTimeLbl = [[UILabel alloc] init];
    processingTimeLbl.textColor = [UIColor whiteColor];
    processingTimeLbl.textAlignment = NSTextAlignmentLeft;
    processingTimeLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:LblFontSize];
    [self addSubview:processingTimeLbl];
    [processingTimeLbl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:LblBottomEdge];
    [processingTimeLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.slider];
    [processingTimeLbl autoSetDimension:ALDimensionHeight toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    [processingTimeLbl autoSetDimension:ALDimensionWidth toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    self.processingTimeLbl = processingTimeLbl;
}

- (void)valueChage
{
    EVLog(@"valueChage -- %f",self.slider.value);
    if ( [self.delegate respondsToSelector:@selector(recordInfoView:valueChaged:)] )
    {
        [self.delegate recordInfoView:self valueChaged:self.slider.value];
    }
    [self updatingRemainingTime];
    [self updatingProcessingTime];
}

- (void)sliderTouchIn
{
    EVLog(@"sliderTouchIn");
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
 *  更新视频剩余时间的值
 */
- (void)updatingRemainingTime
{
    double remainingTime = self.slider.maximumValue - self.slider.value;
    if ( remainingTime <= 0 )
    {
        self.remainingTimeLbl.text = @"00:00:00";
    }
    else
    {
        NSString *remaintimeStr = [NSString stringFormattedTimeFromSeconds:&(remainingTime)];
        self.remainingTimeLbl.text = remaintimeStr;
    }
}

/**
 *  更新当前播放时间进度
 */
- (void)updatingProcessingTime
{
    double processingTime = self.slider.value;
    double maxValue = self.slider.maximumValue;
    if ( processingTime <= 0 )
    {
        self.processingTimeLbl.text = @"--:--";
    }
    else if ( processingTime < self.slider.maximumValue )
    {
        self.processingTimeLbl.text = [NSString stringFormattedTimeFromSeconds:&(processingTime)];
    }
    else
    {
        self.processingTimeLbl.text = [NSString stringFormattedTimeFromSeconds:&(maxValue)];
    }
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

- (void)setPause:(BOOL)pause
{
    _pause = pause;
    self.pauseOrPlayButton.userInteractionEnabled = YES;
    self.pauseOrPlayButton.selected = pause;
    EVLog(@"play button did change state - %@", (pause ? @"pause": @"playing"));
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
    [self updatingRemainingTime];
    [self updatingProcessingTime];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{}

@end
