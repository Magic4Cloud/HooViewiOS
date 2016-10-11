//
//  EVStartResourceTool.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVStartResourceTool.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVNetWorkStateManger.h"
#import "NSString+Extension.h"
#import "EVVideoTopicItem.h"
#import "ASIHTTPRequest.h"

#import "EVWatermarkModel.h"
#import "EVBaseToolManager+EVStartAppAPI.h"

// 点赞文件路径
#define LIKEFOLDER      [FOLDERPATH stringByAppendingPathComponent:@"like"]
#define LIKEDICTIONARY  [LIKEFOLDER stringByAppendingPathComponent:@"like.plist"]
#define LIKEFILEPATH(name) [LIKEFOLDER stringByAppendingPathComponent:(name)]

// 话题文件路径
#define TOPICFOLDER [FOLDERPATH stringByAppendingPathComponent:@"topic"]
#define TOPICDICTIONARY [TOPICFOLDER stringByAppendingPathComponent:@"topic.plist"]
#define TOPICARRAY [TOPICFOLDER stringByAppendingPathComponent:@"topic_array.plist"]
#define TOPICFILEPATH(name) [TOPICFOLDER stringByAppendingPathComponent:(name)]

#define MAX_RECONNECT   5

// object对应的参数类型
#define P_ANI                               @"ani"
#define P_TITLE                             @"title"

// 闪屏参数
#define P_TYPE                              @"type"
#define P_START_TIME                        @"start_time"
#define P_END_TIME                          @"end_time"
#define p_BuyBack                           @"buyback"

// 自定义参数
// 图片路径
#define P_IMAGE_FILE_PATH                   @"image_file_path"
// 开始时间的秒数
#define P_START_TIME_SECONDS                @"start_time_seconds"
// 结束时间的秒数
#define P_END_TIME_SECONDS                  @"end_time_seconds"

// 话题参数
#define p_icon                        @"icon"
#define p_id                                @"id"
#define p_supericon                         @"supericon"
#define p_thumb                             @"thumb"
#define p_topics                            @"topics"
#define p_selecticon_file_path              @"selecticon_file_path"
#define p_supericon_file_path               @"supericon_file_path"
#define p_topic_type                        @"type"
#define p_isDefault                         @"default"

// 礼物参数
#define P_GOODS_LIST                        @"goodslist"

//h5
#define P_h5url                             @"h5url"

// 联系我们参数
#define P_CONTACT_INFO                      @"contactinfo"

//新的认证
#define P_NEW_USER_Authente_LIST            @"certification"

#define P_FREEUSERINFO                      @"freeuserinfo"
#define P_WEBCHATINFO                       @"webchatinfo"
#define P_WATERMARK                         @"watermark"

@interface EVStartResourceTool () <ASIHTTPRequestDelegate> {
    NSArray *_likeImages; /** 点赞图片 */
    BOOL _prensentEnable;    /** 礼物动画是否可用 */
    BOOL _emojiPresentEable; /** 表情是否可用 */
}

@property(nonatomic, strong) EVBaseToolManager *engin;   /**< 网络请求工具 */
@property(nonatomic, assign) NSInteger reconnectTime;  /**< 标记重连次数 */

@property(nonatomic, assign) NSInteger topicRequestCount;
/** 标示该操作是否成功 */
@property(nonatomic, assign) BOOL requestSuccess;

/** 点赞所对应的数据 */
@property(nonatomic, strong) NSMutableDictionary *likePlist;


/** 话题数据 */
@property(nonatomic, strong) NSMutableDictionary *topicsPlist;


@property(strong, nonatomic) NSArray *lastLocalSavedTopicArray; /**< 上次缓存的本地话题数据 */

/** 话题 */
@property(nonatomic, strong) NSMutableArray *topicItems;
@property(assign, nonatomic) NSInteger downloadtopiccount; /**< 需要下载的话题数 */
@property(nonatomic, strong) NSArray *presents;
@property(nonatomic, copy) NSString *payFAQ;
@property(nonatomic, copy) NSString *connectUs;
@property(nonatomic, copy) NSString *freeuserinfo;
@property(nonatomic, copy) NSString *webchatinfo;
@property(strong, nonatomic) EVWatermarkModel *watermarkModel; /**< 水印信息 */
@property(nonatomic, strong) NSArray *topicArray;

@end

@implementation EVStartResourceTool

+ (instancetype)shareInstance {
    static EVStartResourceTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _engin = [[EVBaseToolManager alloc] init];
        [self createFolder];
        [self likePlist];
        [self topicsPlist];
    }
    return self;
}

