//
//  EVReportReasonView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVReportReasonView;

@protocol EVReportResonViewDelegate <NSObject>

@optional
- (void)reportWithReason:(NSString *)reason;

@end

@interface EVReportReasonView : UIView

@property (nonatomic, assign) id<EVReportResonViewDelegate> delegate;

// 显示举报原因
- (void)show;

// 隐藏举报原因
- (void)hide;

@end
