//
//  EVEaseMob.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVEaseMob.h"
#import "EMCDDeviceManager.h"
#import "EVBaseToolManager.h"
#import "EVLoginInfo.h"
#import "EVUserModel.h"
#import "NSObject+Extension.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVNotificationManager.h"


@interface ChatImageOptions : NSObject

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end

@interface EVEaseMob ()
{
    dispatch_queue_t _operation_queue;
}

@property (nonatomic,strong) EVBaseToolManager *engine;

@property (nonatomic,strong) NSMutableDictionary *contactsList;

@property (copy, nonatomic) NSString *userName;

@end

@implementation EVEaseMob

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}


//- (NSString *)currentUserName
//{
//    if ( _userName == nil )
//    {
//        if ( self.chatManager )
//        {
//            NSDictionary *info = [self.chatManager loginInfo];
//            _userName = [info objectForKey:@"username"];
//        }
//    }
//    
//    return _userName;
//}
//
//- (void )clear
//{
//    _userName = nil;
//}

+ (instancetype)cc_shareInstance
{
    static EVEaseMob *instance;
    static dispatch_once_t cc_onceToken;
    dispatch_once(&cc_onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//- (NSMutableDictionary *)contactsList
//{
//    if ( _contactsList == nil )
//    {
//        _contactsList = [NSMutableDictionary dictionary];
//    }
//    return _contactsList;
//}
//
//- (EVBaseToolManager *)engine
//{
//    if ( _engine == nil )
//    {
//        _engine = [[EVBaseToolManager alloc] init];
//    }
//    return _engine;
//}
//
//- (instancetype)init
//{
//    if ( self = [super init] )
//    {
//        [self setUp];
//    }
//    return self;
//}
//
//- (void)setUp
//{
//    _operation_queue = dispatch_queue_create("CCEaseMob_operation_queue", DISPATCH_QUEUE_SERIAL);
//    [EVNotificationCenter addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//    [EVNotificationCenter addObserver:self selector:@selector(enterForGround) name:UIApplicationDidBecomeActiveNotification object:nil];
//}
//
//- (void)enterForGround
//{
//    
//}
//
//- (void)memoryWarning
//{
//    self.contactsList = nil;
//    self.engine = nil;
//}
//
+ (void)checkAndAutoReloginWithLoginInfo:(EVLoginInfo *)info loginFail:(void(^)(EMError *error))loginFail
{
    if (info.imuser.length > 0 && info.impwd.length > 0) {
        NSString * imUser = info.imuser;
        NSString * impwd = info.impwd;
        EMError *error = [[EMClient sharedClient] loginWithUsername:imUser password:impwd];
        if (!error)
        {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
        else
        {
            loginFail(error);
        }
    }else {
        EMError *error = [[EMError alloc] init];
        error.errorDescription = @"账号密码错误";
        loginFail(error);
    }
    
   
}

+ (void)logoutIMLoginFail:(void(^)(EMError *error))loginFail
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        EVLog(@"退出成功");
    }else {
        loginFail(error);
    }
    
}
//
//+ (void)checkApplicationStateWithMessage:(EMMessage *)msg
//{
//    if ( [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
//    {
//        return;
//    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber++;
//    __block EVUserModel *item = [EVEaseMob cc_shareInstance].contactsList[msg.from];
//    
//    if ( item )
//    {
//        [self showMessage:msg withUserModel:item];
//        return;
//    }
//    
//    [EVUserModel getUserInfoModelWithIMUser:msg.from complete:^(EVUserModel *model) {
//        if ( model == nil )
//        {
//            [[EVEaseMob cc_shareInstance].engine GETBaseUserInfoWithUname:nil orImuser:msg.from start:nil fail:nil success:^(NSDictionary *modelDict) {
//                item = [EVUserModel objectWithDictionary:modelDict];
//                [item updateToLocalCacheComplete:nil];
//                [self showMessage:msg withUserModel:item];
//                [EVEaseMob cc_shareInstance].contactsList[msg.from] = item;
//            } sessionExpire:^{
//              //
//            }];
//        }
//        else
//        {
//            [self showMessage:msg withUserModel:model];
//            [EVEaseMob cc_shareInstance].contactsList[msg.from] = model;
//        }
//    }];
//}
//
//+ (void)showMessage:(EMMessage *)msg withUserModel:(EVUserModel *)model
//{
//    id<IEMMessageBody> body = [msg.messageBodies lastObject];
//    NSString *nickName = model.nickname;
//    
//    NSMutableString *alertbody = [NSMutableString string];
//    
//    [alertbody appendFormat:@"%@:", nickName];
//    
//    switch ( [body messageBodyType] )
//    {
//        case eMessageBodyType_Text:
//        {
//            EMTextMessageBody *textBody = (EMTextMessageBody *)body;
//            [alertbody appendString:textBody.text];
//        }
//            break;
//            
//        case eMessageBodyType_Image:
//        {
//            if ( msg.ext[kVid] )
//            {
//                [alertbody appendString:kE_GlobalZH(@"me_living_watch")];
//            }
//            else
//            {
//                [alertbody appendString:kE_GlobalZH(@"message_image")];
//            }
//        }
//            break;
//            
//        case eMessageBodyType_Location:
//            [alertbody appendString:kE_GlobalZH(@"message_shared_position")];
//            break;
//            
//        case eMessageBodyType_Voice:
//            [alertbody appendString:kE_GlobalZH(@"send_voice")];
//            break;
//            
//        default:
//            break;
//    }
//    
//    EVLocalNotification *noti = [EVLocalNotification localNotificationWithAlertBody:alertbody AlertAction:nil];
//    noti.userInfo = @{@"f" : model.imuser};
//    [[EVNotificationManager  shareNotificationManager] performLocalNotification:noti];
//}
//
//- (void)sendHasReadResponseForMessages:(NSArray*)messages
//{
//    __weak typeof(self) wself = self;
//    dispatch_async(_operation_queue, ^{
//        for (EMMessage *message in messages)
//        {
//            [wself.chatManager sendReadAckForMessage:message];
//        }
//    });
//}
//
//- (void)markMessagesAsRead:(NSArray*)messages atConversation:(EMConversation *)conversation
//{
//    dispatch_async(_operation_queue, ^{
//        for (EMMessage *message in messages)
//        {
//            [conversation markMessageWithId:message.messageId asRead:YES];
//        }
//    });
//}
//
- (void)registForAppWithOptions:(NSDictionary *)launchOptions
{
#ifdef STATE_DEV
    BOOL log = NO;
#else
    BOOL log = NO;
#endif
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAPPKey];
     options.apnsCertName = EaseMobCerName;
    options.enableConsoleLog = log;
    EMError *error =[[EMClient sharedClient] initializeSDKWithOptions:options];
    if ( error )
    {
        EVLog(@"ease mob register failure");
    }
    
//    [[EMClient sharedClient] application:[UIApplication sharedApplication]
//            didFinishLaunchingWithOptions:launchOptions];
    
    
    [self setupNotifiers];
}
//
//- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    [[EaseMob sharedInstance] application:[UIApplication sharedApplication] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//}
//
//#pragma mark - 免打扰设置
//+ (void)didnotReceiveMessageFrom:(NSUInteger)from endAt:(NSUInteger)endAt
//{
//    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
//    options.noDisturbStatus = ePushNotificationNoDisturbStatusCustom;
//    options.noDisturbingStartH = from;
//    options.noDisturbingEndH = endAt;
//    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
//}
//
//+ (void)enableNotDisturbAllDay:(BOOL)enable
//{
//    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
//    EMPushNotificationNoDisturbStatus status = enable ? ePushNotificationNoDisturbStatusDay : ePushNotificationNoDisturbStatusClose;
//    options.noDisturbStatus = status;
//    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
//}
//
//- (void)loginWithUserName:(NSString *)username password:(NSString *)password success:(void (^)(NSDictionary *))success fail:(void (^)(EMError *))fail
//{
//    dispatch_async(_operation_queue, ^{
//        EMError *error = nil;
//        NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:username password:password error:&error];
//        [self performBlockOnMainThread:^{
//            if ( error )
//            {
//                if ( fail )
//                {
//                    fail(error);
//                }
//            }
//            else
//            {
//                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//
//                if ( success )
//                {
//                    success(loginInfo);
//                }
//            }
//        }];
//    });
//}
//
//
//#pragma mark - function
//
//+ (EMMessage *)sendCmdMessageWithReceiver:(NSString *)receiver isChatGroup:(BOOL)isChatGroup cmd:(NSString *)cmd
//{
//    EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
//    cmdChat.cmd = cmd;
//    EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
//    // 生成message
//    EMMessage *message = [[EMMessage alloc] initWithReceiver:receiver bodies:@[body]];
//    message.messageType = eMessageTypeGroupChat;
//    [[EVEaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
//    return message;
//}
//
//+ (EMMessage *)sendTextMessageWithString:(NSString *)str
//                             toUsername:(NSString *)username
//                            isChatGroup:(BOOL)isChatGroup
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext
//{
//    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
//    return [self sendTextMessageWithString:str toUsername:username messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendTextMessageWithString:(NSString *)str
//                             toUsername:(NSString *)username
//                            messageType:(EMMessageType)type
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext
//{
//    EMChatText *text = [[EMChatText alloc] initWithText:str];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
//    return [self sendMessage:username messageBody:body messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
//                             toUsername:(NSString *)username
//                            isChatGroup:(BOOL)isChatGroup
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext
//{
//    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
//    return [self sendImageMessageWithImage:image toUsername:username messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
//                             toUsername:(NSString *)username
//                            messageType:(EMMessageType)type
//                      requireEncryption:(BOOL)requireEncryption
//                                    ext:(NSDictionary *)ext
//{
//    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
//    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
//    [options setCompressionQuality:0.6];
//    [chatImage setImageOptions:options];
//    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
//    return [self sendMessage:username messageBody:body messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendVoice:(EMChatVoice *)voice
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext
//{
//    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
//    return [self sendVoice:voice toUsername:username messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendVoice:(EMChatVoice *)voice
//             toUsername:(NSString *)username
//            messageType:(EMMessageType)type
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext
//{
//    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
//    return [self sendMessage:username messageBody:body messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendVideo:(EMChatVideo *)video
//             toUsername:(NSString *)username
//            isChatGroup:(BOOL)isChatGroup
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext
//{
//    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
//    return [self sendVideo:video toUsername:username messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendVideo:(EMChatVideo *)video
//             toUsername:(NSString *)username
//            messageType:(EMMessageType)type
//      requireEncryption:(BOOL)requireEncryption
//                    ext:(NSDictionary *)ext
//{
//    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
//    return [self sendMessage:username messageBody:body messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendLocationLatitude:(double)latitude
//                         longitude:(double)longitude
//                           address:(NSString *)address
//                        toUsername:(NSString *)username
//                       isChatGroup:(BOOL)isChatGroup
//                 requireEncryption:(BOOL)requireEncryption
//                               ext:(NSDictionary *)ext
//{
//    EMMessageType type = isChatGroup ? eMessageTypeGroupChat : eMessageTypeChat;
//    return [self sendLocationLatitude:latitude longitude:longitude address:address toUsername:username messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//+ (EMMessage *)sendLocationLatitude:(double)latitude
//                         longitude:(double)longitude
//                           address:(NSString *)address
//                        toUsername:(NSString *)username
//                       messageType:(EMMessageType)type
//                 requireEncryption:(BOOL)requireEncryption
//                               ext:(NSDictionary *)ext
//{
//    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
//    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
//    return [self sendMessage:username messageBody:body messageType:type requireEncryption:requireEncryption ext:ext];
//}
//
//// 发送消息
//+ (EMMessage *)sendMessage:(NSString *)username
//              messageBody:(id<IEMMessageBody>)body
//              messageType:(EMMessageType)type
//        requireEncryption:(BOOL)requireEncryption
//                      ext:(NSDictionary *)ext
//{
//    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username bodies:[NSArray arrayWithObject:body]];
//    retureMsg.requireEncryption = requireEncryption;
//    retureMsg.messageType = type;
//    retureMsg.ext = ext;
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil];
//    
//    return message;
//}
//
//- (void)remoteRegistDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    [[EaseMob sharedInstance] application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:error];
//}
//
#pragma mark - setUpNotification
- (void)setupNotifiers{
    [EVNotificationCenter addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [EVNotificationCenter addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appDidFinishLaunching:)
//                                                 name:UIApplicationDidFinishLaunchingNotification
//                                               object:nil];
//    
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appDidBecomeActiveNotif:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appWillResignActiveNotif:)
//                                                 name:UIApplicationWillResignActiveNotification
//                                               object:nil];
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appDidReceiveMemoryWarning:)
//                                                 name:UIApplicationDidReceiveMemoryWarningNotification
//                                               object:nil];
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appWillTerminateNotif:)
//                                                 name:UIApplicationWillTerminateNotification
//                                               object:nil];
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
//                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
//                                               object:nil];
//    
//    [EVNotificationCenter addObserver:self
//                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
//                                                 name:UIApplicationProtectedDataDidBecomeAvailable
//                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}
//
//- (void)appDidFinishLaunching:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
//}
//
//- (void)appDidBecomeActiveNotif:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
//}
//
//- (void)appWillResignActiveNotif:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
//}
//
//- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
//}
//
//- (void)appWillTerminateNotif:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
//}
//
//- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
//}
//
//- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
//{
//    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
//}
//
//#pragma mark - setupdelegate
//- (void)registerEaseMobNotification{
//    [self unRegisterEaseMobNotification];
//    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//}
//
//- (void)unRegisterEaseMobNotification{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//}
//
//#pragma mark - IChatManagerDelegate
//// 开始自动登录回调
//- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
//{
//    EVLog(@"开始自动登录回调----");
//}
//
//// 结束自动登录回调
//- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
//{
//    EVLog(@"结束自动登录回调----");
//}
//
//// 好友申请回调
//- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
//{
//    EVLog(@"好友申请回调----------");
//}
//
//// 离开群组回调
//- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
//{
//    EVLog(@"离开群组回调----");
//}
//
//// 申请加入群组被拒绝回调
//- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId groupname:(NSString *)groupname reason:(NSString *)reason error:(EMError *)error
//{
//    EVLog(@"申请加入群组被拒绝回调----");
//}
//
//// 接收到入群申请
//- (void)didReceiveApplyToJoinGroup:(NSString *)groupId :(NSString *)groupname applyUsername:(NSString *)username reason:(NSString *)reason error:(EMError *)error
//{
//    EVLog(@"接收到入群申请-----");
//}
//
//// 已经同意并且加入群组后的回调
//- (void)didAcceptInvitationFromGroup:(EMGroup *)group error:(EMError *)error
//{
//    EVLog(@"已经同意并且加入群组后的回调---");
//}
//
//// 绑定deviceToken回调
//- (void)didBindDeviceWithError:(EMError *)error
//{
//    EVLog(@"绑定deviceToken回调----");
//}
//
//// 网络状态变化回调
//- (void)didConnectionStateChanged:(EMConnectionState)connectionState
//{
//    EVLog(@"网络状态变化回调----");
//}
//
//// 打印收到的apns信息
//-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    EVLog(@"打印收到的apns信息----");
//}
//
//+ (NSArray *)allSortedConversationsUsingCompare:(NSComparisonResult (^)(EMConversation *, EMConversation *))compre
//{
//    NSArray *conversations = [[EVEaseMob cc_shareInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
//    if (compre) {
//        return [conversations sortedArrayUsingComparator:compre];
//    }
//    return conversations;
//}
//
//+ (void)setChatManagerDelegate:(id)obj
//{
//    [EMCDDeviceManager sharedInstance].delegate = obj;
//    [[EVEaseMob cc_shareInstance].chatManager removeDelegate:obj];
//    [[EVEaseMob cc_shareInstance].chatManager addDelegate:obj delegateQueue:nil];
//}

@end
