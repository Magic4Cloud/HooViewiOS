//
//  EVNewFriendList.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

@interface EVNewFriendList : CCBaseObject
/*消息开始项**/
@property (nonatomic,copy)  NSString *start;
/*消息数目**/
@property (nonatomic,assign) NSInteger count;
/*消息下一组开始项**/
@property (nonatomic,copy) NSString *next;
/*消息对象数组，每个消息对象包含如下信息**/
@property (nonatomic,copy) NSString *items;
/*消息时间**/
@property (nonatomic,copy) NSString *time;
/*消息内容**/
@property (nonatomic,copy) NSString *content;

@end
