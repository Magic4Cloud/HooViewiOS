//
//  EVFindUserInfo.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVFindUserInfo : EVBaseObject

@property (nonatomic,copy) NSString *name;              /**< 直播号 */
@property (nonatomic,copy) NSString *nickname;          /**< 昵称 */
@property (nonatomic,copy) NSString *logourl;           /**< 用户头像地址 */

/** 官方认证vip */
@property (nonatomic,assign) NSInteger vip;
@property (nonatomic,assign) NSUInteger fans_count;     /**< 粉丝数 */
@property (nonatomic,assign) NSUInteger like_count;     /**< 点赞数 */
@property (nonatomic,assign) BOOL followed;             /**< 关注关系:YES,关注；NO,没有关注 */
@property (nonatomic,copy) NSString *gender;            /**< 性别 */
@property (nonatomic,copy) NSString *signature;         /**< 签名 */

@end
