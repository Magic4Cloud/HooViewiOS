//
//  EVWatchLiveEndView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveEndBaseView.h"
@class EVWatchLiveEndView;

typedef NS_ENUM(NSInteger, CCWatchEndViewButtonType)
{
    CCWatchEndViewFocusButton = 400,
    CCWatchEndViewHomeButton,
    CCWatchEndViewCancelButton,
    CCWatchEndViewSendPrivateLetter,
};

@protocol CCWatchEndViewDelegate <NSObject>

@optional
- (void)watchEndView:(EVWatchLiveEndView *)watch didClickedButton:(CCWatchEndViewButtonType)type;

@end

@interface EVWatchLiveEndData : NSObject

@property (nonatomic,assign) NSInteger audienceCount;
@property (nonatomic,assign) NSInteger likeCount;
@property (nonatomic,assign) unsigned long long riceCount;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,assign) BOOL followed;
@property (assign, nonatomic) BOOL isOneself;


@end

@interface EVWatchLiveEndView : EVLiveEndBaseView

@property (nonatomic,strong) EVWatchLiveEndData *watchEndData;

- (void)show;

- (void)disMiss;

@property (nonatomic,weak) id<CCWatchEndViewDelegate> delegate;

@end
