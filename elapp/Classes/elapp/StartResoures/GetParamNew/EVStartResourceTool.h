//
//  EVStartResourceTool.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVStartGoodModel.h"

@class EVAudioOnlyCollectionViewCellItem, EVVideoTopicItem, EVWatermarkModel;

#define CCTOPICCACHECOMPLETENOTIFICATION @"CCTOPICCACHECOMPLETENOTIFICATION"

// 礼物参数
#define P_PRESENT_GID                       @"id"  // 礼物id
#define P_PRESENT_URL                       @"pic"  // 礼物图片
#define P_PRESENT_NAME                      @"name" // 礼物名称
#define P_PRESENT_TYPE                      @"type" // 礼物类型 0表示表情，1表示薏米，2表示礼物
#define P_PRESENT_ANI                       @"ani"  // 礼物动画类型，1表示静态图，2表示gif，3表示压缩包，4表示红包
#define P_PRESENT_COST                      @"cost" // 礼物价格
#define P_PRESENT_COSTYPE                   @"costtype" // 消费类型，0表示薏米，1表示云币
#define P_PRESENT_ANITYPE                   @"anitype"  // 礼物动画类型，1表示静态图，2表示gif，3表示压缩包，4表示红包

// 可发送礼物文件路径
#define PRESENTFOLDER [FOLDERPATH stringByAppendingPathComponent:@"present"]
#define PRESENTFILEPATH( name ) [PRESENTFOLDER stringByAppendingPathComponent:(name)]

@interface EVStartResourceTool : NSObject

@property (nonatomic, readonly, getter = getNew_user_task_list, nullable) NSArray *new_user_task_list;

@property (nonatomic, readonly, getter = getDaily_task_list, nullable) NSArray *daily_task_list;

@property (nonatomic, strong) NSMutableArray *allTopicArray;

//获取点赞图片
- (NSArray *_Nullable)defaultLikeImages;
/**
 *
 *  单例创建本类的实例
 *
 *  @return 本类实例
 */
+ (instancetype _Nullable)shareInstance;

/**
 *
 *  获取数据
 */
- (void)loadData;


#pragma mark - 话题

/**
 *  获取所有话题元素
 *  如果本地没有缓存返回 nil
 */
- (NSArray * _Nullable)topicItems;

/**
 *  @return CCPresentTypePresent == 0
 *
 */
- (BOOL)prensentEnable;

/**
 *
 *  @return CCPresentTypeEmoji 数量 == 0
 */
- (BOOL)emojiPresentEnable;

/**
 *
 *  根据礼物种类获取礼物
 *
 *  @param type 礼物种类
 *
 *  @return 该种类的所有礼物
 */
- (NSArray <EVStartGoodModel *>* _Nullable)presentsWithType:(CCPresentType)type;

/**
 *
 *  通过id和类型获取礼物对象
 *
 *  @param goodID 礼物的ID
 *  @param type   礼物类型
 *
 *  @return 礼物对象
 */
- (EVStartGoodModel * _Nullable)goodModelWithID:(NSInteger)goodID forType:(CCPresentType)type;

/**
 *
 *  支付常见问题链接
 *
 *  @return 链接
 */
- (NSString * _Nullable)payFAQUrl;

/**
 *
 *  联系我们链接
 *
 *  @return 链接
 */
- (NSString * _Nullable)connectUsUrl;

- (NSString * _Nullable) freeuserinfoUrl;
- (NSString * _Nullable) webchatinfoUrl;

/**
 *  获取水印相关信息
 */
- (EVWatermarkModel * _Nullable)getWatermarkInfo;

- (NSArray * _Nullable)getCertificationInfo;
@end
