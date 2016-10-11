//
//  EVChooseGroupMemberViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"

typedef enum : NSUInteger {
    CCChooseGroupMemberViewControllerTypeCreateGroup,   /**< 默认创建群组 */
    CCChooseGroupMemberViewControllerTypeAddMember,     /**< 增加群成员 */
    CCChooseGroupMemberViewControllerTypeRemoveMember,  /**< 删除群成员 */
    CCChooseGroupMemberViewControllerTypeShowMembers,   /**< 显示群成员 */
    CCChooseGroupMemberViewControllerTypeAtMembers,     /**< 在群聊中 @ 某人 */
    CCChooseGroupMemberViewControllerTypeLiveFilter,    /**< 开播时选择‘好友可见’ */
} CCChooseGroupMemberViewControllerType;


@class EMGroup;
@class CCFriendItem,EVGroupItem;

@protocol EVChooseGroupMemberViewControllerDelegate <NSObject>

- (void)groupDestroyed;

@end

typedef void(^DismissCompletion)(EMGroup *newGroup,NSArray *friends);
typedef void(^DisMissVC) (EVGroupItem *groupItem);

/**
 *  本类作用：查看、操作群成员页
 */
@interface EVChooseGroupMemberViewController : EVViewController

@property (assign, nonatomic) CCChooseGroupMemberViewControllerType type; /**< 当前控制器的类型:1.创建群 2.添加群成员 3.删除群成员 */
@property (strong, nonatomic) EMGroup *group;

@property ( strong, nonatomic ) NSArray *selectedAtMembers;
@property (nonatomic, copy) NSArray *alreadySelectedMembers;    /**< 开播时，已经选择了的好友们 */

@property (assign, nonatomic) id<EVChooseGroupMemberViewControllerDelegate> delegate;


- (void)setDismissCompletion:(DismissCompletion) completion;


- (void)setDisMissVC:(DisMissVC)disMissVC;
@end