// 创建文件夹
- (void)createFolder {
    // 创建总的文件路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:FOLDERPATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:FOLDERPATH withIntermediateDirectories:YES attributes:nil error:NULL];
    }

    // 创建话题缓存的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:TOPICFOLDER]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:TOPICFOLDER withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (void)setUpNetworkNotification {
    [CCNotificationCenter addObserver:self selector:@selector(loadData) name:CCNetWorkChangeNotification object:nil];
}

- (void)removeNotification {
    [CCNotificationCenter removeObserver:self];
}

- (NSMutableDictionary *)likePlist {
    if (_likePlist == nil) {
        _likePlist = [NSMutableDictionary<NSString *, id> dictionaryWithContentsOfFile:LIKEDICTIONARY];

        if (_likePlist == nil) {
            _likePlist = [NSMutableDictionary dictionary];
        }
    }
    return _likePlist;
}

- (NSArray *)likeImages {
    if (_likeImages.count) {
        return _likeImages;
    }
    return nil;
}

- (NSMutableDictionary *)topicsPlist {
    if (_topicsPlist == nil) {
        _topicsPlist = [NSMutableDictionary dictionaryWithContentsOfFile:TOPICDICTIONARY];

        _lastLocalSavedTopicArray = [NSArray arrayWithContentsOfFile:TOPICARRAY];

        if (_topicsPlist == nil) {
            _topicsPlist = [NSMutableDictionary dictionary];
        }
    }
    return _topicsPlist;
}

- (NSArray *)topicArray {
    if (_topicArray == nil) {
        _topicArray = [NSArray arrayWithContentsOfFile:TOPICARRAY];
    }
    return _topicArray;
}

- (NSArray *)topicItems {
    if (_topicItems) {
        return _topicItems;
    }

    if (self.topicsPlist.count == 0) {
        return nil;
    }
    __block NSMutableArray *topicItems = [NSMutableArray array];

    if (_topicArray && _topicArray.count) {
        for (NSDictionary *item in _topicArray) {
            NSString *topic_id = [NSString stringWithFormat:@"%@", item[p_id]];
            NSDictionary *topic_item = self.topicsPlist[topic_id];
            EVVideoTopicItem *item = [self topicItemWithDictionary:topic_item];
            if (item) {
                [topicItems addObject:item];
            }
        }
    }
    else {
        CCLog(@"%@", self.topicsPlist);
        NSMutableArray *topicsTemp = [NSMutableArray array];
        [self.topicsPlist enumerateKeysAndObjectsUsingBlock:^(NSNumber *topicId, NSDictionary *topic_item, BOOL *_Nonnull stop) {

            EVVideoTopicItem *item = [self topicItemWithDictionary:topic_item];
            if (item) {
                [topicsTemp addObject:item];
            }
        }];
        if (self.lastLocalSavedTopicArray && self.lastLocalSavedTopicArray.count) {
            for (NSDictionary *item in self.lastLocalSavedTopicArray) {
                NSString *topic_id = [NSString stringWithFormat:@"%@", item[p_id]];
                NSDictionary *topic_item = self.topicsPlist[topic_id];
                EVVideoTopicItem *topicModel = [self topicItemWithDictionary:topic_item];
                if (topicModel) {
                    topicModel.type = [item[P_TYPE] integerValue];
                    [topicItems addObject:topicModel];
                }
            }
        }
    }

    if (topicItems.count == 0) {
        return nil;
    }

    _topicItems = topicItems;
    return _topicItems;
}

- (EVVideoTopicItem *)topicItemWithDictionary:(NSDictionary *)topic_item {
    if (topic_item == nil) {
        return nil;
    }

    EVVideoTopicItem *item = nil;
    NSString *selecticon_imagePath = topic_item[p_selecticon_file_path];
    selecticon_imagePath = [TOPICFOLDER stringByAppendingPathComponent:selecticon_imagePath];

    NSString *supericon_imagePath = topic_item[p_supericon_file_path];
    supericon_imagePath = [TOPICFOLDER stringByAppendingPathComponent:supericon_imagePath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:selecticon_imagePath isDirectory:NULL] && [[NSFileManager defaultManager] fileExistsAtPath:supericon_imagePath isDirectory:NULL]) {
        item = [[EVVideoTopicItem alloc] init];
        item.topic_id = [NSString stringWithFormat:@"%@", topic_item[p_id]];
        item.thumb = topic_item[p_thumb];
        item.supericon = topic_item[p_supericon];
        item.topic_description = topic_item[p_icon];
        item.selecticon_imagePath = selecticon_imagePath;
        item.supericon_imagePath = supericon_imagePath;
        item.title = topic_item[P_TITLE];
        item.type = [topic_item[p_topic_type] integerValue];
        item.isDefault = [topic_item[p_isDefault] boolValue];
        [item supericon_image];
        [item selecticon_image];
        item.isSeclected = NO;
    }

    return item;
}

