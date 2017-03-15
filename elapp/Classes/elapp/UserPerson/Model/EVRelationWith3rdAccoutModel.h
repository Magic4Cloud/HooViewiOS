//
//  EVRelationWith3rdAccoutModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVRelationWith3rdAccoutModel : EVBaseObject<NSCoding>

@property (copy, nonatomic) NSString *type;             /**< 账号类型：phone，手机号；sina，新浪微博；qq，qq账号；weixin，微信账号 */
@property (copy, nonatomic) NSString *token;            /**< 用户token信息 */
@property (copy, nonatomic) NSString *expire_time;      /**< token失效时刻 */
@property (assign, nonatomic) BOOL login;               /**< 是否为当前登录账号：NO，不是；YES，是 */

@end
