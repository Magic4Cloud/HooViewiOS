//
//  EVChatMessageManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

// 群组信息变化通知
#define CCShouldUpdateChatGroupMessageNotification  @"CCShouldUpdateChatGroupMessageNotification"
// 群组好友变化通知
#define CCShouldUpdateCurrentFriendMessageNotification @"CCShouldUpdateCurrentFriendMessageNotification"
// 群组名称变化通知
#define CCDidUpdateChatGroupNameNotification @"CCDidUpdateChatGroupNameNotification"
#define CCDidUpdateChatGroupNameNotificationIDKey @"ID"
#define CCDidUpdateChatGroupNameNotificationSubjectKey @"subject"
#define CCChatGroupMessageKey @"CCChatGroupMessageKey"
// 离开群的通知
#define CCChatGrroupDidLeaveNotification @"CCChatGrroupDidLeaveNotification"
#define CCChatGrroupDidLeaveReasonKey    @"reason"  //离开原因
#define CCChatGrroupDidLeaveGroupIdKey   @"ID"

// 收到邀请通知
#define CCChatGroupDidAcceptInvitationNotification   @"CCChatGroupDidAcceptInvitationNotification"
#define  CCChatGroupDidAcceptInvitationGroupKey      @"group"

// 群成员变动的通知
#define CCChatGroupDidUpdateMembersNotification @"CCChatGroupDidUpdateMembersNotification"
#define CCChatGroupDidUpdateGroupKey @"group"

#define CCChatGroupDidSendNoticeNotification @"CCChatGroupDidSendNoticeNotification"
#define CCChatGroupDidSendNoticeKey @"sendNotice"

#define kWelcomeMsg @"您已被邀请加入群聊"

#define katMembers              @"atMembers"
#define kUpdateGroupCmdKey      @"updateGroup"

@class EMError;
@class EMGroup;
@class EVBaseToolManager;
@class EMMessage;
@class EVFriendItem;

@interface EVChatMessageManager : CCBaseObject



@property ( strong, nonatomic ,readonly ) NSMutableArray *allGroupItems;

@property ( strong, nonatomic ,readonly) NSMutableArray *currentMemberItems; // 当前群组的成员(不包括群主)

@property (assign, nonatomic, readonly) NSInteger groupUnreadCount; // 群组未读消息总数

@property (assign, nonatomic, readonly) BOOL sucssedGetGroupItems;        // 标记获取群组列表成功

@property (assign, nonatomic, readonly) BOOL finishGetGroupItems;         // 标记获取群组结束(成功或失败)

@property (assign, nonatomic , readonly) NSInteger createGroupCount;       // 自己创建的群的数量




/**
 *  @author 杨尚彬
 *
 *  获取单例对象
 *
 *  @return
 */
+ (instancetype)shareInstance;

/**
 *  @author 杨尚彬
 *
 *  情况所有数据(退出登录时,使用)
 */
- (void)clearAll;

/**
 *  @author 杨尚彬
 *
 *  获取自己创建的群的数量
 *
 *  @param completion 结束回调 (count自己所创建的群组数,hasAuthority有无权限继续创建,hasUpdateLevel是否是最新的主播等级)
 */
- (void)obtainCreateGroupCountForLevel:(NSInteger) level completion:(void(^)(NSInteger count,BOOL hasAuthority,BOOL hasUpdateLevel)) completion;

/**
 *  @author 杨尚彬
 *
 *  是否有权限新建群组
 *
 *  @param level 主播等级
 *
 *  @return 权限
 */
- (BOOL)hasCreateGroupAuthorityForLevel:(NSInteger)level;

/**
 *  @author 杨尚彬
 *
 *  通过message获取groupId
 *
 *  @param message 消息
 *
 *  @return groupId
 */
- (NSString *)groupIdWithMessage:(EMMessage *)message;


/**
 *  @author 杨尚彬
 *
 *  设置group的头像
 *
 *  @param groupId    id
 *  @param completion 结束回调
 */
- (void )iconForGroupId:(NSString *)groupId completion:(void(^)(NSString *logourl))completion;

