//
//  EVNotifyConversationItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotifyItem.h"
#import "EVEaseMob.h"
@class EVUserModel;

@interface EVNotifyConversationItem : EVNotifyItem

@property (strong, nonatomic) EMConversation *conversation;

@property (nonatomic,strong) EVUserModel *userModel;

@property (copy, nonatomic) NSString *im_update_time;

@property (copy, nonatomic) NSString *imuser;  //  当前会话人的云播号

@property (copy, nonatomic) NSString *currUserName;

@property (copy, nonatomic) NSString *nickName;

@property (copy, nonatomic) NSString *name;


/**
 *  从本地数据库获取数据
 *
 *  @param start    开始的索引
 *  @param count    取的条数
 *  @param complete 结束的回调
 */
+ (void)getConversationArrayFromDBStart:(NSInteger)start count:(NSInteger) count complete:(void (^)(NSArray *))complete;

/**
 *   设置最后一条消息
 *
 *  @param 会话的最后一条消息
 */
- (void)setLastMessage:(EMMessage *)latestMsg;

@end
