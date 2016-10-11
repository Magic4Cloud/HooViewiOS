//
//  EVChatMessageManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatMessageManager.h"
#import "EVEaseMob.h"
#import "EVLoginInfo.h"
#import "EVNotifyItem.h"
#import "EVGroupItem.h"
#import "EVFriendItem.h"
#import "EVBaseToolManager+EVGroupAPI.h"


#define kNSDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface EVChatMessageManager () <EMChatManagerDelegate>

{
    BOOL hasUpdateLevel;   // 标记是否更新本地的anthor_level
}

@property ( strong, nonatomic ) NSMutableArray *groupItems;
@property ( strong, nonatomic ) NSMutableArray<EVFriendItem *> *friends;
@property (assign, nonatomic) BOOL groupItemIsShow; // 标记群组是否显示
@property ( strong, nonatomic ) EVBaseToolManager *engine;
@property (copy, nonatomic) NSString *userbasicinfolistRequst;
@property (copy, nonatomic) NSString *ownerInfoRequest;
@property ( strong, nonatomic ) EVFriendItem *currentOwnerItem;     //  当前组的群主的信息


@end

@implementation EVChatMessageManager


+ (instancetype)shareInstance
{
    static EVChatMessageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)clearAll
{
    [self clearGroupItems];
    [self clearCurrentOccupantItems];
    _createGroupCount = 0;
    _sucssedGetGroupItems = NO;
    _currentOwnerItem = nil;
    hasUpdateLevel = NO;
}

- (void)obtainCreateGroupCountForLevel:(NSInteger) level completion:(void(^)(NSInteger count,BOOL hasAuthority,BOOL hasUpdateLevel)) completion
{
    __block NSInteger userLevel = level;
    CCLog(@"####-----%d,----%s----level-%zd---####",__LINE__,__FUNCTION__,level  );

    // 如果大于0,说明已经遍历计算过,不用重复遍历 直接获取即可(为保证level是最新的hasUpdateLevel == YES)
    if ( self.createGroupCount > 0 && hasUpdateLevel == YES )
    {
        if ( completion )
        {
            BOOL hasAuthority = [self hasCreateGroupAuthorityForLevel:userLevel];
            completion(self.createGroupCount,hasAuthority,hasUpdateLevel);
        }
        return;
    }
    NSArray *groups = [[EVEaseMob sharedInstance].chatManager groupList];
    __block NSInteger count = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group_t = dispatch_group_create();
    if ( hasUpdateLevel == NO )  // 可能是从本地获取自己的level不是最新的 所以重新从网络请求一次
    {
        dispatch_group_async(group_t, queue, ^{
            NSDictionary *resultDic = [self.engine baseUserInfoUrlWithImuser:[EVEaseMob cc_shareInstance].currentUserName];
            if ( [resultDic[kRetvalKye] isEqualToString:kRequestOK] )
            {
                NSDictionary *modelDic = [resultDic objectForKey:kRetinfoKey];
                userLevel = [[modelDic objectForKey:@"anchor_level"] integerValue];
                // 将新的主播等级写入本地
                EVLoginInfo *info = [EVLoginInfo localObject];
                info.anchor_level = userLevel;
                [info synchronized];
                hasUpdateLevel = YES;
                CCLog(@"####-----%d,----%s----modelDic-%@---####",__LINE__,__FUNCTION__,modelDic);
            }

        });
    }
    for (int i = 0; i < groups.count; i ++)
    {
        EMGroup *group = [groups objectAtIndex:i];
        
        dispatch_group_async(group_t, queue, ^{
            // 如果当前的group能获取到owner
            if ( group.owner )
            {
                if ( [group.owner isEqualToString:[EVEaseMob cc_shareInstance].currentUserName] )
                {
                    count ++;
                }
            }
            else  // 如果获取不到owner,网络请求获取群组详情
            {
                EMError *error = nil;
                EMGroup *newGrop = [[EVEaseMob sharedInstance].chatManager fetchGroupInfo:group.groupId error:&error];
                if ( error == nil && [newGrop.owner isEqualToString:[EVEaseMob cc_shareInstance].currentUserName] )
                {
                    count ++;
                }
            }
        });
    }
    dispatch_group_notify(group_t, dispatch_get_main_queue(), ^{
        if ( completion )
        {
            _createGroupCount = count;
            BOOL hasAuthority = [self hasCreateGroupAuthorityForLevel:userLevel];
            completion(_createGroupCount,hasAuthority,hasUpdateLevel);
        }
    });
}

