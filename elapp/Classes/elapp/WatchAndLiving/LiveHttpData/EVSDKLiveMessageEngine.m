//
//  EVSDKLiveMessageEngine.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSDKLiveMessageEngine.h"
#import "EVMessageManager.h"
#import "EVBaseToolManager.h"
#import "EVBaseToolManager+EVSDKMessage.h"
#import "EVUserModel.h"
#import "EVSDKLiveEngineParams.h"
#import "NSString+Extension.h"
#import "EVAudience.h"
#import "EVComment.h"
#import "EVSDKInitManager.h"



@interface EVSDKLiveMessageEngine ()<EVMessageProtocol>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *joinUserArray;

@property (nonatomic, strong) NSMutableArray *allUserArray;

@property (nonatomic, strong) NSMutableArray *levelUserArray;

@property (nonatomic, strong) NSMutableArray *newCommentArray;

@property (nonatomic, assign) long long  lastTimeLikeCount;

@property (nonatomic, assign) BOOL isInitSDKSuccess;


@property (nonatomic, assign) NSInteger start;

@end

@implementation EVSDKLiveMessageEngine
#pragma mark - 新的连接聊天服务器
- (void)connectMessage
{
    [EVMessageManager shareManager].delegate = self;
    [[EVMessageManager shareManager] connect];
    self.start = 10;
}

#pragma mark - message delegate
- (void)EVMessageConnected
{
    WEAK(self)
    [self clearAllUserArray];
    if ((self.topicVid == nil && [self.topicVid isEqualToString:@""]) || self.levelTopic) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(joinTopicIDNil)]) {
            [self.delegate joinTopicIDNil];
        }
        return;
    }
    [[EVMessageManager shareManager] joinTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode, NSArray<NSString *> *privateInfos, NSArray<NSString *> *users, NSArray<NSString *> *kickusers, NSArray<NSString *> *managers, NSArray<NSString *> *shutups) {
        //        __strong typeof(self) weakSelf = self;
        NSMutableArray *newsUsers = [NSMutableArray arrayWithArray:users];
        for (NSString *oneUser in users) {
            if ([oneUser isEqualToString:_anchorName]) {
                [newsUsers removeObject:oneUser];
            }
        }
        if (isSuccess == YES) {
            [weakself loadHistoryData];
            if (newsUsers.count > 0) {
                NSString *userNames = [NSString stringWithArray:newsUsers];
                [weakself userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
                    NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[EVMessageKeyUsers]];
                    [self.allUserArray addObjectsFromArray:userModelArray];
                    [self updateLiveUserMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
                }];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(successJoinTopic)]) {
                
                [self.delegate successJoinTopic];
                self.isInitSDKSuccess = YES;
            }
            for (NSDictionary *dict in privateInfos) {
                if ([[dict allKeys] containsObject:@"riceroll"]) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageRiceRoll:)]) {
                        [self.delegate updateMessageRiceRoll:[dict[@"riceroll"] longLongValue]];
                    }
                }
            }
            
            
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (errorCode == EVMessageErrorSDKNotInit) {
                    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"init错误" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                    [alertV show];
                    [EVSDKInitManager initMessageSDKUserData:self.userData];
                }else {
                    [self EVMessageConnected];
                }
            });
        }
    }];
 
}

- (void)loadHistoryData
{
    [[EVMessageManager shareManager] getLatestHistoryMessagesInTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode, NSDictionary *response) {
        NSArray *dataArray = response[@"list"];
        EVLog(@"response--------------  %@",response);
        for (NSDictionary *dict in dataArray) {
            [self.newCommentArray removeAllObjects];
            NSString *comment = dict[@"comment"];
            NSData *data = [comment dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary  *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([params allKeys].count > 0) {
                NSString *userdata = params[@"userdata"];
                NSData *userD = [userdata dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary  *userparams = [NSJSONSerialization JSONObjectWithData:userD options:0 error:&error];
                NSString *message = params[@"context"];
                EVComment *comment = [[EVComment alloc]init];
                [comment updateWithCommentInfo:userparams[EVMessageKeyExct] contextInfo:message userid:dict[@"userid"] commentType:CCCommentComment];
                [self.newCommentArray addObject:comment];
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageNewCommentData:isHistory:)]) {
                    [self.delegate updateMessageNewCommentData:self.newCommentArray isHistory:YES];
                }
            }
        }
    }];
}


