//
//  EVSetLivingPaySumView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 *  主播设置付费直播金额页
 */
@interface EVSetLivingPaySumView : UIView

+ (void)showSetLivingPaySumViewToSuperView:(UIView *)targetView complete:(void(^)(NSString *sum, BOOL isCancel))complete;

@end
