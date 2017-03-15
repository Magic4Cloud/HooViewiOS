//
//  EVLiveSlider.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveSlider.h"
#import <PureLayout.h>
#import <DeviceUtil.h>



#define kAnimationTime 0.5

@interface EVLiveSlider ()

@property (nonatomic,weak) UISlider *slider;
@property (nonatomic, assign) BOOL sliderHoldOn;
@property (nonatomic, assign) BOOL needToHideSlider;

@end

@implementation EVLiveSlider

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
    CGFloat margin = 6;
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:[UIImage imageNamed:@"live_focus_origin"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderTouchDown) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(sliderTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    
    [self addSubview:slider];
    [slider autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [slider autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [slider autoSetDimensionsToSize:CGSizeMake(LIVE_SLIDER_HEIGHT, LIVE_SLIDER_WIDTH)];
    slider.minimumValue = LIVE_SLIDER_MIN_VALUE;
    slider.maximumValue = LIVE_SLIDER_MAX_VALUE;
    
    if ( [DeviceUtil hardware] <= IPHONE_4S )
    {
        slider.minimumValue = 0.0f;
        slider.maximumValue = 1.0f;
        slider.value = 0.0f;
    }
    
    slider.maximumTrackTintColor = [UIColor whiteColor];
    slider.minimumTrackTintColor = [UIColor evMainColor];
    self.slider = slider;
    
    UIButton *addButton = [[UIButton alloc] init];
    [self addSubview:addButton];
    [addButton setImage:[UIImage imageNamed:@"live_focus_add"] forState:UIControlStateNormal];
    [addButton autoSetDimensionsToSize:CGSizeMake(LIVE_SLIDER_WIDTH, LIVE_SLIDER_WIDTH)];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:slider withOffset:-margin];
    [addButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [addButton addTarget:self action:@selector(addValue) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reduceButton = [[UIButton alloc] init];
    reduceButton.backgroundColor = [UIColor clearColor];
    [self addSubview:reduceButton];
    [reduceButton setImage:[UIImage imageNamed:@"live_focus_less"] forState:UIControlStateNormal];
    [reduceButton autoSetDimensionsToSize:CGSizeMake(LIVE_SLIDER_WIDTH, LIVE_SLIDER_WIDTH)];
    [reduceButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [reduceButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:slider withOffset:margin];
    reduceButton.transform = CGAffineTransformRotate(reduceButton.transform, - M_PI * 0.5);
    
    [reduceButton addTarget:self action:@selector(reduceValue) forControlEvents:UIControlEventTouchUpInside];
    
    [slider addTarget:self action:@selector(valueChage:) forControlEvents:UIControlEventValueChanged];
}

- (void)showSlider
{
    self.needToHideSlider = NO;
    if ( self.alpha == 1.0 )
    {
        return;
    }
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hiddenSlider
{
    self.needToHideSlider = YES;
    if ( self.sliderHoldOn )
    {
        return;
    }
    if ( self.alpha == 0.0 )
    {
        return;
    }
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.alpha = 0.0;
    }];
}

- (void)addValue
{
    [self stepValue:LIVE_SLIDER_VALUE_STEP];
}

- (void)reduceValue
{
    [self stepValue:-LIVE_SLIDER_VALUE_STEP];
}

- (void)stepValue:(CGFloat)item
{
    CGFloat value = self.slider.value;
    value += item;
    
    if ( [DeviceUtil hardware] <= IPHONE_4S )
    {
        if ( value > 1.0f )
        {
            value = 1.0f;
        }
        else if ( value < 0.0f )
        {
            value = 0.0f;
        }
    }
    else
    {
        if ( value > LIVE_SLIDER_MAX_VALUE )
        {
            value = LIVE_SLIDER_MAX_VALUE;
        }
        else if ( value < LIVE_SLIDER_MIN_VALUE )
        {
            value = LIVE_SLIDER_MIN_VALUE;
        }
    }
    
    self.slider.value = value;
    [self valueChage:self.slider];
}

- (void)sliderTouchDown
{
    EVLog(@"sliderTouchDown");
    self.sliderHoldOn = YES;
}

- (void)sliderTouchUp
{
    EVLog(@"sliderTouchUp");
    self.sliderHoldOn = NO;
    if ( self.needToHideSlider )
    {
        [self hiddenSlider];
    }
}

- (void)valueChage:(UISlider *)slider
{
    if ( [DeviceUtil hardware] <= IPHONE_4S )
    {
        if ( slider.value > 1.0 || slider.value < 0 )
        {
            return;
        }
    }
    else
    {
        if ( slider.value < 1.0  )
        {
            return;
        }
    }
    
    if ( [self.delegate respondsToSelector:@selector(liveSlider:valueChanged:)] )
    {
        [self.delegate liveSlider:self valueChanged:slider.value];
    }
}

- (CGFloat)value
{
    return self.slider.value;
}

- (void)setValue:(CGFloat)value
{
//    if ( value > LIVE_SLIDER_MAX_VALUE )
//    {
//        value = LIVE_SLIDER_MAX_VALUE;
//    }
//    else if ( value < LIVE_SLIDER_MIN_VALUE )
//    {
//        value = LIVE_SLIDER_MIN_VALUE;
//    }
    
    if ( [DeviceUtil hardware] <= IPHONE_4S )
    {
        if ( value > 1.0f )
        {
            value = 1.0f;
        }
        else if ( value < 0.0f )
        {
            value = 0.0f;
        }
    }
    else
    {
        if ( value > LIVE_SLIDER_MAX_VALUE )
        {
            value = LIVE_SLIDER_MAX_VALUE;
        }
        else if ( value < LIVE_SLIDER_MIN_VALUE )
        {
            value = LIVE_SLIDER_MIN_VALUE;
        }
    }
    
    self.slider.value = value;
    [self valueChage:self.slider];
}


@end
