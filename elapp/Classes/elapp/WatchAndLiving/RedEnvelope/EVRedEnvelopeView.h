//
//  EVRedEnvelopeView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVRedEnvelopeModel.h"

typedef NS_ENUM(NSInteger, CCButtonTag) {
    CCButtonTag_Cancel = 1000,
    CCButtonTag_Chai,
    CCButtonTag_See
};

typedef NS_ENUM(NSInteger, CCViewTransitionStyle) {
    CCViewTransitionStyleSlideFromBottom = 0,
    CCViewTransitionStyleSlideFromTop,
    CCViewTransitionStyleFade,
    CCViewTransitionStyleBounce
};

@class EVRedEnvelopeView;
typedef void(^CCRedEnvelopeViewHandler)(EVRedEnvelopeView *redEnvelopeView);

@interface EVRedEnvelopeView : UIView

@property (nonatomic, weak) UIImageView *avatarImg;
@property (nonatomic, strong) EVRedEnvelopeItemModel *currentModel;//触发这个红包的model
@property (nonatomic, copy)   NSString *vid;       //直播视频vid
@property (nonatomic, assign) CCViewTransitionStyle transitionStyle;// default CCViewTransitionStyleSlideFromBottom
- (void)show;
- (void)buttonShow;
+ (void)setAllRedEnvelope:(NSMutableDictionary *)redEnvelopeDic;
+ (void)clearData;

@property (nonatomic, copy) CCRedEnvelopeViewHandler willShowHandler;
@property (nonatomic, copy) CCRedEnvelopeViewHandler didDismissHandler;
@property (nonatomic, copy) void(^grabRedEnveloCompleteHandler)(EVRedEnvelopeView *redEnvelopeView, NSInteger ecoin);

@end
