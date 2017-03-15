//
//  EVNotifyMessageItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

@interface EVNotifyMessageItem : EVBaseObject

@property (assign, nonatomic) int type;

@property (copy, nonatomic) NSString *text;   //  文本消息

@property (copy, nonatomic) NSString *graphic;  //  图片地址

@property (copy, nonatomic) NSString *title;  //  标题

@property (copy, nonatomic) NSString *desc;

@property (copy, nonatomic) NSString *name;  // 关注消息的云播号

@property (copy, nonatomic) NSString *nickname;  // 昵称

@property (copy, nonatomic) NSString *remarks;  // 备注

@property (copy, nonatomic) NSString *gender;

@property (copy, nonatomic) NSString *signature;

@property (copy, nonatomic) NSString *vip;

@property (copy, nonatomic) NSString *logourl;

@property (copy, nonatomic) NSString *followed;



@end
