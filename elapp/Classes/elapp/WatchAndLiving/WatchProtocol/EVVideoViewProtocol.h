//
//  EVVideoViewProtocol.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>
@class EVWatchLiveEndData;

@protocol EVVideoViewProtocol <NSObject>

@optional
/**
 *  @author
 *
 *  禁言成功
 */
- (void)audienceShutedupSuccess;
/**
 *  @author
 *
 *  禁言失败
 */
- (void)audienceShutedupFail;


//设置管理员成功
- (void)settingManagerSuccess;

//设置管理员失败
- (void)settingManagerFail;

@end

