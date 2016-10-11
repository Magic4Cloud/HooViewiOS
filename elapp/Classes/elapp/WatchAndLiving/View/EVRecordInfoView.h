//
//  EVRecordInfoView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVRecordInfoView;

#define RECORD_BTN_BACK             100
#define RECORD_BTN_FORWARD          101
#define RECORD_BTN_PALY_OR_PAUSE    102

@protocol CCRecordInfoViewDelegate <NSObject>

@optional
- (void)recordInfoViewDidAutoHidden:(EVRecordInfoView *)recordInfoView;
- (void)recordInfoView:(EVRecordInfoView *)recordInfoView didClickButton:(UIButton *)btn;
- (void)recordInfoViewDidDragToNewProgress:(double)progress;
- (void)recordInfoViewDidBeginDrag:(EVRecordInfoView *)recordInfoView;
- (void)recordInfoView:(EVRecordInfoView *)recordInfoView valueChaged:(float)value;

@end

@interface EVBufferSlider : UISlider

@property (nonatomic,strong) UIColor *bufferProgressColor;

@property (nonatomic, assign) CGFloat bufferProgress;

@end

@interface EVRecordInfoView : UIView

@property (nonatomic,weak) id<CCRecordInfoViewDelegate> delegate;

/** 是否隐藏 */
@property (nonatomic, assign, readonly) BOOL hasHidden;

+ (instancetype)recordInfoViewToSuperView:(UIView *)view height:(CGFloat)height;

@property (nonatomic, assign) CGFloat maxProgress;

@property (nonatomic, assign) CGFloat currProgress;

@property (nonatomic, assign) CGFloat bufferProgress;

@property (nonatomic, assign) BOOL pause;

- (void)showComplete:(void(^)())complete;

@end
