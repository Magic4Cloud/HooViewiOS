//
//  EVFriend.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"

@interface EVFriend : CCBaseObject

/** 好友 id */
@property (nonatomic,copy) NSString *friendId;
/** 好友的name */
@property (nonatomic,copy) NSString *name;
/** 好友的昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 用户头像 */
@property (nonatomic,copy) NSString *logourl;
/** 用户备注 */
@property (nonatomic,copy) NSString *remarks;
/** 环信号 */
@property (copy, nonatomic) NSString *imuser;
/** 是否是VIP */
@property (assign, nonatomic) NSInteger vip;
/** VIP等级 */
@property (assign, nonatomic) NSInteger vip_level;
/** 主播等级 */
@property (copy, nonatomic) NSString *anchor_level;

@property (copy, nonatomic) NSString *gender;

@property (assign, nonatomic) NSInteger level;




@end
