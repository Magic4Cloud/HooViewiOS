//
//  EVGroupItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupItem.h"
#import "EVEaseMob.h"
#import "EVLoginInfo.h"
#import "EVChatMessageManager.h"
#import "NSString+Extension.h"

@implementation EVGroupItem


+(EVGroupItem *)groupItemWithMessage:(EMMessage *)message
{
    EVGroupItem *groupItem = [[EVGroupItem alloc] init];
    [groupItem updateWithMessage:message];
    
    return groupItem;
}

- (void)updateWithMessage:(EMMessage *)message
{
    EMGroup *group = nil;
    // 判断当前的imuser是否跟to相同,如果相同使用from作为groupId否则to
    NSString *currentUserName = [EVEaseMob cc_shareInstance].currentUserName;
    if ( [currentUserName isEqualToString:message.to] )
    {
       group = [EMGroup groupWithId:message.from];
    }
    else
    {
        group = [EMGroup groupWithId:message.to];
    }
    self.subject = group.groupSubject;
    self.ID = group.groupId;
    self.icon = @"message_my_group";
    self.unread = [[EVEaseMob sharedInstance].chatManager unreadMessagesCountForConversation:self.ID];
    if ([message.ext.allKeys containsObject:@"redpack"]) {
        self.isRedEnvelope = YES;
    } else {
        self.isRedEnvelope = NO;
    }
    NSString *stampFormat = @"YY-MM-dd HH:mm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:stampFormat];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp / 1000];
    self.time = [formatter stringFromDate:date];
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    BOOL isAtMessage = [EVGroupItem isAtMessage:message];
    if ( [body messageBodyType] == eMessageBodyType_Text )
    {
        EMTextMessageBody *textBody = [message.messageBodies firstObject];

        if (isAtMessage && self.firstAtMessage == nil)
        {
            self.isAtMessage = YES;
            self.firstAtMessage = textBody.text;
        }
        self.lastMessage = textBody.text;
    }
    else
    {
        switch ( [body messageBodyType] )
        {
            case eMessageBodyType_Image:
                if ( message.ext[kVid] )
                {
                    self.lastMessage = @"[直播]";
                }
                else
                {
                    self.lastMessage = @"[图片]";
                }
                break;
                
            case eMessageBodyType_Voice:
                self.lastMessage = @"[语音]";
                break;
                
            case eMessageBodyType_Location:
                self.lastMessage = @"[共享位置]";
                break;
                
            default:
                self.lastMessage = @"新消息";
                break;
        }
        
    }}

+ (NSArray<EVGroupItem *> *)groupItemsWithGroups:(NSArray<EMGroup *> *)groups
{
    NSMutableArray *groupItems = [NSMutableArray array];
    for (EMGroup *group in groups) {
        EVGroupItem *item = [[EVGroupItem alloc] init];
        // 获取会话
        EMConversation *conversation = [[EVEaseMob sharedInstance].chatManager conversationForChatter:group.groupId conversationType:eConversationTypeGroupChat];
        // 获取最后一条消息
        EMMessage *latestMessage = conversation.latestMessage;
        item.unread = conversation.unreadMessagesCount;
        if ( latestMessage )
        {
            [item updateWithMessage:latestMessage];
        }
        else
        {
            [item updateWithGroup:group];
        }
        [groupItems addObject:item];
    }
    return groupItems;
}

- (void)updateWithGroup:(EMGroup *)group
{
    self.subject = group.groupSubject;
    self.ID = group.groupId;
    self.owner = group.owner;
}

+ (instancetype)groupitemWithId:(NSString *)groupId
{
    EVGroupItem *item = [[EVGroupItem alloc] init];
    item.ID = groupId;
    return item;
}

-(BOOL)isEqual:(id)object
{
    EVGroupItem *item = (EVGroupItem *)object;
    return [self.ID isEqualToString:item.ID];
}

- (NSString *)owner
{
    if ( _owner == nil )
    {
        EMGroup *group = [EMGroup groupWithId:self.ID];
        _owner = group.owner;
    }
    return _owner;
}

+ (BOOL)isAtMessage:(EMMessage *)message
{
    NSString *currentUserName = [EVEaseMob cc_shareInstance].currentUserName;
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = [message.messageBodies firstObject];
        // 获取@的信息
        NSArray *atMembers = message.ext[katMembers];
        if ( [atMembers containsObject:currentUserName] && message.isRead == NO)
        {
            NSString *currentNickname = [EVLoginInfo localObject].nickname;
            // 设置是否为@信息
            BOOL isAtMessage = [textBody.text cc_containString:[NSString stringWithFormat:@"@%@",currentNickname]] || [textBody.text cc_containString:@"@所有人"];
            return isAtMessage;
        }
    }
    return NO;
}

@end
