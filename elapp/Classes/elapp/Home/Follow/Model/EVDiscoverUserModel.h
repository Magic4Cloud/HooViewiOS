//
//  EVDiscoverUserModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

typedef NSString CCDiscoverUserModelType;

#define kCCDiscoverUserModelTypeNew         @"new"
#define kCCDiscoverUserModelTypeRecommend   @"recommend"
#define kCCDiscoverUserModelTypeHot         @"hot"
#define kCCDiscoverUserModelTypeCity        @"city"
#define kCCDiscoverUserModelTypeAll         @"all"

// 服务器返回的字典中类型后缀
#define kCCDiscoverUserModelKeySuffix       @"_users"


#import "CCBaseObject.h"


@interface EVDiscoverUserModel : CCBaseObject

@property (copy, nonatomic) NSString *name;             // 云播号
@property (copy, nonatomic) NSString *nickname;         // 昵称
@property (copy, nonatomic) NSString *logourl;          // 用户头像地址
@property (copy, nonatomic) NSString *signature;        // 签名
@property (copy, nonatomic) NSString *vip;              // 是否为vip,0表示不是，1表示是
@property (copy, nonatomic) NSString *fans_count;       // 粉丝数
@property (copy, nonatomic) NSString *live_time;        // 直播时长
@property (copy, nonatomic) NSString *live_count;       // 直播次数
@property (copy, nonatomic) NSString *like_count;       // 点赞次数
@property (copy, nonatomic) NSString *watch_count;      // 被观看次数
@property (copy, nonatomic) NSString *followed;         // 关注关系
@property (copy, nonatomic) NSString *gender;           // 性别(female,male)
@property (copy, nonatomic) NSString *location;         // 地理位置
@property (copy, nonatomic) NSString *type;             // 类型

/**
 *  获取服务器请求得到的发现主播页不同类型相应的数组
 *
 *  @param type 主播的类型(new/recommend/hot/city)
 *
 *  @param dic
 *
 *  @return 当前类型主播的数组
 */
+ (NSArray *)discoverUserModelsForType:(NSString *)type withDictionary:(NSDictionary *) dic;

/**
 *  获取服务器请求得到的所有类型主播页的数组
 *
 *  @param allDic 解析需要的字典
 *
 *  @return 全部类型的数组(二维数组,已将其他四种类型加到二级数组中)
 */
+ (NSArray *)allDiscoverUserModelsWithDictionary:(NSDictionary *) allDic;


@end
