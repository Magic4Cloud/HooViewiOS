//
//  EVOtherPersonViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//#import "CCViewController.h"
#import "EVPersonalCenterViewController.h"
@class EVUserModel;

@protocol EVOtherPersonViewControllerDelegate <NSObject>

- (void)modifyUserModel:(EVUserModel *)userModel;

@end

@interface EVOtherPersonViewController : EVPersonalCenterViewController

@property (copy, nonatomic) NSString *name; /**< 其他用户的云播号 */
@property (assign, nonatomic) BOOL dismissMsgBtn;   /**< 用于标记是否是从私信聊天页面进来的。如果是，为YES，点击聊天按钮，退回到聊天页面；如果不是，为NO，点击聊天按钮，进入聊天页面 */

@property (nonatomic, assign) id<EVOtherPersonViewControllerDelegate> delegate;


+ (instancetype)instanceWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, assign) BOOL fromLivingRoom;//来自直播间的push 和不是直播间的push

@end
