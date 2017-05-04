//
//  EVImAvatarLocalClass.h
//  elapp
//
//  Created by 唐超 on 5/3/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 环信用户头像存储操作类
 */
@interface EVImAvatarLocalClass : NSObject
@property (nonatomic, strong)NSMutableDictionary * plistDic;
+ (instancetype)shareInstance;
- (NSString *)getAvatarUrlWithUserid:(NSString *)uid;
- (void)saveAvatarWithUid:(NSString *)userid avatarUrl:(NSString *)avataUrl;
@end
