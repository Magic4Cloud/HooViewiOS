//
//  EVGroupItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"

@class EMMessage;
@class EMGroup;

@interface EVGroupItem : CCBaseObject

@property (copy, nonatomic) NSString *icon;     /**< 头像 */
@property (copy, nonatomic) NSString *subject;  /**< 名字 */
@property (copy, nonatomic) NSString *time;     /**< 最后一条消息时间 */
@property (copy, nonatomic) NSString *lastMessage;  /**< 最后一条消息的内容 */
@property (copy, nonatomic) NSString *ID;
@property (assign, nonatomic) NSInteger unread;
@property (copy, nonatomic) NSString *owner;
@property ( strong, nonatomic ) NSArray *members;
@property (assign, nonatomic) BOOL isAtMessage;
@property (assign, nonatomic) BOOL isRedEnvelope;
@property (copy, nonatomic) NSString *firstAtMessage;



/**
 *  @author 杨尚彬
 *
 *  通过消息创建新的对象
 *
 *  @param message 环信消息
 *
 *  @return 新的对象
 */
+ (EVGroupItem *)groupItemWithMessage:(EMMessage *)message;

/**
 *  @author 杨尚彬
 *
 *  更新groupitem对象
 *
 *  @param message 环信消息
 */
- (void)updateWithMessage:(EMMessage *)message;

/**
 *  @author 杨尚彬
 *
 *  通过EMGroup数组获取CCGroupItem对象数组
 *
 *  @param groups EMGroup数组
 *
 *  @return CCGroupItem数组
 */
+ (NSArray<EVGroupItem *> *)groupItemsWithGroups:(NSArray<EMGroup *> *)groups;

/**
 *  @author 杨尚彬
 *
 *
 *
 *  @param group 
 */
- (void)updateWithGroup:(EMGroup *)group;

/**
 *  @author 杨尚彬
 *
 *  通过id获取对象
 *
 *  @param groupId id
 *
 *  @return 
 */
+ (instancetype )groupitemWithId:(NSString *)groupId;

+ (BOOL)isAtMessage:(EMMessage *)message;

@end
