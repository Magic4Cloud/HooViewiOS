//
//  EVChatVoiceAnimationView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCChatVoiceAnimationViewState) {
    CCChatVoiceAnimationViewHoldOn,
    CCChatVoiceAnimationViewSliderUp,
    CCChatVoiceAnimationViewHidden
};

@interface EVChatVoiceAnimationView : UIView

@property (nonatomic, assign) CCChatVoiceAnimationViewState state;


@end