// 根据等级获取是否有新建群组的权限
- (BOOL)hasCreateGroupAuthorityForLevel:(NSInteger)level
{
    switch (level) {
        case 0:
        case 1:
            return NO;
            break;
        case 2:
            if ( _createGroupCount >= 1 )
            {
                return NO;
            }
            break;
        case 3:
            if ( _createGroupCount >= 3 )
            {
                return NO;
            }
            break;
        case 4:
            if ( _createGroupCount >= 5  )
            {
                return NO;
            }
            break;
            
        case 5:
            if ( _createGroupCount >= 8 )
            {
                return NO;
            }
            break;
    }
    
    return YES;
}

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (NSMutableArray *)allGroupItems
{
    if ( _groupItems == nil )
    {
        _groupItems = [NSMutableArray array];
    }
    // 按最后一条消息的时间排序
    [_groupItems sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        EVGroupItem *item1 = (EVGroupItem *)obj1;
        EVGroupItem *item2 = (EVGroupItem *)obj2;
        return [item2.time compare:item1.time];
    }];
    return _groupItems;
}

- (NSMutableArray *)currentMemberItems
{
    if ( _friends == nil )
    {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (NSString *)groupIdWithMessage:(EMMessage *)message
{
    NSString *currentName = [EVEaseMob cc_shareInstance].currentUserName;
    if ( [currentName isEqualToString:message.to] )
    {
        return message.from;
    }
    return message.to;
}

- (NSInteger)groupUnreadCount
{
    NSInteger groupUnreadCount = 0;
    // 计算未读消息数
    for (EVGroupItem *groupItem in self.allGroupItems) {
        NSInteger unread = [[EVEaseMob sharedInstance].chatManager unreadMessagesCountForConversation:groupItem.ID];
        groupUnreadCount += unread;
    }
    return groupUnreadCount;
}

- (void )iconForGroupId:(NSString *)groupId completion:(void(^)(NSString *logourl))completion
{
    EMGroup *group = [EMGroup groupWithId:groupId];
    NSString *owner = group.owner;
    if ( owner == nil )
    {
        [[EVEaseMob sharedInstance].chatManager asyncFetchGroupInfo:groupId completion:^(EMGroup *group, EMError *error) {
            [self.engine logoUrlWithImuser:group.owner completion:^(NSString *logourl,NSString *name) {
                if ( completion )
                {
                    completion(logourl);
                }
            }];

        } onQueue:nil];
    }
    else
    {
        [self.engine logoUrlWithImuser:owner completion:^(NSString *logourl,NSString *name) {
            if ( completion )
            {
                completion(logourl);
            }
        }];
    }
}

- (void)initialGroupItemsLatest:(BOOL)latest completion:(void(^)())completion
{
    self.groupItemIsShow = YES;
    WEAK(self)
    [[EVEaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        _finishGetGroupItems = YES;
        
       NSString *plistPath =  [weakself  createPlistFile];
        // 清空原有数组
        [self clearGroupItems];
        if ( error == nil )
        {
            _sucssedGetGroupItems = YES;
            NSArray *groupItems = [EVGroupItem groupItemsWithGroups:groups];
            [self.allGroupItems addObjectsFromArray:groupItems];
          
            [self filterPlistFileGroupItems:groupItems plistPath:plistPath];
        }
        else
        {
            // 如果网络请求没有得到, 从数据库中取
            NSArray *groupsFromDB = [[EVEaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES];
            NSArray *groupItems = [EVGroupItem groupItemsWithGroups:groupsFromDB];
            [self.allGroupItems addObjectsFromArray:groupItems];
            
            [self filterPlistFileGroupItems:groupItems plistPath:plistPath];
        }
        if ( completion )
        {
            completion();
        }
        
        [self notifyGroupMessageUpdate];
        
    } onQueue:NULL];
}

- (void)clearGroupItems
{
    [self.allGroupItems removeAllObjects];
    self.groupItemIsShow = NO;
}

- (void)markGroupAsRead:(NSString *)groupId
{
    EMConversation *conversation = [[EVEaseMob sharedInstance].chatManager conversationForChatter:groupId conversationType:eConversationTypeGroupChat];
    [conversation markAllMessagesAsRead:YES];
    for (int i = 0; i < self.allGroupItems.count; i ++)
    {
        EVGroupItem *targetItem = self.allGroupItems[i];
        if ( [groupId isEqualToString:targetItem.ID])
        {
            // 将targetItem的未读数和@信息置空
            targetItem.unread =  0;
            targetItem.isAtMessage = NO;
            targetItem.firstAtMessage = nil;
            break;
        }
    }
    [self notifyGroupMessageUpdate];
}

- (void)addGroupItemWithId:(NSString *)groupId
{
    EVGroupItem *item = [[EVGroupItem alloc] init];
    EMGroup *group = [EMGroup groupWithId:groupId];
    [item updateWithGroup:group];
    [self.allGroupItems insertObject:item atIndex:0];
    [self notifyGroupMessageUpdate];
}

- (void)removeGroupItemWithId:(NSString *)groupId
{
    EVGroupItem *item = [EVGroupItem groupitemWithId:groupId];
    if ( [self.allGroupItems containsObject:item] )
    {
        [self removePlistFileGroupsArrayID:item.ID unRead:2];
        [self.allGroupItems removeObject:item];
        
    }
    [self notifyGroupMessageUpdate];
}

- (void)updateGroupItemNameWithGroup:(EMGroup *)group
{
    for (int i = 0; i < self.allGroupItems.count; i ++)
    {
        EVGroupItem *item = self.allGroupItems[i];
        if ( [item.ID isEqualToString:group.groupId] )
        {
            item.subject = group.groupSubject;
            [CCNotificationCenter postNotificationName:CCDidUpdateChatGroupNameNotification object:nil userInfo:@{CCDidUpdateChatGroupNameNotificationIDKey:group.groupId,CCDidUpdateChatGroupNameNotificationSubjectKey:group.groupSubject}];
            return;
        }
    }
}

- (void)createGroupWithFriends:(NSArray *)friends completion:(void (^)(EMGroup *group,EMError *error))completion
{
    if ( friends.count == 0 )
    {
        return;
    }
    NSMutableArray *memberArray = [NSMutableArray array];
    NSMutableArray *logourlArray = [NSMutableArray array];
    NSMutableString *groupSbuject = [[EVLoginInfo localObject].nickname mutableCopy];
    if ( groupSbuject == nil )
    {
        groupSbuject = [NSMutableString string];
    }
    for (int i = 0; i < friends.count; i ++)
    {
        EVFriendItem *item = friends[i];
        if ( item.imuser == nil || item.logourl == nil )
        {
            [CCProgressHUD   showError:@"没有私聊账号"];
            return;
        }
        [memberArray addObject:item.imuser];
        [logourlArray addObject:item.logourl];
        if ( i < 5 )
        {
            NSString *nickname = [NSString stringWithFormat:@",%@",item.nickname];
            [groupSbuject appendString:nickname];
        }
    }
    if ( groupSbuject.length > 10 )
    {
        NSInteger length = groupSbuject.length;
        [groupSbuject deleteCharactersInRange:NSMakeRange(10, length - 10)];
    }
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    groupStyleSetting.groupMaxUsersCount = 200; // 默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PrivateMemberCanInvite; // 创建不同类型的群组，这里需要才传入不同的类型

    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:groupSbuject description:@"" invitees:memberArray initialWelcomeMessage:kWelcomeMsg styleSetting:groupStyleSetting completion:^(EMGroup *group, EMError *error) {
        CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,error);

        if ( completion )
        {
            if ( error == nil )
            {
                [self notifyGroupMessageUpdate];
                EVGroupItem *groupItem = [EVGroupItem groupitemWithId:group.groupId];
                // 生成群组图片
                groupItem.icon = [EVLoginInfo localObject].logourl;
                groupItem.subject = groupSbuject;
                groupItem.owner = [[EVEaseMob cc_shareInstance] currentUserName];
                if ( groupItem )
                {
                    [self.allGroupItems insertObject:groupItem atIndex:0];
                }
                [self notifyGroupMessageUpdate];
                _createGroupCount ++;
            }
            completion(group,error);
        }
        
    } onQueue:nil];
}

- (void)destroyGroupWithId:(NSString *)groupId completion:(void (^)(EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        if (!error) {
            if ( completion )
            {
                if ( !error )
                {
                    [self removeGroupItemWithId:group.groupId];
                    // 自己建的群数量减1
                    _createGroupCount --;
                }
                completion(error);
            }
        }
    } onQueue:nil];
}

