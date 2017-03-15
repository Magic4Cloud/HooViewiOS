//
//  EVLiveWatchManager.h
//  elapp
//
//  Created by 杨尚彬 on 16/9/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVVideoViewProtocol.h"

@interface EVLiveWatchManager : NSObject

@property (nonatomic, weak) id<EVVideoViewProtocol> protocol;


- (void)settingManagerWithName:(NSString *)name vid:(NSString *)vid state:(BOOL)state;
- (void)kickUserWithName:(NSString *)name vid:(NSString *)vid state:(BOOL)state;//踢人
- (void)shutupAudienceWithAudienceName:(NSString *)name vid:(NSString *)vid shutupState:(BOOL)shutup;
+ (NSArray *)isManagerUserAndShutupName:(NSString *)name shutUsers:(NSMutableArray *)shutusers mngUsers:(NSMutableArray *)mngusers;
@end
