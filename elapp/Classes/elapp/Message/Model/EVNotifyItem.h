//
//  EVNotifyItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

@interface EVNotifyItem : CCBaseObject
/**消息id*/
@property(nonatomic,copy) NSString *Id;
/**标题*/
@property (nonatomic, copy) NSString *title;
/**头像*/
@property (nonatomic, copy) NSString *icon;
/**每条消息的id*/
@property (nonatomic, copy) NSString *message_id;
/**消息内容 */
@property (nonatomic, copy) NSString *content;
/**更新时间 */
@property(nonatomic,copy)NSString *update_time;

@property (copy, nonatomic) NSString *groupid;

@property (assign, nonatomic) int type;  //  消息组类型

@property (copy, nonatomic) NSString *total;  //  总消息数

@property (strong, nonatomic) NSDictionary *lastest_content;  //  最近一条消息

/**cell 返回的高度 */
@property(nonatomic,assign) CGFloat cellHeight;

@property (assign, nonatomic) NSInteger unread;

@property (assign, nonatomic) BOOL send_fail;


@end
