//
//  EVChatGroupFileManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatGroupFileManager.h"
#import "EVLoginInfo.h"
#import "EVFriendItem.h"
#import "EVBaseToolManager+EVGroupAPI.h"

#define kLogourlFileName @"logourl"
#define kNameFileName    @"name"

@interface EVChatGroupFileManager ()

@property ( nonatomic, strong ) EVBaseToolManager  *engine;

@end

@implementation EVChatGroupFileManager

+ (instancetype)shareInstance
{
    static EVChatGroupFileManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)writeFriendsToFile:(NSArray *)friends
{
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:friends.count];
    NSMutableArray *logoArray = [NSMutableArray arrayWithCapacity:friends.count];
    NSMutableArray *imuserArray = [NSMutableArray arrayWithCapacity:friends.count];
    
    for (EVFriendItem *item in friends) {
        [nameArray addObject:item.name];
        [logoArray addObject:item.logourl];
        [imuserArray addObject:item.imuser];
    }
    [self writePropertys:nameArray forIMUsers:imuserArray toFile:kNameFileName];
    [self writePropertys:logoArray forIMUsers:imuserArray toFile:kLogourlFileName];
}

- (void)friendsFromLocalForIMUsers:(NSArray *)imusers completion:(void(^)(NSArray *friends))completion
{
    NSMutableArray *friends = [NSMutableArray arrayWithCapacity:imusers.count];
    NSDictionary *namesDic = [self dicWithFileName:kNameFileName];
    NSDictionary *logoDic = [self dicWithFileName:kLogourlFileName];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (NSString *imuser in imusers) {
        dispatch_group_async(group, queue, ^{
            
            EVFriendItem *item = [[EVFriendItem alloc] init];
            item.name = [namesDic objectForKey:imuser];
            item.logourl = [logoDic objectForKey:imuser];
            if ( item.name && item.logourl )
            {
                [friends addObject:item];
            }
            else
            {
                NSDictionary *resultDic = [self.engine baseUserInfoUrlWithImuser:imuser];
                if ( [resultDic[kRetvalKye] isEqualToString:kRequestOK] )
                {
                    NSDictionary *dic = [resultDic objectForKey:kRetinfoKey];
                    EVFriendItem *item = [EVFriendItem objectWithDictionary:dic];
                    if ( item.name && item.logourl )
                    {
                        [friends addObject:item];
                        [self writelogoUrl:item.logourl name:item.name forIMUser:imuser];
                    }
                }
            }
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ( completion )
        {
            completion(friends);
        }
    });
}

- (NSDictionary *)dicWithFileName:(NSString *)fileName
{
    NSString *filePath = [self filePathWithString:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ( dic == nil )
    {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

- (NSString *)filePathWithString:(NSString *)string
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *logourlsDirPath = [cachePath stringByAppendingString:@"/chat_group"];
    NSString *currentPath = [NSString stringWithFormat:@"%@_%@.plist",string,[EVLoginInfo localObject].name];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logourlsDirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logourlsDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [logourlsDirPath stringByAppendingPathComponent:currentPath];
}

- (void)writelogoUrl:(NSString *)logourl name:(NSString *)name forIMUser:(NSString *)imuser
{
    [self writeProperty:logourl forIMUser:imuser toFile:kLogourlFileName];
    [self writeProperty:name forIMUser:imuser toFile:kNameFileName];
}

- (void)writePropertys:(NSArray *)propertys forIMUsers:(NSArray *)imusers toFile:(NSString *)fileName
{
    NSString *filePath = [self filePathWithString:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ( dic == nil )
    {
        dic = [NSDictionary dictionary];
    }
    // 写入本地
    NSDictionary *dic_cp = [dic mutableCopy];
    for (int i = 0; i < propertys.count ; i ++)
    {
        NSString *property = propertys[i];
        NSString *imuser = imusers[i];
        if ( imuser )
        {
            continue;
        }
        [dic_cp setValue:property forKey:imuser];
    }
    [dic_cp writeToFile:filePath atomically:YES];
}


- (void)writeProperty:(NSString *)property forIMUser:(NSString *)imuser toFile:(NSString *)fileName
{
    if ( imuser == nil )
    {
        return;
    }
    NSString *filePath = [self filePathWithString:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ( dic == nil )
    {
        dic = [NSDictionary dictionary];
    }
    // 写入本地
    NSDictionary *dic_cp = [dic mutableCopy];
    [dic_cp setValue:property forKey:imuser];
    [dic_cp writeToFile:filePath atomically:YES];
}

- (void)logoUrlWithImuser:(NSString *)imuser completion:(void(^)(NSString *logourl,NSString *name))completion
{
    if ( imuser == nil )
    {
        return;
    }
    NSString *logoFilePath = [self filePathWithString:kLogourlFileName];
    NSString *nameFilePath = [self filePathWithString:kNameFileName];
    NSDictionary *logoDic = [NSDictionary dictionaryWithContentsOfFile:logoFilePath];
    NSDictionary *nameDic = [NSDictionary dictionaryWithContentsOfFile:nameFilePath];
    if ( logoDic == nil )
    {
        logoDic = [NSDictionary dictionary];
    }
    if ( nameDic == nil )
    {
        nameDic = [NSDictionary dictionary];
    }
    NSString *logourl = [logoDic objectForKey:imuser];
    NSString *name = [nameDic objectForKey:imuser];
    if ( logourl && name)
    {
        if ( completion )
        {
            completion(logourl,name);
        }
    }
    else
    {
        [self.engine GETBaseUserInfoWithUname:nil orImuser:imuser start:nil fail:nil success:^(NSDictionary *modelDict) {
            NSString *ulogo = [modelDict objectForKey:@"logourl"];
            NSString *uName = [modelDict objectForKey:@"name"];
            if ( ulogo && uName )
            {
                if ( completion )
                {
                    completion(ulogo,uName);
                }
                // logoURL写入本地
                NSDictionary *logoDic_cp = [logoDic mutableCopy];
                [logoDic_cp setValue:ulogo forKey:imuser];
                [logoDic_cp writeToFile:logoFilePath atomically:YES];
                
                // name写入本地
                NSDictionary *nameDic_cp = [nameDic mutableCopy];
                [nameDic_cp setValue:uName forKey:imuser];
                [nameDic_cp writeToFile:nameFilePath atomically:YES];
            }
        } sessionExpire:nil];
    }
}

- (EVBaseToolManager *)engine
{
    if ( _engine ==  nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