- (BOOL)prensentEnable {
    return _prensentEnable;
}

- (BOOL)emojiPresentEnable {
    return _emojiPresentEable;
}

- (NSArray *_Nullable)presentsWithType:(CCPresentType)type {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *present in self.presents) {
        if ([present[P_PRESENT_ANITYPE] integerValue] == CCPresentAniTypeZip) {
        }
        if ([present[kType] integerValue] == type) {
            [arr addObject:present];
        }
    }
    NSArray *startGood = [EVStartGoodModel objectWithDictionaryArray:arr];
    return startGood;
}

- (NSString *)payFAQUrl {
    return self.payFAQ;
}

- (NSString *)connectUsUrl {
    return self.connectUs;
}

- (void)loadData {
    if (self.requestSuccess) {
        return;
    }

    if (![[EVNetWorkStateManger sharedManager] isNetWorkEnable]) {
        [self removeNotification];
        [self setUpNetworkNotification];
        return;
    }


    __weak EVStartResourceTool *wself = self;
    [self.engin GETParamsWithDevType:@"ios" startBlock:^{

    }                           fail:^(NSError *error) {
        if (wself.reconnectTime < MAX_RECONNECT) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                wself.reconnectTime++;
                [wself loadData];
            });
        }
    }                        success:^(NSDictionary *dict) {
        self.requestSuccess = YES;
        if (dict[P_h5url]) {
            if ([dict[P_h5url] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *webDict = dict[P_h5url];
                if (webDict[P_CONTACT_INFO])   // 联系我们
                {
                    self.connectUs = webDict[P_CONTACT_INFO];

                }
                if (webDict[P_FREEUSERINFO]) {
                    self.freeuserinfo = webDict[P_FREEUSERINFO];
                }
            }
        }
    }];
}

- (NSString *_Nullable)freeuserinfoUrl {
    return self.freeuserinfo;
}

- (void)setWatermarkModel:(EVWatermarkModel *)watermarkModel {
    _watermarkModel = watermarkModel;
    CGFloat x_pos = watermarkModel.x_pos;
    CGFloat y_pos = watermarkModel.y_pos;
    CGFloat width = watermarkModel.width;
    CGFloat height = watermarkModel.height;
    CGRect relativeFrame = kWatermarkDefaultRelativeFrame;

    if ([watermarkModel.region isEqualToString:kRight_up]) {
        x_pos = relativeFrame.size.width - watermarkModel.x_pos - width;
    }
    else if ([watermarkModel.region isEqualToString:kRight_down]) {
        x_pos = relativeFrame.size.width - watermarkModel.x_pos - width;
        y_pos = relativeFrame.size.height - watermarkModel.y_pos - height;
    }
    else if ([watermarkModel.region isEqualToString:kLeft_down]) {
        y_pos = relativeFrame.size.height - watermarkModel.y_pos - height;
    }
    _watermarkModel.x_pos = x_pos;
    _watermarkModel.y_pos = y_pos;
}

- (EVWatermarkModel *)getWatermarkInfo {
    EVWatermarkModel *watermarkModel = _watermarkModel;
    if (!_watermarkModel) {
        watermarkModel = [self getDefaultWatermark];
    }
    else if (!_watermarkModel.watermarkImg) {
        watermarkModel = [self getDefaultWatermark];
        watermarkModel.enable = _watermarkModel.enable;
    }
    return watermarkModel;
}

- (EVWatermarkModel *)getDefaultWatermark {
    EVWatermarkModel *watermarkModel = [[EVWatermarkModel alloc] init];
    watermarkModel.enable = YES;
    watermarkModel.x_pos = kWatermarkDefault_X;
    watermarkModel.y_pos = kWatermarkDefault_Y;
    watermarkModel.width = kWatermarkDefault_W;
    watermarkModel.height = kWatermarkDefault_H;
    watermarkModel.region = kRight_up;
    watermarkModel.watermarkImg = [UIImage imageNamed:@"logo_watermark"];

    return watermarkModel;
}

@end
