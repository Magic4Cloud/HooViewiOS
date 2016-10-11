//
//  EVBaseToolManager+EVLiveAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


typedef NS_ENUM(NSInteger, CCLiveState) {
    CCLiveStateLiving = 0,          // 直播进行中
    CCLiveStateHoldUp = 1,          // 直播应用退到后台，主播在忙
    CCLiveStateSharing = 2,         // 直播播主正在分享
    CCLiveStateEnd = 3,             // 直播已结束
    CCLiveStateNetworkBad = 4,      // 网络不稳定
    CCLiveStatePhoneCallComeIn = 5, // 电话来了
    CCLiveStateNetworkWorse = 6,    // 卡的严重
    CCLiveStateNetworkWorst = 7,    // 卡死了
};

typedef NS_ENUM(NSInteger, CCVideoPermission) {
    CCVideoPermissionSquare = 0,    // 发布到广场
    CCVideoPermissionShare,         // 仅分享可见
    CCVideoPermissionPrivate        // 仅自己可见
};

@interface EVBaseToolManager (EVLiveAPI)

/* 支付付费的直播 */
- (void)GETLivePayWithVid:(NSString *)vid start:(void(^)())startBlock fail:(void(^)(NSError *error))failBlock successBlock:(void(^)(NSDictionary *retinfo))successBlock sessionExpire:(void(^)())sessionExpireBlock;


- (NSString *)GETLivePreStartParams:(NSDictionary *)param
                              Start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *info))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;

- (NSString *)GETLivePreStartStart:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(NSDictionary *info))successBlock
               sessionExpire:(void(^)())sessionExpireBlock;

- (void)upLoadVideoThumbWithiImage:(UIImage *)image vid:(NSString *)vid fileparams:(NSMutableDictionary *)fileparams sessionExpire:(void(^)())sessionExpireBlock;


/** 直播修改标题 */
- (void)GETVideosettitleWithVid:(NSString *)vid
                          title:(NSString *)title
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)())successBlock
                  sessionExpire:(void(^)())sessionExpireBlock;

/** 直播结束 */
- (void)GETAppdevstopliveWithVid:(NSString *)vid
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *videoInfo))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock;


/** 阅后即焚 */
- (void)GETAppdevRemoveVideoWith:(NSString *)vid
                           start:(void (^)())startBlock
                            fail:(void (^)(NSError *))failBlock
                         success:(void (^)())successBlock
                   sessionExpire:(void (^)())sessionExpireBlock;



/**
 *  举报人
 *
 *  @param name               被举报人的云播号
 *  @param descp              举报内容
 *
 *  @return 举报的url
 */
- (void)GETUserInformWithName:(NSString *)name
                  description:(NSString *)descp
                        start:(void(^)())startBlock
                      success:(void(^)())successBlock
                         fail:(void(^)())failBlock
                       expire:(void(^)())sessionExpireBlock;


/**
 *  @author shizhiang, 16-03-09 18:03:15
 *
 *  直播过程中主播发红包
 *
 *  @param vid                视频id
 *  @param ecoin              红包的云币数
 *  @param count              多少人可以抢红包
 *  @param startBlock         开始
 *  @param failBlock          失败
 *  @param successBlock       成功
 *  @param sessionExpireBlock session过期
 *
 *  @return 请求的url
 */
- (void)GETLiveSendRedPacketWithVid:(NSString *)vid
                              ecoin:(NSInteger)ecoin
                              count:(NSInteger)count
                           greeting:(NSString *)greeting
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)())successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;

/**
 *  直播开始
 *
 *  @param videoparams        送给服务器的参数 vid 必填 ,密码直播时候送 password
 *  @param startBlock
 *  @param failBlock
 *  @param successBlock
 *  @param sessionExpireBlock
 *
 *  @return
 */
- (void)GETUserstartwatchvideoWithParams:(NSDictionary *)videoparams
                                   Start:(void(^)())startBlock
                                    fail:(void(^)(NSError *error))failBlock
                                 success:(void(^)(NSDictionary *videoInfo))successBlock
                           sessionExpire:(void(^)())sessionExpireBlock;


/**
 *  @author shizhiang, 15-12-15 10:12:59
 *
 *  购买商品
 *
 *  @param goodsid            商品id
 *  @param number             商品数量
 *  @param vid                视频id
 *  @param name               视频主播云播号
 *  @param startBlock         开始
 *  @param failBlock          失败
 *  @param successBlock       成功
 *  @param sessionExpireBlock session过期
 *
 *  @return 请求的URL
 */
- (void)GETBuyPresentWithGoodsID:(NSString *)goodsid
                          number:(NSInteger)number
                             vid:(NSString *)vid
                            name:(NSString *)name
                           start:(void (^)())startBlock
                            fail:(void (^)(NSError *error))failBlock
                         success:(void (^)(NSDictionary *info))successBlock
                   sessionExpire:(void (^)())sessionExpireBlock;

/**
 *  @author shizhiang, 15-12-14 19:12:57
 *
 *  使用sessionid获取用户资产
 *
 *  @param startBlock         请求开始
 *  @param failBlock          请求失败
 *  @param successBlock       请求成功
 *  @param sessionExpireBlock session过期
 *
 *  @return 请求地址
 */
- (void)GETUserAssetsWithStart:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *videoInfo))successBlock
                 sessionExpire:(void(^)())sessionExpireBlock;

/**
 *  获取云票贡献列表
 *
 *  @param name               主播的云播号
 *  @param count              请求的条数
 *
 *  @return 请求的URL
 */
- (void)GETContributorWithUserName:(NSString *)name
                          startNum:(NSInteger)startNum
                             count:(NSInteger)count
                             start:(void (^)())startBlock
                              fail:(void (^)(NSError *error))failBlock
                           success:(void (^)(NSDictionary *info))successBlock
                     sessionExpire:(void (^)())sessionExpireBlock;

/** 抢红包 */
- (void)GETRedEnvelopeVid:(NSString *)vid
                     code:(NSString *)code
                    start:(void(^)())startBlock
                     fail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *retinfo))successBlock
            sessionExpire:(void(^)())sessionExpireBlock;

@end