- (void)leaveGroupWithId:(NSString *)groupId completion:(void (^)(EMError *))completion
{
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:groupId
                                               completion:
     ^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
         if (!error) {
             if ( completion )
             {
                 [self removeGroupItemWithId:groupId];
                 completion(error);
             }
         }
         
     } onQueue:nil];

}


- (void)changeGroupSubject:(NSString *)name forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group,EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:name forGroup:groupId completion:^(EMGroup *group, EMError *error) {
        if (!error) {
            if ( completion )
            {
                [self updateGroupItemNameWithGroup:group];
                completion(group,error);
            }
        }
    } onQueue:nil];
}

- (void)changegroupDescription:(NSString *)description forGroup:(NSString *)groupId completion:(void(^)(EMGroup *group,EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncChangeDescription:description forGroup:groupId completion:^(EMGroup *group, EMError *error) {
        if ( completion )
        {
            completion(group,error);
            if ( !error )
            {
                NSString *notice = [NSString stringWithFormat:@"@所有人 %@",description];
                if ( group.members )
                {
                    EMMessage *msg = [EVEaseMob sendTextMessageWithString:notice toUsername:groupId isChatGroup:YES requireEncryption:YES ext:@{katMembers:group.members}];
                    [CCNotificationCenter postNotificationName:CCChatGroupDidSendNoticeNotification object:nil userInfo:@{CCChatGroupDidSendNoticeKey:msg}];
                }
            }
        }
    } onQueue:nil];
}

