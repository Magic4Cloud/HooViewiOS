//
//  EMCDDeviceManagerProximitySensorDelegate.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMCDDeviceManagerProximitySensorDelegate <NSObject>

/*!
 @method
 @brief 当手机靠近耳朵时或者离开耳朵时的回调方法
 @param isCloseToUser YES为靠近了用户, NO为远离了用户
 @discussion
 @result
 */
- (void)proximitySensorChanged:(BOOL)isCloseToUser;

@end
