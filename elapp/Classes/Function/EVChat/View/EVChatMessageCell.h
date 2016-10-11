//
//  EVChatMessageCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVMessageItem, EVChatMessageCell;

#define CCChatMessageCell_VOICE             200
#define CCChatMessageCell_SEND_AGAIN        203
#define CCChatMessageCell_REDENVELOPE        204

@protocol CCChatMessageCellDelegate <NSObject>
@optional
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickCellType:(NSInteger)type;

- (void)chatMessageCell:(EVChatMessageCell *)cell didClickHeaderType:(NSInteger)messageFrom;
// 长按头像
- (void)chatMessageCell:(EVChatMessageCell *)cell didLongPressedHeaderType:(NSInteger)messageFrom;

- (void)chatMessageCell:(EVChatMessageCell *)cell bodyContentViewLongPressed:(EVMessageItem *)msgItem targetView:(UIView *)targetView;
// 点击复制菜单
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickCopyMenuWithItem:(EVMessageItem *)msgItem;
// 点击转发菜单
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickRelayMenuWithItem:(EVMessageItem *)msgItem;
// 点击删除菜单
- (void)chatMessageCell:(EVChatMessageCell *)cell didClickDeleteMenuWithItem:(EVMessageItem *)msgItem;


@end


@interface EVChatMessageCell : UITableViewCell

@property (nonatomic,weak) id<CCChatMessageCellDelegate> delegate;

@property (nonatomic,weak) UILabel *messageLabel;
@property (nonatomic,weak) UIView *bodyContentView;
@property (nonatomic,weak) UIView *voiceContainView;


@property (nonatomic,strong) EVMessageItem *messageItem;

- (void)startVoiceAniamtion;
- (void)stopVoiceAniamtion;

+ (NSString *)cellId;

@end
