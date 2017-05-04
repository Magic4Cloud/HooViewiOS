//
//  EVImAvatarLocalClass.m
//  elapp
//
//  Created by 唐超 on 5/3/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVImAvatarLocalClass.h"
#define fileName @"imAvatar.plist"
static EVImAvatarLocalClass * _instance;
@implementation EVImAvatarLocalClass

- (void)saveAvatarWithUid:(NSString *)userid avatarUrl:(NSString *)avataUrl
{
    if (!userid || !avataUrl) {
        return;
    }
        //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];  //读取数据
    if (dataDic) {
        self.plistDic = dataDic;
    }
    NSString * avatarLocalString = self.plistDic[@"userid"];
    if (!avatarLocalString || ![avatarLocalString isEqualToString:avataUrl]){
        //如果不存或者变了
        [self.plistDic setObject:avataUrl forKey:userid];
    }
    //输入写入
    [self.plistDic writeToFile:filePath atomically:YES];
    
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"data1:%@", data1);
}

- (NSString *)getAvatarUrlWithUserid:(NSString *)uid
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];  //读取数据
    if (dataDic) {
        self.plistDic = dataDic;
    }
    NSString * avatarUrl = self.plistDic[uid];
    if (!avatarUrl) {
        avatarUrl = @"";
    }
    return avatarUrl;
}




- (NSMutableDictionary *)plistDic
{
    if (!_plistDic) {
        _plistDic = [NSMutableDictionary dictionary];
    }
    return _plistDic;
}

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    });
    return _instance;
}

+ (instancetype)alloc
{
    return [self shareInstance];
}

- (instancetype)copy
{
    return _instance;
}

@end
