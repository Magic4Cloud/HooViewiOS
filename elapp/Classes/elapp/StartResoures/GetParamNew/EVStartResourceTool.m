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

#import "EVWatermarkModel.h"
#import "EVBaseToolManager+EVStartAppAPI.h"

#define MAX_RECONNECT   5

// 礼物参数
#define P_GOODS_LIST                        @"goodslist"

//h5
#define P_h5url                             @"h5url"

// 联系我们参数
#define P_CONTACT_INFO                      @"contactinfo"

#define P_FREEUSERINFO                      @"freeuserinfo"
#define P_WEBCHATINFO                       @"webchatinfo"
#define P_USERLEVELINFO                     @"userlevelinfo"
#define P_WATERMARK                         @"watermark"
#define P_SWITCHLIST                        @"switchlist"
#define P_BPUSH                             @"bpush"

@interface EVStartResourceTool () {
    BOOL _prensentEnable;    /** 礼物动画是否可用 */
    BOOL _emojiPresentEable; /** 表情是否可用 */
}

@property(nonatomic, strong) EVBaseToolManager *engin;   /**< 网络请求工具 */
@property(nonatomic, assign) NSInteger reconnectTime;  /**< 标记重连次数 */

@property(nonatomic, assign) BOOL requestGoods;

@property(nonatomic, assign) NSInteger topicRequestCount;

@property (nonatomic, assign) NSInteger goodsRequestCount;

/** 标示该操作是否成功 */
@property(nonatomic, assign) BOOL requestSuccess;

@property(nonatomic, strong) NSMutableArray *topicItems;

/** 礼物 */
@property(nonatomic, strong) NSArray *presents;

@property(nonatomic, copy) NSString *payFAQ;
@property(nonatomic, copy) NSString *connectUs;
@property(nonatomic, copy) NSString *freeuserinfo;

@property(nonatomic, copy) NSString *webchatinfo;
@property(strong, nonatomic) EVWatermarkModel *watermarkModel; /**< 水印信息 */

@property(strong, nonatomic) NSArray *certificationArray;

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
    }
    return self;
}

// 创建文件夹
- (void)createFolder {
    // 创建总的文件路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:FOLDERPATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:FOLDERPATH withIntermediateDirectories:YES attributes:nil error:NULL];
    }

    // 创建魔法表情的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:PRESENTFOLDER]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PRESENTFOLDER withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

// 通知处理方法
- (void)setUpNetworkNotification {
    [EVNotificationCenter addObserver:self selector:@selector(loadData) name:CCNetWorkChangeNotification object:nil];
}

- (void)removeNotification {
    [EVNotificationCenter removeObserver:self];
}


- (void)loadGoodsData {
    WEAK(self)
    [self.engin GETGoodsListWithStart:^{

    }                            fail:^(NSError *error) {
        if (weakself.goodsRequestCount < 10) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.goodsRequestCount++;
                [weakself loadGoodsData];
            });
        }
    }                         success:^(NSDictionary *info) {

        [self handlePresentObjects:info[P_GOODS_LIST]];
    }                  sessionExpired:^{

    }];

}

- (void)loadTopicData
{
    WEAK(self)
    [self.engin GETNewtopicWithStart:^{
        
    } fail:^(NSError *error) {
        if (weakself.topicRequestCount < 10) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.topicRequestCount++;
                [weakself loadTopicData];
            });
        }
    } success:^(NSDictionary *info) {
        NSArray *topics = info[@"topics"];
        if ( [topics isKindOfClass:[NSArray class]] && topics.count )
        {
            [weakself handleTopicDataWithArray:topics];
        }
    } sessionExpired:^{
        
    }];
}

- (void)handleTopicDataWithArray:(NSArray  *)array
{
    _allTopicArray = [EVVideoTopicItem objectWithDictionaryArray:array].mutableCopy;
}

- (NSArray *)topicItems {
    if (_topicItems) {
        return _topicItems;
    }
    return nil;
}

#pragma mark - handle present data

