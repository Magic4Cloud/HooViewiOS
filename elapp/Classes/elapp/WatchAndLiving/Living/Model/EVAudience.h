//
//  EVAudience.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

// 观众在观众列表里面的操作类型
typedef NS_ENUM(NSInteger, CCAudienceOperationType) {
    CCAudienceOperationNone,
    CCAudienceOperationAdd,
    CCAudienceOperationRemove
};

@interface EVAudience : CCBaseObject
/** 观众在观众列表里面的操作类型 */
@property (nonatomic,assign) CCAudienceOperationType operationType;
/** 观众的name */
@property (nonatomic,copy) NSString *name;
/** 观众的昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 观众的头像 */
@property (nonatomic,copy) NSString *logourl;
/** 是否游客，name=@"guest"的是游客 */
@property (nonatomic,assign) BOOL guest;
/** 官方认证vip */
@property (nonatomic, assign) NSInteger vip;

/** 普通等级 */
@property ( nonatomic ) NSInteger level;

/** vip等级 */
@property ( nonatomic ) NSInteger vip_level;

/** 主播等级 */
@property ( nonatomic ) NSInteger anchor_level;

/**
 *  观众对象模型初始化方法
 *
 *  @param jsonString json字符串
 *
 *  @return 
 */
+ (instancetype)audienceWithJSONString:(NSString *)jsonString;

- (void)updateDataWithInfo:(NSDictionary *)info;

@end
