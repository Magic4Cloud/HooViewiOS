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
    EVSDKNewMessageTypeShutUser,
    EVSDKNewMessageTypeMngUser,
    EVSDKNewMessageTypeKickUser,
};

typedef NS_ENUM(NSInteger, EVSDKSpecialMessageType)
{
    EVSDKSpecialMessageTypeNone,
    EVSDKSpecialMessageTypeDanmu,
    EVSDKSpecialMessageTypeGift,
    EVSDKSpecialMessageTypeRedPacket,
    EVSDKSpecialMessageTypeLink,
    
};

typedef NS_ENUM(NSInteger, EVSDKLiveDataType)
{
    EVSDKLiveDataTypeNone,
    EVSDKLiveDataTypeLoveCount,
    EVSDKLiveDataTypeWatchingCount,
    EVSDKLiveDataTypeWatchedCount,
};

@protocol EVSDKMessageDelegate <NSObject>
@optional
- (void)updateMessageLoveCount:(long long)loveCount;

- (void)updateMessageWatchingCount:(long long)watchingCount;

- (void)updateMessageWatchedCount:(long long)watchedCount;

- (void)updateMessageRiceRoll:(long long)riceRoll;

- (void)updateMessageLinkDict:(NSDictionary *)dict comment:(NSString *)comment;

- (void)updateMessageRedPacketDict:(NSDictionary *)dict;

- (void)updateMessageGiftDict:(NSDictionary *)dict;

- (void)updateMessasgeDanmuDict:(NSDictionary *)dict comment:(NSString *)comment;

- (void)updateMessageLevelUserData:(NSMutableArray *)data;

- (void)updateMessageJoinUserData:(NSMutableArray *)data;

- (void)updateMessageAllUserData:(NSMutableArray *)data;

- (void)updateMessageNewCommentData:(NSMutableArray *)data isHistory:(BOOL)isHistory;

- (void)updateMessageShutUserData:(NSMutableArray *)data;

- (void)updateMessageKickUserData:(NSMutableArray *)data;

- (void)updateMessageMngUserData:(NSMutableArray *)data;

- (void)successJoinTopic;

- (void)joinTopicIDNil;

- (void)updateLiveStatus:(BOOL)status;
@end


@interface EVSDKLiveMessageEngine : NSObject

@property (nonatomic, weak) id <EVSDKMessageDelegate> delegate;

@property (nonatomic, copy) NSString *topicVid;
//initsdk的
@property (nonatomic, copy) NSString *userData;

@property (nonatomic, copy) NSString *anchorName;

@property (nonatomic, assign) BOOL levelTopic;

- (void)loginConnect;

- (void)loadHistoryData;

- (void)loadMoreHistoryDataSuccess:(void(^)())success;
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