- (void)loadMoreHistoryDataSuccess:(void(^)())success
{

    [[EVMessageManager shareManager] getHitoryMessagesWithStart:self.start count:15 inTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode, NSDictionary *response) {
        EVLog(@"responsemore--------------  %@",response);
        if (success) {
            success();
        }
        NSArray *dataArray = response[@"list"];
        self.start = self.start+dataArray.count;
        for (NSDictionary *dict in dataArray) {
            [self.newCommentArray removeAllObjects];
            NSString *comment = dict[@"comment"];
            NSData *data = [comment dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary  *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([params allKeys].count > 0) {
                NSString *userdata = params[@"userdata"];
                NSData *userD = [userdata dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary  *userparams = [NSJSONSerialization JSONObjectWithData:userD options:0 error:&error];
                NSString *message = params[@"context"];
                EVComment *comment = [[EVComment alloc]init];
                [comment updateWithCommentInfo:userparams[EVMessageKeyExct] contextInfo:message userid:dict[@"userid"] commentType:CCCommentComment];
                [self.newCommentArray addObject:comment];
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageNewCommentData:isHistory:)]) {
                    [self.delegate updateMessageNewCommentData:self.newCommentArray isHistory:YES];
                }
            }
        }
    }];
}


- (void)loginConnect
{
    [[EVMessageManager shareManager] connect];
}

- (void)EVMessageConnectError:(NSError *)error
{
    //init失败
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (error.code == -2001) {
            if (self.isInitSDKSuccess == NO) {
                [EVSDKInitManager initMessageSDKUserData:self.userData];
                [self loginConnect];
            }
        }else {
            [[EVMessageManager shareManager] connect];
        }
    });
}

- (void)userMessageInfoName:(NSString *)userNames success:(void(^)(NSDictionary *modelDict))success
{
    WEAK(self)
    if ((self.topicVid == nil && [self.topicVid isEqualToString:@""]) || self.levelTopic) {
        return;
    }
    [self.baseToolManager GETBaseUserInfoListWithUname:userNames start:nil fail:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakself userMessageInfoName:userNames success:success];
        });
    } success:success sessionExpire:^{
        EVLog(@"session过期");
    }];
}

/**
 *  接收到新消息
 *
 *  @param topic    话题
 *  @param userid   用户 id
 *  @param message  消息内容
 *  @param userData 自定义消息
 */
- (void)EVMessageRecievedNewMessageInTopic:(NSString *)topic
                                sendedFrom:(NSString *)userid
                                   message:(NSString *)message
                                  userData:(NSString *)userData
{
    [self.newCommentArray removeAllObjects];
    NSArray *array = [userData componentsSeparatedByString:@"="]; //从字符A中分隔成2个元素的数组
    NSString *msg;
    if (array.count >= 2) {
        msg = [NSString stringWithFormat:@"%@",array[1]];
    }
     NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)msg, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    if (decodedString.length > 0) {
        userData = [NSString stringWithFormat:@"%@",decodedString];
    }
    NSString *contentStr  = [NSString stringWithFormat:@"%@",userData];
    NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        return;
    }
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];;
    NSArray *allDictKeys = [params allKeys];
    if ([allDictKeys containsObject:EVMessageKeyExct]) {
        EVComment *comment = [[EVComment alloc]init];
        [comment updateWithCommentInfo:params[EVMessageKeyExct] contextInfo:message userid:userid commentType:CCCommentComment];
        [self.newCommentArray addObject:comment];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageNewCommentData:isHistory:)]) {
            [self.delegate updateMessageNewCommentData:self.newCommentArray isHistory:NO];
        }

    }else if ([allDictKeys containsObject:EVMessageKeyExbr]) {
    
        EVComment *comment = [[EVComment alloc]init];
        [comment updateWithCommentInfo:params[EVMessageKeyExbr] contextInfo:message userid:userid commentType:CCCommentComment];
         [self.newCommentArray addObject:comment];
        [self updateLiveUserMessageType:EVSDKNewMessageTypeNewComment data:self.newCommentArray];
       
        [self updateLiveMessageType:EVSDKSpecialMessageTypeDanmu dict:params comment:message];
    }else if ( [allDictKeys containsObject:EVMessageKeyLvst] ){
        BOOL liveStatus = [params[EVMessageKeyLvst][EVMessageKeySt] boolValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveStatus:)]) {
            [self.delegate  updateLiveStatus:liveStatus];
        }
    }else if ([allDictKeys containsObject:EVMessageKeyExgf]){
        NSDictionary *dict = params[EVMessageKeyExgf];
        EVComment *comment = [[EVComment alloc]init];
        [comment updateWithCommentInfo:params[EVMessageKeyExgf] contextInfo:message userid:userid commentType:CCCommentPresent];
        [self.newCommentArray addObject:comment];
//        [self updateLiveUserMessageType:EVSDKNewMessageTypeNewComment data:self.newCommentArray];
        [self updateLiveMessageType:EVSDKSpecialMessageTypeGift dict:dict comment:nil];
    }else  if ([allDictKeys containsObject:EVMessageKeyExrp]){
        NSDictionary *dict = params[EVMessageKeyExrp];
        [self updateLiveMessageType:EVSDKSpecialMessageTypeRedPacket dict:dict comment:nil];
    }else if ([allDictKeys containsObject:EVMessageKeyVclt]){
        NSDictionary *dict = params[EVMessageKeyVclt];
        [self updateLiveMessageType:EVSDKSpecialMessageTypeLink dict:dict comment:userid];
    }else {
        
    }
}