- (void)addFriends:(NSArray *)friends toGroup:(NSString *)groupId completion:(void (^)(EMError *))completion
{
    if ( friends.count == 0 )
    {
        return;
    }
    NSMutableArray *newMembers = [NSMutableArray array];
    for (EVFriendItem *item in friends) {
        // 取消选中状态
        item.selected = NO;
        if ( item.imuser )
        {
            [newMembers addObject:item.imuser];
        }
    }
    if ( newMembers.count == 0 )
    {
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncAddOccupants:newMembers toGroup:groupId welcomeMessage:kWelcomeMsg  completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {

        if (!error) {
            CCLog(@"添加成功");
            // 向群里发送一条扩展消息
            [self sendUpdateMembersMessageWithMembers:occupants group:groupId isAdd:YES];
            [self notityCurrentFriendUpdate];

            if ( completion )
            {
                completion(error);
            }
        }
    } onQueue:nil];
}

- (void)sendUpdateMembersMessageWithMembers:(NSArray *)imusers group:(NSString *)groupId isAdd:(BOOL)add
{
    [EVEaseMob sendCmdMessageWithReceiver:groupId isChatGroup:YES cmd:kUpdateGroupCmdKey];
}

- (void)removeFriends:(NSArray *)friends toGroup:(NSString *)groupId completion:(void (^)(EMError *))completion
{
    NSMutableArray *occupants = [NSMutableArray array];
    for (EVFriendItem *item in friends) {
        // 取消选中状态
        item.selected = NO;
        if (item.im_user == nil) {
            [CCProgressHUD showError:@"环信号为空"];
        }
        [occupants addObject:item.im_user];
    }
    [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:occupants fromGroup:groupId completion:^(EMGroup *group, EMError *error) {
        if ( !error )
        {
            [self notityCurrentFriendUpdate];
            CCLog(@"删除成功");
            if ( completion )
            {
                completion(error);
            }
        }
        
    } onQueue:nil];
}


