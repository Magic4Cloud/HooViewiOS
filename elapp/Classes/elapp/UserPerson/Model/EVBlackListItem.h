//
//  EVBlackListItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"
#import "EVUserModel.h"

@interface EVBlackListItem : CCBaseObject

@property (assign, nonatomic) BOOL selected;    /**< 是否选中 */
@property (copy, nonatomic) NSString *logoUrl;  /**< 头像url */
@property (copy, nonatomic) NSString *name;     /**< 云播号 */
@property (copy, nonatomic) NSString *nickName; /**< 昵称 */
@property (assign, nonatomic) BOOL showLeftBtn; /**< 是否显示左侧按钮 */
@property (assign, nonatomic) BOOL isVip;       /**< 是否是vip */
@property (copy, nonatomic) NSString *imUser;   /**< 环信账号 */



@property ( strong, nonatomic ) EVUserModel *userModel;
@end
