//
//  EVEditChatGroupNameViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
@class EMGroup;

typedef enum : NSUInteger {
    CCEditChatGroupNameViewControllerTypeName,
    CCEditChatGroupNameViewControllerTypeNotice,
} CCEditChatGroupNameViewControllerType;

@interface EVEditChatGroupNameViewController : EVViewController

@property (strong, nonatomic) EMGroup * group;

@property (assign, nonatomic) BOOL isOwner;

@property (assign, nonatomic) CCEditChatGroupNameViewControllerType type;

- (void)setChangeSucceed:(void(^)(NSString *description)) succeed;

@end