/**
 *  @author 杨尚彬
 *
 *  初始化所有群组
 *  
 *  @param latest  是否获取最新的
 *  @param completion 结束回调
 */
- (void)initialGroupItemsLatest:(BOOL)latest completion:(void(^)())completion;

/**
 *  @author 杨尚彬
 *
 *  清空群组列表
 */
- (void)clearGroupItems;

/**
 *  @author 杨尚彬
 *
 *  标记群组消息已读
 *
 *  @param groupId 群组id
 */
- (void)markGroupAsRead:(NSString *)groupId;

/**
 *  @author 杨尚彬
 *
 *  从allGroupItems中删除一个元素
 *
 *  @param groupId 群id
 */
- (void)removeGroupItemWithId:(NSString *)groupId;

/**
 *  @author 杨尚彬
 *
 *  更新groupItem
 *
 *  @param group
 */
- (void)updateGroupItemNameWithGroup:(EMGroup *)group;

/**
 *  @author 杨尚彬
 *
 *  添加一个元素到allGroupItems
 *
 *  @param groupId 群id
 */
- (void)addGroupItemWithId:(NSString *)groupId;

/**
 *  @author 杨尚彬
 *
 *  创建群组
 *
 *  @param friends    好友对象
 *  @param completion 结束回调
 */
- (void)createGroupWithFriends:(NSArray *)friends completion:(void (^)(EMGroup *group,EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  解散群组
 *
 *  @param groupId    群id
 *  @param completion 结束回调
 */
- (void)destroyGroupWithId:(NSString *)groupId completion:(void (^)(EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  退出群组
 *
 *  @param groupId    群id
 *  @param completion 结束回调
 */
- (void)leaveGroupWithId:(NSString *)groupId completion:(void (^)(EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  修改群名称
 *
 *  @param completion 结束回调
 */
- (void)changeGroupSubject:(NSString *)name forGroup:(NSString *)groupId completion:(void (^)(EMGroup *group,EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  修改群公告
 *
 *  @param description 群公告
 *  @param groupId
 *  @param completion  结束回调
 */
- (void)changegroupDescription:(NSString *)description forGroup:(NSString *)groupId completion:(void(^)(EMGroup *group,EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  添加好友进群
 *
 *  @param array      好友数组
 *  @param groupId    群id
 *  @param completion 结束回调
 */

- (void)addFriends:(NSArray *)array toGroup:(NSString *)groupId completion:(void (^)(EMError *error))completion;

/**
 *  @author 杨尚彬
 *
 *  删除好友
 *
 *  @param friends    好友数组
 *  @param groupId    群id
 *  @param completion 结束回调
 */
- (void)removeFriends:(NSArray *)friends toGroup:(NSString *)groupId completion:(void (^)(EMError * error))completion;


/**
 *  @author 杨尚彬
 *
 *  通过成员获取好友(不包括群主)
 *
 *  @param groupId 群id
 */
- (void)initialCurrentMemberItemsWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *friends))completion;

/**
 *  @author 杨尚彬
 *
 *  获取当前群组的所有成员的信息(包括群主)
 *
 *  @param groupId    群id
 *  @param completion 结束回调
 */
- (void)initialCurrentOccupantItemsWithGroupId:(NSString *)groupId completion:(void (^)(NSArray *friends))completion;

/**
 *  @author 杨尚彬
 *
 *  获取当前群组的群主信息
 *
 *  @param groupId    群id
 *  @param completion 结束回调
 */
- (void)initialCurrentOwnerInfoWithGroupId:(NSString *)groupId completion:(void (^)(EVFriendItem *ownerItem))completion;

/**
 *  @author 杨尚彬
 *
 *  清空当前组的成员信息
 */
- (void)clearCurrentOccupantItems;

- (void)insertMessageWithText:(NSString *)text toGroup:(EMGroup *)group;

- (void)addPlistFileGroupsArrayID:(NSString *)groupID;

- (void)removePlistFileGroupsArrayID:(NSString *)groupID unRead:(NSInteger)unread;

@end
