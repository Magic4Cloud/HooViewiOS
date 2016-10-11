//
//  EVSDKLiveMessageEngine.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EVAudience;

typedef NS_ENUM(NSInteger, EVSDKNewMessageType)
{
    EVSDKNewMessageTypeNone,
    EVSDKNewMessageTypeJoinUser,
    EVSDKNewMessageTypeLevelUser,
    EVSDKNewMessageTypeAllUser,
    EVSDKNewMessageTypeNewComment,
};

typedef NS_ENUM(NSInteger, EVSDKSpecialMessageType)
{
    EVSDKSpecialMessageTypeNone,
    EVSDKSpecialMessageTypeDanmu,
    EVSDKSpecialMessageTypeGift,
    EVSDKSpecialMessageTypeRedPacket,
    
};

typedef NS_ENUM(NSInteger, EVSDKLiveDataType)
{
    EVSDKLiveDataTypeNone,
    EVSDKLiveDataTypeLoveCount,
    EVSDKLiveDataTypeWatchingCount,
    EVSDKLiveDataTypeWatchedCount,
};



@protocol EVSDKMessageDelegate <NSObject>

- (void)successJoinTopic;

- (void)joinTopicIDNil;

- (void)updateLiveMessageType:(EVSDKNewMessageType)type data:(NSMutableArray *)data;

- (void)updateLiveSpecialMessageType:(EVSDKSpecialMessageType)type dict:(NSDictionary *)dict comment:(NSString *)comment;

- (void)updateLiveStatus:(BOOL)status;

- (void)updateLiveDataType:(EVSDKLiveDataType)type count:(long long)count;
@end



@interface EVSDKLiveMessageEngine : NSObject

@property (nonatomic, weak) id <EVSDKMessageDelegate> delegate;

@property (nonatomic, copy) NSString *topicVid;

//initsdk的
@property (nonatomic, copy) NSString *userData;

@property (nonatomic, copy) NSString *anchorName;

//- (void)oneSelfUserData:(EVAudience *)audience;

//连接聊天服务器
- (void)connectMessage;


/**
 *  获取头像的完整url
 *
 *  @param sufix
 *
 *  @return
 */
+ (NSString *)logourlWithLogoSufix:(NSString *)sufix;

@end