/**
 *  有用户加入话题
 *
 *  @param userids 加入的用户
 *  @param topic   话题
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
           joinedTopic:(NSString *)topic
{
    if (userids.count > 0) {
        NSMutableArray *userArray = [self DistinctArray:userids];
        NSString *userNames = [NSString stringWithArray:userArray];
        [self.newCommentArray removeAllObjects];
        [self userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
            NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[@"users"]];
            [self.allUserArray addObjectsFromArray:userModelArray];
            NSArray *userArray = modelDict[@"users"];
            //NSDictionary *userDict = userArray[0];
            EVComment *comment = [[EVComment alloc]init];
            [comment updateWithCommentInfo:userArray[0] contextInfo:@"进入直播间" userid:nil commentType:CCCommentFocus];
            [self.newCommentArray addObject:comment];
            [self updateLiveUserMessageType:EVSDKNewMessageTypeJoinUser data:self.newCommentArray];
            [self updateLiveUserMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
        }];
    }
    
}

- (void)EVMessageUsers:(NSArray <NSString *>*)userids
             leftTopic:(NSString *)topic
{
    if (userids.count > 0) {
        NSMutableArray *userArray = [self DistinctArray:userids];
        NSString *userNames = [NSString stringWithArray:userArray];
        [self.levelUserArray removeAllObjects];
        [self userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
            NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[@"users"]];
            NSMutableArray *levelAllArray = [NSMutableArray arrayWithArray:userModelArray];
            for (EVUserModel *userModel in levelAllArray) {
                [self.allUserArray removeObject:userModel];
            }
            [self updateLiveUserMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
            [self.levelUserArray addObjectsFromArray:userModelArray];
            [self updateLiveUserMessageType:EVSDKNewMessageTypeLevelUser data:self.levelUserArray];
           
        }];
    }
   
}

- (void)EVMessageShutupWithUsers:(NSArray <NSString *>*)users
                       operation:(EVMessageOperationCode)operation
                         inTopic:(NSString *)topic
{
    EVLog(@"shutup-------  %@ ------------ %ld ----------------- %@",users,operation,topic);
    [self updateLiveUserMessageType:EVSDKNewMessageTypeShutUser data:users.mutableCopy];
}

- (void)EVMessageKickUserWithUsers:(NSArray <NSString *>*)users
                         operation:(EVMessageOperationCode)operation
                           inTopic:(NSString *)topic
{
    EVLog(@"kickuser-------  %@ ------------ %ld ----------------- %@",users,operation,topic);
   
    [self updateLiveUserMessageType:EVSDKNewMessageTypeKickUser data:users.mutableCopy];
}

- (void)EVMessageManagerWithUsers:(NSArray <NSString *>*)users
                        operation:(EVMessageOperationCode)operation
                          inTopic:(NSString *)topic
{
     EVLog(@"manager-------  %@ ------------ %ld ----------------- %@",users,operation,topic);
    [self updateLiveUserMessageType:EVSDKNewMessageTypeMngUser data:users.mutableCopy];
    
}

- (void)EVMessageDidUpdateLikeCount:(long long)likeCount
                            inTopic:(NSString *)topic
{
    EVLog(@"%lld     ----------------------------------",likeCount);
    [self updateMessageLiveDataType:EVSDKLiveDataTypeLoveCount count:likeCount];
}

- (void)EVMessageDidUpdateWatchingCount:(NSInteger)watchingCount
                                inTopic:(NSString *)topic
{
 
    [self updateMessageLiveDataType:EVSDKLiveDataTypeWatchingCount count:watchingCount];
}

- (void)EVMessageDidUpdateWatchedCount:(NSInteger)watchedCount
                               inTopic:(NSString *)topic
{
    
    [self updateMessageLiveDataType:EVSDKLiveDataTypeWatchedCount count:watchedCount];
}


- (void)updateLiveUserMessageType:(EVSDKNewMessageType)type data:(NSMutableArray *)data
{
    switch (type) {
        case EVSDKNewMessageTypeNone:
            
            break;
        case EVSDKNewMessageTypeJoinUser:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageJoinUserData:)]) {
                [self.delegate updateMessageJoinUserData:data];
            }
            
            break;
            
        case EVSDKNewMessageTypeLevelUser:
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageLevelUserData:)]) {
                [self.delegate updateMessageLevelUserData:self.levelUserArray];
            }
            break;
            
        case EVSDKNewMessageTypeAllUser:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageAllUserData:)]) {
                [self.delegate updateMessageAllUserData:self.allUserArray];
            }
            break;
            
        case EVSDKNewMessageTypeNewComment:
            
           
            break;
        case EVSDKNewMessageTypeKickUser:
           
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageShutUserData:)]) {
                [self.delegate updateMessageShutUserData:data];
            }
            
            break;
        case EVSDKNewMessageTypeMngUser:
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageMngUserData:)]) {
                [self.delegate updateMessageMngUserData:data];
            }
            break;
        case EVSDKNewMessageTypeShutUser:
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageShutUserData:)]) {
                [self.delegate updateMessageShutUserData:data];
            }
            
            break;
        default:
            break;
    }
}

- (void)updateLiveMessageType:(EVSDKSpecialMessageType)type dict:(NSDictionary *)dict comment:(NSString *)comment
{
    switch (type) {
        case EVSDKSpecialMessageTypeNone:
            
            break;
        case EVSDKSpecialMessageTypeGift:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageGiftDict:)]) {
                [self.delegate updateMessageGiftDict:dict];
            }
        }

            break;
        case EVSDKSpecialMessageTypeDanmu:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessasgeDanmuDict:comment:)]) {
                [self.delegate updateMessasgeDanmuDict:dict comment:comment];
            }
            
            break;
        case EVSDKSpecialMessageTypeRedPacket:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageRedPacketDict:)]) {
                [self.delegate updateMessageRedPacketDict:dict];
            }
            break;
        case EVSDKSpecialMessageTypeLink:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageLinkDict:comment:)]) {
                [self.delegate updateMessageLinkDict:dict comment:comment];
            }
            break;
        default:
            break;
    }
}

- (void)updateMessageLiveDataType:(EVSDKLiveDataType)type count:(long long)count
{
    switch (type) {
        case EVSDKLiveDataTypeNone:
            
            break;
        case EVSDKLiveDataTypeLoveCount:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageLoveCount:)]) {
                [self.delegate updateMessageLoveCount:count];
            }
            break;
        case EVSDKLiveDataTypeWatchedCount:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageWatchedCount:)]) {
                [self.delegate updateMessageWatchedCount:count];
            }
            break;
        case EVSDKLiveDataTypeWatchingCount:
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageWatchingCount:)]) {
                [self.delegate updateMessageWatchingCount:count];
            }
            break;
        default:
            break;
    }
}

- (void)EVMessageDidUpdateRiceRoll:(long long)riceRoll
                           inTopic:(NSString *)topic
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateMessageRiceRoll:)]) {
        [self.delegate updateMessageRiceRoll:riceRoll];
    }
    
}

- (void)clearAllUserArray
{
    [self.allUserArray removeAllObjects];
}

- (void)dealloc
{
    [self.baseToolManager cancelAllOperation];
}

- (void)setAnchorName:(NSString *)anchorName
{
    _anchorName = anchorName;
}

- (void)setTopicVid:(NSString *)topicVid
{
    _topicVid = topicVid;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc]init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)joinUserArray
{
    if (!_joinUserArray) {
        _joinUserArray = [NSMutableArray array];
    }
    return _joinUserArray;
}

- (NSMutableArray *)levelUserArray
{
    if (!_levelUserArray) {
        _levelUserArray = [NSMutableArray array];
    }
    return _levelUserArray;
}


- (NSMutableArray *)allUserArray
{
    if (!_allUserArray) {
        _allUserArray = [NSMutableArray array];
    }
    return _allUserArray;
}

- (NSMutableArray *)newCommentArray
{
    if (!_newCommentArray) {
        _newCommentArray = [NSMutableArray array];
    }
    
    return _newCommentArray;
}


+ (NSString *)logourlWithLogoSufix:(NSString *)sufix
{
    if ( [sufix hasPrefix:@"http://"] )
    {
        return sufix;
    }
    NSString *logoUrl = nil;
    
    return logoUrl;
}

- (NSMutableArray *)DistinctArray:(NSArray *)userIds
{
    NSMutableArray *userArray = [NSMutableArray array];
    NSSet *set = [NSSet setWithArray:userIds];
    for (NSString *userStr in [set allObjects]) {
        [userArray addObject:userStr];
    }
    return userArray;
}
@end