// 群员管理(不包括群主)

- (void)initialCurrentMemberItemsWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *friends))completion
{
    EMGroup *group = [EMGroup groupWithId:groupId];
    
    // 取消上次的请求
    [self.engine cancelOperataionWithURLString:self.userbasicinfolistRequst];
    __weak typeof(self) weakSelf = self;
    self.userbasicinfolistRequst =  [self.engine userbasicinfolistWithNameList:nil orImuserList:group.members start:nil fail:^(NSError *error) {
        
    } success:^(NSDictionary *modelDict) {
        NSArray *dataArray = modelDict[@"users"];
        NSArray *friendArray = [EVFriendItem objectWithDictionaryArray:dataArray];
        // 清空原有的数组
        [weakSelf.currentMemberItems removeAllObjects];
        // 添加新的元素
        [weakSelf.currentMemberItems addObjectsFromArray:friendArray];
        if ( completion )
        {
            completion(weakSelf.currentMemberItems);
        }
    } sessionExpire:nil];

}

- (void)initialCurrentOccupantItemsWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *friends))completion
{
    __weak typeof(self) weakSelf = self;
    [self initialCurrentMemberItemsWithGroupId:groupId completion:^(NSArray *friends) {
        NSMutableArray *occupantArray = [friends mutableCopy];
        [weakSelf initialCurrentOwnerInfoWithGroupId:groupId completion:^(EVFriendItem *ownerItem) {
            
            [occupantArray addObject:ownerItem];
            if ( completion )
            {
                completion(occupantArray);
            }
        }];
    }];
}

- (void)initialCurrentOwnerInfoWithGroupId:(NSString *)groupId completion:(void (^)(EVFriendItem *ownerItem))completion
{
    if ( self.currentOwnerItem )
    {
        if ( completion )
        {
            completion(self.currentOwnerItem);
        }
        return;
    }
    EMGroup *group = [EMGroup groupWithId:groupId];
    __weak typeof(self) weakSelf = self;
    [self.engine cancelOperataionWithURLString:self.ownerInfoRequest];
    self.ownerInfoRequest = [self.engine GETBaseUserInfoWithUname:nil orImuser:group.owner start:nil fail:nil success:^(NSDictionary *modelDict) {
        EVFriendItem *item = [EVFriendItem objectWithDictionary:modelDict];
        weakSelf.currentOwnerItem = item;
        if ( completion )
        {
            completion(item);
        }
    } sessionExpire:nil];
}

- (void)clearCurrentOccupantItems
{
    [self.currentMemberItems removeAllObjects];
    self.currentOwnerItem = nil;
}

// 通知更新群组消息
- (void)notifyGroupMessageUpdate
{
    [CCNotificationCenter postNotificationName:CCShouldUpdateChatGroupMessageNotification object:nil];
}

- (void)notityCurrentFriendUpdate
{
    [CCNotificationCenter postNotificationName:CCShouldUpdateCurrentFriendMessageNotification object:nil];
}

#pragma mark - 环信 delegate

//  收到消息
- (void)didReceiveMessage:(EMMessage *)message
{
    [self handleMessage:message isOfflineMessages:NO];
}
//  收到离线消息
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        [self handleMessage:message isOfflineMessages:YES];
    }
}
//  消息已发送
- (void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self handleMessage:message isOfflineMessages:NO];
}