- (void)handlePresentObjects:(NSArray *)objects {
    self.presents = objects;
    // 移除本地不需要的礼物图片
    NSArray *allGoodImagePaths = [[NSFileManager defaultManager] subpathsAtPath:PRESENTFOLDER]; // 已经下载的图片地址

    // 找到本地所有的礼物资源
    NSMutableArray *objectImagePaths = [NSMutableArray array]; // 存储本次所有礼物的图片链接MD5
    for (NSDictionary *object in objects) {
        NSString *aniURL = [object[P_PRESENT_ANI] md5String];
        if ([object[P_PRESENT_ANITYPE] integerValue] == EVPresentAniTypeZip) {

        }

        [objectImagePaths addObject:[object[P_PRESENT_URL] md5String]];
        [objectImagePaths addObject:aniURL];
    }
    // 找出并删除本地不需要的图片
    for (NSString *goodImagePath in allGoodImagePaths) {
        BOOL findImage = NO;
        for (NSString *objectImagePath in objectImagePaths) {
            if ([goodImagePath isEqualToString:objectImagePath]) {
                findImage = YES;
                break;
            }
        }
        if (findImage == NO) {
            [[NSFileManager defaultManager] removeItemAtPath:goodImagePath error:nil];
        }
    }

    // 下载本地没有的图片
    for (NSDictionary *object in objects) {
        // 下载礼物展示小图
        NSString *storeImageUrl = [object[P_PRESENT_URL] md5String];
        if (![[NSFileManager defaultManager] fileExistsAtPath:PRESENTFILEPATH(storeImageUrl)]) {
            [UIImage gp_downloadWithURLString:object[P_PRESENT_URL] complete:^(NSData *data) {
                [data writeToFile:PRESENTFILEPATH(storeImageUrl) atomically:YES];
            }];
        }

        // 下载礼物动画大图
        NSString *storeAniImageUrl = [object[P_PRESENT_ANI] md5String];
        if ([object[P_PRESENT_ANITYPE] integerValue] == EVPresentAniTypeZip) {

        }
        NSString *downLoadAniImageUrl = [object[P_PRESENT_ANI] componentsSeparatedByString:@"/"].lastObject;
        BOOL needDownLoad = [object[P_PRESENT_ANITYPE] integerValue] == EVPresentAniTypeZip || [object[P_PRESENT_ANITYPE] integerValue] == EVPresentAniTypeStaticImage;   // 需要进行数据下载
        NSString *path = PRESENTFILEPATH(storeImageUrl);
        if (needDownLoad && ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // 下载静态图
            if ([object[P_PRESENT_ANITYPE] integerValue] == 1) {
                [UIImage gp_downloadWithURLString:object[P_PRESENT_ANI] complete:^(NSData *data) {
                    if (object)
                        [data writeToFile:PRESENTFILEPATH(storeAniImageUrl) atomically:YES];
                }];
            }
            else if ([object[P_PRESENT_ANITYPE] integerValue] == 3)   // 下载压缩包
            {

                
            }
        }
    }

    _prensentEnable = [self presentsWithType:EVPresentTypePresent].count != 0;
    _emojiPresentEable = [self presentsWithType:EVPresentTypeEmoji].count != 0;
}

- (BOOL)prensentEnable {
    return _prensentEnable;
}

- (BOOL)emojiPresentEnable {
    return _emojiPresentEable;
}

// 某种礼物
- (NSArray *_Nullable)presentsWithType:(EVPresentType)type {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *present in self.presents) {
        if ([present[P_PRESENT_ANITYPE] integerValue] == EVPresentAniTypeZip) {
        }
        if ([present[kType] integerValue] == type) {
            [arr addObject:present];
        }
    }
    NSArray *startGood = [EVStartGoodModel objectWithDictionaryArray:arr];
    return startGood;
}

#pragma mark - handel recharges

- (NSString *)payFAQUrl {
    return self.payFAQ;
}

- (NSString *)connectUsUrl {
    return self.connectUs;
}

// 获取数据
- (void)loadData {
    if (self.requestSuccess) {
        return;
    }

//    if (![[EVNetWorkStateManger sharedManager] isNetWorkEnable]) {
//        [self removeNotification];
//        [self setUpNetworkNotification];
//        return;
//    }


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

    if (!self.requestGoods) {
        self.requestGoods = YES;
        [self loadGoodsData];
        [self loadTopicData];
    }
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

- (NSArray *)defaultLikeImages
{
    NSMutableArray *likeImages = [NSMutableArray arrayWithCapacity:7];
    for (int i = 1; i <= 7; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"common_love%d", i]];
        [likeImages addObject:image];
    }
    return likeImages;
}

- (NSArray *)getCertificationInfo {
    return _certificationArray;
}

@end
