//
//  EVFanOrFollowerModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"


@interface EVFanOrFollowerModel : CCBaseObject

@property (copy, nonatomic) NSString *imuser;

/** 云播号 */
@property (copy, nonatomic) NSString *name;

/** 昵称 */
@property (copy, nonatomic) NSString *nickname;

/** 签名 */
@property (copy, nonatomic) NSString *signature;

/** 头像的 URL */
@property (copy, nonatomic) NSString *logourl;

/** 性别 */
@property (copy, nonatomic) NSString *gender;

/** 登录用户是否关注了这个人 0:未关注 1:关注 */
@property (assign, nonatomic) BOOL followed;

/** 登录用户是否订阅了这个人 0:未订阅 1:订阅 */
@property (assign, nonatomic) BOOL subscribed;

/** 登录用户是否被这个人关注了 0:未关注 1:关注 */
@property (assign, nonatomic) BOOL faned;

/** 官方认证vip */
@property (nonatomic,assign) NSInteger vip;

/** 用户的备注信息，主要用于备注用户的姓名 */
@property (copy, nonatomic) NSString *remarks;

@property (copy, nonatomic) NSString *recommend_reason;         /**< 推荐原因，根据type不同输出不同数据, */
@property (copy, nonatomic) NSString *pinyin;

/** VIP等级 */
@property (assign, nonatomic) NSInteger vip_level;
/** 主播等级 */
@property (copy, nonatomic) NSString *anchor_level;

@property (assign, nonatomic) NSInteger level;

@property (assign, nonatomic) BOOL selected; /**< 是否选中 */

@property (nonatomic,strong) NSIndexPath *indexPathInSearch;

@property (assign, nonatomic) BOOL disable;


@end
