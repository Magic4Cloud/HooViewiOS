//
//  EVNewFriendItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVNewFriendItem : EVBaseObject
/*消息组数目**/
@property(nonatomic,assign) NSInteger count;
/*消息组对象数组，每个消息组对象包含如下信息：**/
@property (nonatomic,copy) NSString *groupid;
/*消息组标题**/
@property (nonatomic,copy) NSString *title;
/*消息组图标ur**/
@property(nonatomic,copy) NSString *icon;
/*消息组类型**/
@property (nonatomic,assign) NSInteger type;
/*未读消息数**/
@property (nonatomic,copy) NSString *unread;
/*总消息数**/
@property (nonatomic,assign) NSInteger total;
/*更新时间**/
@property (nonatomic,copy) NSString *update_time;

@end
