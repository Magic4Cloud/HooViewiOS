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

@end

@implementation EVSDKLiveMessageEngine
#pragma mark - 新的连接聊天服务器
- (void)connectMessage
{
    [EVMessageManager shareManager].delegate = self;
    [[EVMessageManager shareManager] connect];
}

#pragma mark - message delegate
- (void)EVMessageConnected
{
    
    WEAK(self)
    [self clearAllUserArray];
    if (self.topicVid == nil && [self.topicVid isEqualToString:@""]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(joinTopicIDNil)]) {
            [self.delegate joinTopicIDNil];
        }
        return;
    }
    [[EVMessageManager shareManager] joinTopic:self.topicVid result:^(BOOL isSuccess, EVMessageErrorCode errorCode, NSArray<NSString *> *privateInfos, NSArray<NSString *> *users) {
//        __strong typeof(self) weakSelf = self;
        NSMutableArray *newsUsers = [NSMutableArray arrayWithArray:users];
        for (NSString *oneUser in users) {
            if ([oneUser isEqualToString:_anchorName]) {
                [newsUsers removeObject:oneUser];
            }
        }
        if (isSuccess == YES) {
            if (newsUsers.count > 0) {
                NSString *userNames = [NSString stringWithArray:newsUsers];
                [weakself userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
                    NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[@"users"]];
                    [self.allUserArray addObjectsFromArray:userModelArray];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
                            [self.delegate updateLiveMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
                    }
                    
                }];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(successJoinTopic)]) {
                [self.delegate successJoinTopic];
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




- (void)EVMessageConnectError:(NSError *)error
{
    //init失败
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (error.code == -2001) {
            [EVSDKInitManager initMessageSDKUserData:self.userData];
        }else {
            [[EVMessageManager shareManager] connect];
        }
    });
}


- (void)userMessageInfoName:(NSString *)userNames success:(void(^)(NSDictionary *modelDict))success
{
    WEAK(self)
    [self.baseToolManager GETBaseUserInfoListWithUname:userNames start:nil fail:^(NSError *error) {
        [weakself userMessageInfoName:userNames success:success];
    } success:success sessionExpire:^{
        CCLog(@"session过期");
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
        [comment updateWithCommentInfo:params[EVMessageKeyExct] contextInfo:message commentType:CCCommentComment];
        [self.newCommentArray addObject:comment];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
            [self.delegate updateLiveMessageType:EVSDKNewMessageTypeNewComment data:self.newCommentArray];
        }
    }else if ([allDictKeys containsObject:EVMessageKeyExbr]) {
    
        EVComment *comment = [[EVComment alloc]init];
        [comment updateWithCommentInfo:params[EVMessageKeyExbr] contextInfo:message commentType:CCCommentComment];
         [self.newCommentArray addObject:comment];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
            [self.delegate updateLiveMessageType:EVSDKNewMessageTypeNewComment data:self.newCommentArray];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveSpecialMessageType:dict:comment:)]) {
            [self.delegate updateLiveSpecialMessageType:EVSDKSpecialMessageTypeDanmu dict:params comment:message];
        }
    
    }else if ( [allDictKeys containsObject:EVMessageKeyLvst] ){
        BOOL liveStatus = [params[EVMessageKeyLvst][EVMessageKeySt] boolValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveStatus:)]) {
            [self.delegate  updateLiveStatus:liveStatus];
        }
    }else if ([allDictKeys containsObject:EVMessageKeyExgf]){
        NSDictionary *dict = params[EVMessageKeyExgf];
        NSLog(@"%@------------------------------------",dict);
        EVComment *comment = [[EVComment alloc]init];
        [comment updateWithCommentInfo:params[EVMessageKeyExgf ] contextInfo:message commentType:CCCommentPresent];
        [self.newCommentArray addObject:comment];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
            [self.delegate updateLiveMessageType:EVSDKNewMessageTypeNewComment data:self.newCommentArray];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveSpecialMessageType:dict:comment:)]) {
            [self.delegate updateLiveSpecialMessageType:EVSDKSpecialMessageTypeGift dict:dict comment:nil];
        }
    }else  if ([allDictKeys containsObject:EVMessageKeyExrp]){
        NSDictionary *dict = params[EVMessageKeyExrp];
        NSLog(@"%@------------------------------------",dict);
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveSpecialMessageType:dict:comment:)]) {
            [self.delegate updateLiveSpecialMessageType:EVSDKSpecialMessageTypeRedPacket dict:dict comment:nil];
        }
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
        NSString *userNames = [NSString stringWithArray:userids];
        [self userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
            NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[@"users"]];
            [self.allUserArray addObjectsFromArray:userModelArray];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
                [self.delegate updateLiveMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
            }
        }];
    }
    
}

/**
 *  有用户从话题离开
 *
 *  @param userids 离开的用户
 *  @param topic   话题
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
             leftTopic:(NSString *)topic
{
    if (userids.count > 0) {
        NSString *userNames = [NSString stringWithArray:userids];
        [self.levelUserArray removeAllObjects];
        [self userMessageInfoName:userNames success:^(NSDictionary *modelDict) {
            NSArray *userModelArray = [EVAudience objectWithDictionaryArray:modelDict[@"users"]];
            NSMutableArray *levelAllArray = [NSMutableArray arrayWithArray:userModelArray];
            for (EVUserModel *userModel in levelAllArray) {
                [self.allUserArray removeObject:userModel];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
                [self.delegate updateLiveMessageType:EVSDKNewMessageTypeAllUser data:self.allUserArray];
            }
            [self.levelUserArray addObjectsFromArray:userModelArray];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveMessageType:data:)]) {
                [self.delegate updateLiveMessageType:EVSDKNewMessageTypeLevelUser data:self.levelUserArray];
            }
        }];
    }
   
}

- (void)EVMessageDidUpdateLikeCount:(long long)likeCount
                            inTopic:(NSString *)topic
{
    CCLog(@"点赞数");
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveDataType:count:)]) {
        [self.delegate updateLiveDataType:EVSDKLiveDataTypeLoveCount count:likeCount];
    }
}

- (void)EVMessageDidUpdateWatchingCount:(NSInteger)watchingCount
                                inTopic:(NSString *)topic
{
    CCLog(@"话题中观看的人数");
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveDataType:count:)]) {
        [self.delegate updateLiveDataType:EVSDKLiveDataTypeWatchingCount count:(long long)watchingCount];
    }
}

- (void)EVMessageDidUpdateWatchedCount:(NSInteger)watchedCount
                               inTopic:(NSString *)topic
{
    CCLog(@"话题中看过的人数");
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateLiveDataType:count:)]) {
        [self.delegate updateLiveDataType:EVSDKLiveDataTypeWatchedCount count:(long long)watchedCount];
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
//    if ( _logoprefix == nil || _logosufix == nil )
//    {
//        return nil;
//    }
    NSString *logoUrl = nil;
    
    return logoUrl;
}
@end
