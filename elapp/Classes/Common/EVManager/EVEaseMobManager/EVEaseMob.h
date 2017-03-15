//
//  EVEaseMob.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite_CN/EMSDK.h>
@class EVLoginInfo,EMError;



@interface EVEaseMob : NSObject

//+ (instancetype)shareInstance;
+ (instancetype)cc_shareInstance;

//- (NSString *)currentUserName; /**< 当前用户的环信账号 */
//
//- (void )clear;
//
- (void)registForAppWithOptions:(NSDictionary *)launchOptions;
//

+ (void)checkAndAutoReloginWithLoginInfo:(EVLoginInfo *)info loginFail:(void(^)(EMError *error))loginFail;


+ (void)logoutIMLoginFail:(void(^)(EMError *error))loginFail;
//
//- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
//
//- (void)remoteRegistDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
//
//+ (void)checkApplicationStateWithMessage:(EMMessage *)msg;
//
//- (void)loginWithUserName:(NSString *)username password:(NSString *)password success:(void(^)(NSDictionary *loginInfo))success fail:(void(^)(EMError *error))fail;
//
//- (void)sendHasReadResponseForMessages:(NSArray*)messages;
//
//- (void)markMessagesAsRead:(NSArray*)messages atConversation:(EMConversation *)conversation;
//
///**
// *  指定时间段内免打扰 在 [from , endAt] 时间段内将收不到私信消息
// *  24 小时制
// *
// *  @param from  免打扰开始时间
// *  @param endAt 免打扰结束时间
// */
//+ (void)didnotReceiveMessageFrom:(NSUInteger)from endAt:(NSUInteger)endAt;
//
///**
// *  开启或者关闭全局面打扰
// *
// *  @param enable 
// */
//+ (void)enableNotDisturbAllDay:(BOOL)enable;
//
///**
// *  获取当前用户排序后的会话列表
// *
// *  @param compre 排序方式
// *
// *  @return
// */
//+ (NSArray *)allSortedConversationsUsingCompare:(NSComparisonResult(^)(EMConversation *conver1,EMConversation *conver2))compre;
//
//+ (void)setChatManagerDelegate:(id)obj;
//
//#pragma mark - function
//
///**
//
// *
// *  发送透传消息
// *
// *  @param receiver    接受者
// *  @param isChatGroup 是否是群组消息
// *  @param cmd         命令(与Android共同约定)
// *
// *  @return 消息
// */
//+ (EMMessage *)sendCmdMessageWithReceiver:(NSString *)receiver isChatGroup:(BOOL)isChatGroup cmd:(NSString *)cmd;
//
///**
// *  发送文字消息（包括系统表情）
// *
// *  @param str               发送的文字
// *  @param username          接收方
// *  @param isChatGroup       是否是群聊
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendTextMessageWithString:(NSString *)str
//                             toUsername:(NSString *)username
//                            isChatGroup:(BOOL)isChatGroup
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext;
//
///**
// *  发送文字消息（包括系统表情）
// *
// *  @param str               发送的文字
// *  @param username          接收方
// *  @param messageType       消息类型
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendTextMessageWithString:(NSString *)str
//                             toUsername:(NSString *)username
//                            messageType:(EMMessageType)type
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext;
//
///**
// *  发送图片消息
// *
// *  @param image             发送的图片
// *  @param username          接收方
// *  @param isChatGroup       是否是群聊
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
//                             toUsername:(NSString *)username
//                            isChatGroup:(BOOL)isChatGroup
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext;
//
///**
// *  发送图片消息
// *
// *  @param image             发送的图片
// *  @param username          接收方
// *  @param messageType       消息类型
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
//                             toUsername:(NSString *)username
//                            messageType:(EMMessageType)type
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext;
//
///**
// *  发送音频消息
// *
// *  @param voice             发送的音频
// *  @param username          接收方
// *  @param isChatGroup       是否是群聊
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendVoice:(EMChatVoice *)voice
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext;
//
///**
// *  发送音频消息
// *
// *  @param voice             发送的音频
// *  @param username          接收方
// *  @param messageType       消息类型
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendVoice:(EMChatVoice *)voice
//             toUsername:(NSString *)username
//            messageType:(EMMessageType)type
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext;
///**
// *  发送位置消息（定位）
// *
// *  @param latitude          经度
// *  @param longitude         纬度
// *  @param address           位置描述信息
// *  @param username          接收方
// *  @param isChatGroup       是否是群聊
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendLocationLatitude:(double)latitude
//                         longitude:(double)longitude
//                           address:(NSString *)address
//                        toUsername:(NSString *)username
//                       isChatGroup:(BOOL)isChatGroup
//                 requireEncryption:(BOOL)requireEncryption
//                               ext:(NSDictionary *)ext;
//
///**
// *  发送位置消息（定位）
// *
// *  @param latitude          经度
// *  @param longitude         纬度
// *  @param address           位置描述信息
// *  @param username          接收方
// *  @param messageType       消息类型
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendLocationLatitude:(double)latitude
//                         longitude:(double)longitude
//                           address:(NSString *)address
//                        toUsername:(NSString *)username
//                       messageType:(EMMessageType)type
//                 requireEncryption:(BOOL)requireEncryption
//                               ext:(NSDictionary *)ext;
//
///**
// *  发送视频文件消息
// *
// *  @param video             发送的视频
// *  @param username          接收方
// *  @param isChatGroup       是否是群聊
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendVideo:(EMChatVideo *)video
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext;
//
///**
// *  发送视频文件消息
// *
// *  @param video             发送的视频
// *  @param username          接收方
// *  @param messageType       消息类型
// *  @param requireEncryption 是否加密
// *  @param ext               扩展信息
// *  @return 封装的消息体
// */
//+ (EMMessage *)sendVideo:(EMChatVideo *)video
//             toUsername:(NSString *)username
//            messageType:(EMMessageType)type
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext;

@end