-(void)didReceiveCmdMessage:(EMMessage *)cmdMessage{
    EMCommandMessageBody *body = (EMCommandMessageBody *)cmdMessage.messageBodies.lastObject;
    CCLog(@"####-----%d,----%s-----action %@---####",__LINE__,__FUNCTION__,body.action);

    if ( [body.action isEqualToString:kUpdateGroupCmdKey] )
    {
        CCLog(@"####-----%d,----%s----groupID-%@---####",__LINE__,__FUNCTION__,cmdMessage.to);

        NSString *groupId = cmdMessage.from;
        // 刷新当前群组
        [[EVEaseMob sharedInstance].chatManager asyncFetchGroupInfo:groupId includesOccupantList:YES completion:^(EMGroup *group, EMError *error) {
            if ( group )
            {
                [CCNotificationCenter postNotificationName:CCChatGroupDidUpdateMembersNotification object:nil userInfo:@{CCChatGroupDidUpdateGroupKey:group}];
            }
        } onQueue:nil];
    }
}

#pragma mark - 处理收到或发出的消息

- (void)handleMessage:(EMMessage *)message isOfflineMessages:(BOOL)isOfflineMessages
{
    // 如果是群聊
    if ( message.messageType != eMessageTypeChat )
    {
        [self handleGroupMessage:message isOfflineMessages:isOfflineMessages];
    }
    else
    {
        [self handleCommonMessage:message];
    }
}

// 处理群组消息
- (void)handleGroupMessage:(EMMessage *)message isOfflineMessages:(BOOL)isOfflineMessages
{
    NSString *groupId = [self groupIdWithMessage:message];
    int i = 0;
    NSMutableArray *newAllGroupItems = [NSMutableArray arrayWithArray:self.allGroupItems];
    for (; i < newAllGroupItems.count; i ++)
    {
        EVGroupItem *targetItem = newAllGroupItems[i];
        
        if ( [groupId isEqualToString:targetItem.ID])
        {
            [[EVEaseMob sharedInstance].chatManager asyncFetchGroupInfo:groupId includesOccupantList:YES completion:^(EMGroup *group, EMError *error) {
                if ( group )
                {
                    // 获取会话
                    EMConversation *conversation = [[EVEaseMob sharedInstance].chatManager conversationForChatter:group.groupId conversationType:eConversationTypeGroupChat];
                    // 获取最后一条消息
                    EMMessage *latestMessage = conversation.latestMessage;
                    targetItem.unread = conversation.unreadMessagesCount;
                    if ( latestMessage )
                    {
                        [targetItem updateWithMessage:latestMessage];
                    }
                    else
                    {
                        [targetItem updateWithGroup:group];
                    }
                }
                
                [self notifyGroupMessageUpdate];
            } onQueue:nil];
            [targetItem updateWithMessage:message];
            [self.allGroupItems removeObject:targetItem];
            NSInteger unRead = isOfflineMessages ? targetItem.unread : 2;
            [self removePlistFileGroupsArrayID:targetItem.ID unRead:unRead];
            [self.allGroupItems insertObject:targetItem atIndex:0];
            break;
        }
    }
    if ( i == self.allGroupItems.count )
    {
        // 创建一个新的群组添加到数组中
       EVGroupItem *item = [EVGroupItem groupItemWithMessage:message];
        
        // 如果群组列表显示出来了 就添加到群组列表中 如果没有就不添加
        if ( self.groupItemIsShow == NO )
        {
            if ( item )
            {
                [self.allGroupItems insertObject:item atIndex:0];
                 NSInteger unRead = isOfflineMessages ? item.unread : 2;
                [self removePlistFileGroupsArrayID:item.ID unRead:unRead];
                [self notifyGroupMessageUpdate];
            }
        }
    }
}

// 处理普通消息
- (void)handleCommonMessage:(EMMessage *)message
{
    
}

#pragma mark - 群组监听

