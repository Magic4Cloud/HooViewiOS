//
//  EVUserModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"
@class EVLoginInfo;

#define CCUserModelUpdateToLocalNotification @"CCUserModelUpdateToLocalNotification"
#define CCUpdateUserModel   @"CCUpdateUserModel"


@interface EVUserModel : EVBaseObject

@property (copy, nonatomic) NSString *name;                 /**< 用户云播号 */
@property (copy, nonatomic) NSString *phone;                /**< 手机号 */
@property (copy, nonatomic) NSString *nickname;             /**< 昵称 */
@property (copy, nonatomic) NSString *logourl;              /**< 头像地址 */
@property (copy, nonatomic) NSString *gender;               /**< 性别：male，男；female，女 */


@property (copy, nonatomic) NSString *signature;            /**< 签名 */
@property (copy, nonatomic) NSString *birthday;             /**< 生日 */
@property (copy, nonatomic) NSString *location;             /**< 地理位置 */
@property (copy, nonatomic) NSString *authtype;             /**< 登录方式：phone，手机号；sina，新浪微博；qq，qq账号；weixin，微信账号 */
@property (copy, nonatomic) NSString *shortid;              /**< 云播号短id */
@property (copy, nonatomic) NSString *invite_url;           /**< 邀请好友地址 */
@property (nonatomic,copy) NSString *invite_register_url;   /** 邀请好友注册地址 */
@property (copy, nonatomic) NSString *sessionid;            /**< 登录sessionid */
@property (assign, nonatomic) BOOL followed;                /**< 用户与目标用户的关注关系：NO，未关注；YES，已关注 */
@property (assign, nonatomic) NSUInteger follow_count;       /**< 关注用户数 */
@property (assign, nonatomic) NSUInteger fans_count;         /**< 粉丝数 */
@property (assign, nonatomic) NSUInteger video_count;       /**< 录播数 */
@property (assign, nonatomic) NSUInteger audio_count;        /**< 音频数 */
@property (strong, nonatomic) NSArray *auth;                /**< 用户绑定账号关系:CCRelationWith3rdAccoutModel的数组 */
/**添加vip标志*/
@property (nonatomic, assign) NSInteger vip;

/** 用来表示是否当前用户，用在直播和观看页面显示观众信息中 */
@property (nonatomic, assign) BOOL is_current_user;

/** 私信号 */
@property (nonatomic,copy) NSString *imuser;

@property (assign, nonatomic) NSInteger sign_days;          /**< 连续签到天数 */
@property (assign, nonatomic) NSInteger score;              /**< 用户积分 */
@property (copy, nonatomic) NSString *score_url;            /**< 积分详情URL */
@property (assign, nonatomic) NSInteger sendecoin;          /**< 送出的火眼豆数 */
@property (assign, nonatomic) NSInteger recvgift;           /**< 收到的礼物数 */
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *credentials;          /**< 执业证号 */

/**
 *  根据用户的云播号来从本地数据库查询对应的用户基本信息
 *
 *  @param name     云播号
 *  @param complete 查询结束的block
 */
+ (void)getUserInfoModelWithName:(NSString *)name complete:(void(^)(EVUserModel *model))complete;

/**
 *  通过im账号来获取本地数据库中的用户基本信息
 *
 *  @param imuser    环信账号
 *  @param complete
 */
+ (void)getUserInfoModelWithIMUser:(NSString *)imuser complete:(void(^)(EVUserModel *model))complete;

/**
 *  根据云播号更新关注状态到本地数据，如果本地数据库不存在该云播号则不更新
 *
 *  @param name     云播号
 *  @param follow   关注状态
 *  @param complete
 */
+ (void)updateFollowStateWithName:(NSString *)name followed:(BOOL)follow completet:(void(^)(EVUserModel *model))complete;

/**
 *  把loginInfo转化为userInfo
 *
 *  @param loginInfo 从本地获取的登录信息
 *
 *  @return userInfo
 */
+ (instancetype)getUserInfoModelFromLoginInfo:(EVLoginInfo *)loginInfo;

@end
