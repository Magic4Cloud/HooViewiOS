//
//  EVNotifyList.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVNotifyList : EVBaseObject
/**消息id*/
@property (nonatomic, copy) NSString *id;
/**每组的消息id*/
@property (nonatomic, copy) NSString *group_id;
/**消息内容*/
@property (nonatomic, copy) NSString *content;
/**消息时间*/
@property (nonatomic, copy) NSString *create_time;
/**消息标题*/
@property (nonatomic, copy) NSString *title;
/**返回cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;

@end
