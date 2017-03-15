//
//  EVLiveSlider.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVLiveSlider;

#define LIVE_SLIDER_HEIGHT 281
#define LIVE_SLIDER_WIDTH 36
#define LIVE_SLIDER_BUTTONWH 24

#define LIVE_SLIDER_MIN_VALUE       1.0
#define LIVE_SLIDER_MAX_VALUE       5.0
#define LIVE_SLIDER_VALUE_STEP      0.5

@protocol EVLiveSliderDelegate <NSObject>

@optional
- (void)liveSlider:(EVLiveSlider *)slider valueChanged:(CGFloat)value;

@end

@interface EVLiveSlider : UIView

@property (nonatomic,weak) id<EVLiveSliderDelegate> delegate;

@property (nonatomic, assign) CGFloat value;

- (void)showSlider;
- (void)hiddenSlider;

@end