// 创建群组
- (void)group:(EMGroup *)group didCreateWithError:(EMError *)error
{
    
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{

}

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
                                error:(EMError *)error
{
    
}

- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    // 保存一条消息到本地
    EMChatText *text = [[EMChatText alloc] initWithText:kWelcomeMsg];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    EMMessage *welcomMsg = [[EMMessage alloc] initWithReceiver:group.groupId bodies:[NSArray arrayWithObject:body]];
    welcomMsg.from = group.groupId;
    welcomMsg.to = [EVEaseMob cc_shareInstance].currentUserName;
    welcomMsg.messageType = eMessageTypeGroupChat;
    welcomMsg.groupSenderName = group.owner;
    welcomMsg.isRead = NO;
    [[EVEaseMob sharedInstance].chatManager insertMessageToDB:welcomMsg append2Chat:YES];
    
    // 更新群组列表
    EVGroupItem *groupItem = [EVGroupItem groupitemWithId:group.groupId];
    groupItem.subject = group.groupSubject;
    [groupItem updateWithMessage:welcomMsg];
    if ( ![self.allGroupItems containsObject:groupItem] )
    {
        [self.allGroupItems insertObject:groupItem atIndex:0];
        if ( group )
        {
            [CCNotificationCenter postNotificationName:CCChatGroupDidAcceptInvitationNotification object:nil userInfo:@{CCChatGroupDidAcceptInvitationGroupKey:group}];
            [self notifyGroupMessageUpdate];
        }
    }
}

// 离开群组
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if ( group.groupId )
    {
        [CCNotificationCenter postNotificationName:CCChatGrroupDidLeaveNotification object:nil userInfo:@{CCChatGrroupDidLeaveReasonKey:@(reason),CCChatGrroupDidLeaveGroupIdKey:group.groupId}];
        [self removeGroupItemWithId:group.groupId];
    }
}

- (void)insertMessageWithText:(NSString *)text toGroup:(EMGroup *)group
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:group.groupId bodies:[NSArray arrayWithObject:body]];
    message.from = group.groupId;
    message.to = [EVEaseMob cc_shareInstance].currentUserName;
    message.messageType = eMessageTypeGroupChat;
    message.groupSenderName = group.owner;
    message.isRead = NO;
    message.deliveryState = eMessageDeliveryState_Delivered;
    [[EVEaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    [self handleGroupMessage:message isOfflineMessages:NO];
}

#pragma mark - plist
- (NSString *)createPlistFile
{
    //获取完整路径
    NSString *documentsDirectory = kNSDocumentPath;
    NSString *plistName = [NSString stringWithFormat:@"%@.plist",[EVLoginInfo localObject].name];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:plistPath]) {
        [filemanager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *nplistArray = [NSMutableArray arrayWithArray:plistArray];
        [nplistArray writeToFile:plistPath atomically:YES];
    }
    return plistPath;
}

- (void)filterPlistFileGroupItems:(NSArray *)groupItems plistPath:(NSString *)plistPath
{
    NSMutableArray *plistarray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *nplistArray = [NSMutableArray arrayWithArray:plistarray];
    NSMutableArray *groupArray = [NSMutableArray arrayWithArray:groupItems];
    for (NSInteger i = 0; i < plistarray.count; i++) {
        NSString *groupID = [NSString stringWithFormat:@"%@",plistarray[i]];
        for (EVGroupItem *groupItem in groupArray) {
            if ([groupItem.ID isEqualToString:groupID]) {
                if (groupItem.unread > 0) {
                    [nplistArray removeObject:groupID];
                }else{
                    [self.allGroupItems removeObject:groupItem];
                }
            }
        }
    }
  
    [nplistArray writeToFile:plistPath atomically:YES];
}

- (void)removePlistFileGroupsArrayID:(NSString *)groupID unRead:(NSInteger)unread
{
    NSString *documentsDirectory = kNSDocumentPath;
    NSString *plistName = [NSString stringWithFormat:@"%@.plist",[EVLoginInfo localObject].name];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *nplistArray = [NSMutableArray arrayWithArray:plistArray];
    for (NSString *plistGroupID in nplistArray) {
        if ([plistGroupID isEqualToString:groupID] && unread > 0) {
            [plistArray removeObject:groupID];
        }
    }
    [plistArray writeToFile:plistPath atomically:YES];
}

- (void)addPlistFileGroupsArrayID:(NSString *)groupID
{
    NSString *documentsDirectory = kNSDocumentPath;
    NSString *plistName = [NSString stringWithFormat:@"%@.plist",[EVLoginInfo localObject].name];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *newPlistArray = [NSMutableArray arrayWithArray:plistArray];
    [newPlistArray addObject:groupID];
    [newPlistArray writeToFile:plistPath atomically:YES];
}

@end
