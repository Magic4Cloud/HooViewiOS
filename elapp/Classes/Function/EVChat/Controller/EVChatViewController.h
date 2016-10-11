//
//  EVChatViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

@class EMMessage;
@class EVChatViewController;

@protocol CCChatViewControllerDelegate <NSObject>

@optional

/**
 *  当删除最后一条消息时回调的方法
 *
 *  @param chatVC 当前的CCChatViewController对象
 *
 *  @param lastMessageItem 删除后的最后一条cell的模型对象
 */
- (void) chatViewController:(EVChatViewController *)chatVC didDeleteLastMessage:(EMMessage *)lastMessage;

@end

@class EVNotifyConversationItem;

/**
 *  >> 本类作用：当前进入的会话群组
 */
@interface EVChatViewController : EVViewController

@property (nonatomic,strong) EVNotifyConversationItem *conversationItem;

@property ( weak, nonatomic ) id<CCChatViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *chatter;


@property (assign, nonatomic) BOOL hasAt;

@property (assign, nonatomic) NSInteger unread;

@property ( strong, nonatomic ) NSArray *members;


@end
