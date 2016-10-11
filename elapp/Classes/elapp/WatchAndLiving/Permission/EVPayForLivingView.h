//
//  EVPayForLivingView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 *  付费直播/录播 提示付费页 View
 */
@interface EVPayForLivingView : UIView

@property (nonatomic, copy) void(^tapCloseBtn)();
@property (nonatomic, copy) void(^tapPayBtn)();
@property (nonatomic, copy) void(^tapRechargeBtn)();

- (void)makeUpPayViewWithInfoDictionary:(NSDictionary *)retinfo;
- (void)updatePayViewEcion:(NSString *)ecion;

@end
