//
//  EVRecorderEndView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCRecorderEndViewButtonType)
{
    CCRecorderEndViewFocusButton = 400,
    CCRecorderEndViewCancelButton,
    CCRecorderEndViewSendPrivateLetter,
    CCRecorderEndViewPlaybackButton
};

@class EVRecorderEndView;

@protocol EVRecorderEndViewDelegate <NSObject>

@optional

- (void)recorderEndView:(EVRecorderEndView *)watchOver didClickedButton:(CCRecorderEndViewButtonType)type;

@end
@interface EVRecorderEndView : UIView

/** 是否隐藏关注主播按钮，如果已经关注主播了就要隐藏 */
@property (nonatomic, assign) BOOL hiddenFocusBtn;
@property (nonatomic, assign) BOOL hiddenSendmessagesBtn; /**< 是否隐藏私信按钮 如果是自己隐藏 */

@property (nonatomic, weak) id<EVRecorderEndViewDelegate> delegate;

@end
