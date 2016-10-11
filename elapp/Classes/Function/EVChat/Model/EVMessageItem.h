//
//  EVMessageItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EVEaseMob.h"

@class EVMessageItemFrame,EMMessage;

typedef NS_ENUM(NSInteger, CCMessageFrom)
{
    CCMessageFromSend,
    CCMessageFromReceive
};

typedef NS_ENUM(NSInteger, CCMessageType)
{
    CCMessageText ,
    CCMessageVoice,
    CCMessageImage ,
};

@interface EVMessageItem : NSObject

- (instancetype)initWith:(EMMessage *)message;

@property (nonatomic,strong) NSDictionary *ext;

@property (nonatomic,strong) EMMessage *message;
@property (nonatomic,copy) NSString *nickName;
@property (copy, nonatomic) NSString *name;

/*!
 @property
 @brief 语音时长, 秒为单位
 */
@property (nonatomic, assign) NSInteger time;
@property (nonatomic,copy) NSString *voiceLocationPath;
@property (nonatomic,copy) NSString *voiceRemotePath;

@property (nonatomic,copy) NSString *address;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic,copy) NSString *localImagePath;
@property (nonatomic,copy) NSString *remoteImagePath;

@property (nonatomic,copy) NSString *logourl;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,strong) UIImage *thumbImage;

@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) CCMessageFrom messageFrom;
@property (nonatomic, assign) CCMessageType messageType;

@property (nonatomic,strong) EVMessageItemFrame *messageFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (assign, nonatomic , readonly) BOOL isRead; //  消息是否已读

@property (assign, nonatomic , readonly) MessageDeliveryState deliveryState;

@end
