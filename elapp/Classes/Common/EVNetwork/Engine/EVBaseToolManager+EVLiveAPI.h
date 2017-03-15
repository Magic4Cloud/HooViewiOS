//
//  EVBaseToolManager+EVLiveAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


typedef NS_ENUM(NSInteger, EVLiveState) {
    EVLiveStateLiving = 0,          // 直播进行中
    EVLiveStateHoldUp = 1,          // 直播应用退到后台，主播在忙
    EVLiveStateSharing = 2,         // 直播播主正在分享
    EVLiveStateEnd = 3,             // 直播已结束
    EVLiveStateNetworkBad = 4,      // 网络不稳定
    EVLiveStatePhoneCallComeIn = 5, // 电话来了
    EVLiveStateNetworkWorse = 6,    // 卡的严重
    EVLiveStateNetworkWorst = 7,    // 卡死了
};


@interface EVBaseToolManager (EVLiveAPI)

/* 支付付费的直播 */
- (void)GETLivePayWithVid:(NSString *)vid start:(void(^)())startBlock fail:(void(^)(NSError *error))failBlock successBlock:(void(^)(NSDictionary *retinfo))successBlock sessionExpire:(void(^)())sessionExpireBlock;


- (void)GETLivePreStartParams:(NSDictionary *)param
                              Start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *info))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;



- (void)upLoadVideoThumbWithiImage:(UIImage *)image vid:(NSString *)vid fileparams:(NSMutableDictionary *)fileparams success:(void(^)(NSDictionary *dict))success sessionExpire:(void(^)())sessionExpireBlock;


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
 *
 *  直播过程中主播发红包
 *
 *  @param vid                视频id
 *  @param ecoin              红包的火眼豆数
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

//用户禁言
- (void)GETUserShutVid:(NSString *)vid
              userName:(NSString *)userName
                shutUp:(NSString *)shutup
                 start:(void(^)())startBlock
                  fail:(void(^)(NSError *error))failBlock
               success:(void(^)(NSDictionary *retinfo))successBlock
         sessionExpire:(void(^)())sessionExpireBlock;

//设置管理员
- (void)GetUserManagerVid:(NSString *)vid
                 userName:(NSString *)userName
                  manager:(NSString *)manager
                    start:(void(^)())startBlock
                     fail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *retinfo))successBlock
            sessionExpire:(void(^)())sessionExpireBlock;


- (void)GETKictUserVid:(NSString *)vid userName:(NSString *)username kick:(NSString *)kick fail:(void(^)(NSError *error))failBlock
               success:(void(^)(NSDictionary *retinfo))successBlock
         sessionExpire:(void(^)())sessionExpireBlock;

- (void)GETRequestLinkUsername:(NSString *)username success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock;

- (void)GETAcceptLinkUsername:(NSString *)username success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock;


- (void)GETCancelLindCallid:(NSString *)callid vid:(NSString *)vid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock;

- (void)GETEndLinkCallid:(NSString *)callid vid:(NSString *)vid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error sessionExpire:(void(^)())sessionExpireBlock;



//图文直播
//创建图文直播间
- (void)GETCreateTextLiveUserid:(NSString *)userid nickName:(NSString *)nickname easemobid:(NSString *)easemobid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;



//创建图文直播间
- (void)GETHistoryTextLiveStreamid:(NSString *)streamid  count:(NSString *)count stime:(NSString *)stime success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;
- (void)POSTChatTextLiveID:(NSString *)streamid from:(NSString *)from nk:(NSString *)nk msgid:(NSString *)msgid msgtype:(NSString *)msgtype msg:(NSString *)msg tp:(NSString *)tp rct:(NSString *)rct rnk:(NSString *)rnk timestamp:(NSString *)timestamp img:(UIImage *)img success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;

//直播间是否存在
- (void)GETIsHaveTextLiveOwnerid:(NSString *)ownerid streamid:(NSString *)streamid success:(void (^) (NSDictionary *retinfo))success error:(void (^)(NSError *error))error;
@end
