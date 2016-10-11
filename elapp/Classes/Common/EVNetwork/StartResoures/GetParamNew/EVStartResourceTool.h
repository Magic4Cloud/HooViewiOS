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
#define P_PRESENT_URL                       @"pic"  // 礼物图片
#define P_PRESENT_ANI                       @"ani"  // 礼物动画类型，1表示静态图，2表示gif，3表示压缩包，4表示红包
#define P_PRESENT_ANITYPE                   @"anitype"  // 礼物动画类型，1表示静态图，2表示gif，3表示压缩包，4表示红包

// 可发送礼物文件路径
#define PRESENTFOLDER [FOLDERPATH stringByAppendingPathComponent:@"present"]
#define PRESENTFILEPATH( name ) [PRESENTFOLDER stringByAppendingPathComponent:(name)]

@interface EVStartResourceTool : NSObject

@property (nonatomic, strong) NSMutableArray *allTopicArray;

+ (instancetype _Nullable)shareInstance;

- (void)loadData;

- (NSArray * _Nullable)likeImages;

- (NSArray * _Nullable)topicItems;

- (BOOL)prensentEnable;

- (BOOL)emojiPresentEnable;

- (NSArray <EVStartGoodModel *>* _Nullable)presentsWithType:(CCPresentType)type;

- (NSString * _Nullable)payFAQUrl;
- (NSString * _Nullable)connectUsUrl;
- (NSString * _Nullable) freeuserinfoUrl;

- (EVWatermarkModel * _Nullable)getWatermarkInfo;
- (NSArray * _Nullable)getCertificationInfo;
@end
