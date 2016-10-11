//
//  EVMngUserListModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"
#import "EVUserModel.h"
@interface EVMngUserListModel : CCBaseObject
@property (copy, nonatomic) NSString *name;  /**< 云播号，string */
@property (copy, nonatomic) NSString *logourl;  /**< 用户头像链接地址，string */
@property (copy, nonatomic) NSString *nickname;  /**< 昵称，string */
@property (copy, nonatomic) NSString *gender;  /**< 性别，string，male表示男性，female表示女性 */
@property (assign, nonatomic) NSUInteger riceroll; /**< 云票数，long */
@property (copy, nonatomic) NSString *signature;  /**< 签名 */

@property (nonatomic, assign) NSInteger total;
@end
