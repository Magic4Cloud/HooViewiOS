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
typedef NS_ENUM(NSInteger, EVWatchBottomItem) {
    EVWatchBottomItemChat,      // 聊天
    EVWatchBottomItemTimeLine,  // 回放
    EVWatchBottomItemShare,     // 分享
    EVWatchBottomItemGif,       // 礼物
    EVWatchBottomItemLike       // 点赞
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
@property (weak, nonatomic) UILabel *processingTimeLbl;  /**< 当前播放的时长 */
@property (weak, nonatomic) UILabel *videoTimeLbl;  //播放的总时长

@end

@implementation EVRecordControlView

- (void)setUp
{
    
    EVControlSlider *slider = [[EVControlSlider alloc] init]	;
    [slider addTarget:self action:@selector(sliderTouchIn) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(sliderTouchOut) forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(valueChage) forControlEvents:UIControlEventValueChanged];
    slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#ffffff" alpha:.7f];
    slider.minimumTrackTintColor = [UIColor evMainColor];
    [slider setThumbImage:[UIImage imageNamed:@"living_icon_timeline"] forState:UIControlStateNormal];
    slider.maximumValue = 1000000;
    [slider.layer setShadowColor:[UIColor blackColor].CGColor];
    [slider.layer setShadowOffset:CGSizeMake(0, 1)];
    [slider.layer setShadowOpacity:0.6];//不透明度。0为全透明。
    [slider.layer setShadowRadius:1];
    slider.layer.masksToBounds = YES;
    [self insertSubview:slider belowSubview:self];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [slider autoSetDimension:ALDimensionHeight toSize:43];
    [slider autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100];
    self.slider = slider;
    

    
    // 当前播放时间进度显示
    CGFloat LblFontSize = 14.0f;
    UILabel *processingTimeLbl = [[UILabel alloc] init];
    processingTimeLbl.textColor = [UIColor whiteColor];
    processingTimeLbl.textAlignment = NSTextAlignmentLeft;
    processingTimeLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:LblFontSize];
    processingTimeLbl.font = [UIFont systemFontOfSize:LblFontSize];
    [self addSubview:processingTimeLbl];
    processingTimeLbl.text = @"--:--";
    [processingTimeLbl autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:slider withOffset:-10];
    [processingTimeLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:slider];
    [processingTimeLbl autoSetDimension:ALDimensionHeight toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    [processingTimeLbl autoSetDimension:ALDimensionWidth toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    self.processingTimeLbl = processingTimeLbl;
    self.processingTimeLbl.hidden = NO;
    
    
    // 当前播放视频的总时长
    UILabel *videoTimeLbl = [[UILabel alloc] init];
    videoTimeLbl.textColor = [UIColor whiteColor];
    videoTimeLbl.textAlignment = NSTextAlignmentLeft;
    videoTimeLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:LblFontSize];
    videoTimeLbl.font = [UIFont systemFontOfSize:LblFontSize];
    [self addSubview:videoTimeLbl];
    videoTimeLbl.text = @"--:--";
    [videoTimeLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:slider withOffset:10];
    [videoTimeLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:slider];
    [videoTimeLbl autoSetDimension:ALDimensionHeight toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    [videoTimeLbl autoSetDimension:ALDimensionWidth toSize:LblFontSize relation:NSLayoutRelationGreaterThanOrEqual];
    self.videoTimeLbl = videoTimeLbl;
    self.videoTimeLbl.hidden = NO;
    
    
}

- (void)valueChage
{
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
        self.videoTimeLbl.text = [NSString stringWithFormat:@"%@",maxStr];
        self.processingTimeLbl.text = [NSString stringWithFormat:@"%@",processingStr];
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
    [self updatingProcessingTime];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutIfNeeded];
}


@end
