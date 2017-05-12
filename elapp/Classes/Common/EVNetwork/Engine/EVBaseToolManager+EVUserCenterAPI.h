 //
//  EVBaseToolManager+EVUserCenterAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"


// 用户与目标是否关注
typedef enum : NSUInteger
{
    follow = 1,
    unfollow = 0,
} FollowType;

// 定义解除绑定的类型
typedef NS_ENUM(NSUInteger, EVUnbundlingAuthtype)
{
    EVAccountSina,
    EVAccountQQ,
    EVAccountWeixin
};


/**
 支付平台
 */
typedef enum : NSUInteger {
    EVPayPlatformAll = 0,
    EVPayPlatformWeixin = 1,
    EVPayPlatformAppPay = 2,
} EVPayPlatform;


@class CCAccountImportResponse;
@interface EVBaseToolManager (EVUserCenterAPI)

/**
 *  @author Zhou feng
 *
 *  编辑用户数据.
 *
 *  @param params             用户信息.
 *  @param startBlock         操作开始的block;
 *  @param failBlock          操作失败的block;
 *  @param successBlock       操作成功的block;
 *  @param sessionExpireBlock session过期的block;
 *
 *  @return 返回Url地址.
 */
- (void)GETUsereditinfoWithParams:(NSMutableDictionary *)params
                            start:(void(^)())startBlock
                             fail:(void(^)(NSError *error))failBlock
                          success:(void(^)())successBlock
                    sessionExpire:(void(^)())sessionExpireBlock;


/**
 *  @author Zhou feng
 *
 *  上传用户头像.
 *
 *  @param image              图片对象;
 *  @param uname              用户昵称;
 *  @param startBlock         操作开始的block;
 *  @param failBlock          操作失败的block;
 *  @param successBlock       操作成功的block;
 *  @param sessionExpireBlock session过期的block;
 *
 *  @return 返回Url地址.
 */
- (void)GETUploadUserLogoWithImage:(UIImage *)image
                             uname:(NSString *)uname
                             start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *retinfo))successBlock
                     sessionExpire:(void(^)())sessionExpireBlock;








/**
 *  @author Zhou feng
 *
 *  进行用户绑定操作.
 *
 *  @param params             输入的用户信息.
 *  @param startBlock         操作开始的block;
 *  @param failBlock          操作失败的block;
 *  @param successBlock       操作成功的block;
 *  @param conflictBlock      账号绑定冲突的block;
 *  @param sessionExpireBlock session过期的block;
 *
 *  @return 返回Url地址.
 */
- (void)GETUserBindWithParams:(NSDictionary *)params
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)())successBlock
                sessionExpire:(void (^)())sessionExpireBlock;




/**
 *  获取用户基本数据， uname 和 imuser(私信账号) 两者选其中之一
 *
 */
- (void)GETBaseUserInfoWithUname:(NSString *)uname
                        orImuser:(NSString *)imuser
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *modelDict))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock;




/** 获得用户基本数据，此方法可以被上面可以用环信账号请求的方法替换掉 */
- (void)GETBaseUserInfoWithUname:(NSString *)uname
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *modelDict))successBlock
                   sessionExpire:(void(^)())sessionExpireBlock;


// 个人主页用户信息
- (void)GETBaseUserInfoWithPersonid:(NSString *)personid
                              start:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *modelDict))successBlock
                      sessionExpire:(void(^)())sessionExpireBlock;


/**
 *  获取用户基本数据， uname 和 imuser 两者选其中之一 (个人中心)
 *
 */
- (void)GETUserInfoWithUserid:(NSString *)userid
                     orImuser:(NSString *)imuser
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)(NSDictionary *modelDict))successBlock
                sessionExpire:(void(^)())sessionExpireBlock;



/** 获取用户粉丝列表数据 */
- (void)GETFansListWithName:(NSString *)name
                    startID:(NSInteger)start
                      count:(NSInteger)count
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSArray *fans))successBlock
               essionExpire:(void(^)())sessionExpireBlock;

/** 获取用户关注列表数据 */
- (void)GETFollowersListWithName:(NSString *)name
                         startID:(NSInteger)start
                           count:(NSInteger)count
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSArray *fans))successBlock
                    essionExpire:(void(^)())sessionExpireBlock;

/** 添加或者删除关注 */
- (void)GETFollowUserWithName:(NSString *)name
                   followType:(FollowType)type
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)())successBlock
                 essionExpire:(void(^)())sessionExpireBlock;

/**
 *
 *  直播过程中观众关注了主播
 *
 *  @param vid 直播视频的id
 *  @param type 关注/取消关注
 *  @param name 被关注人的云播号
 *
 *  @return url
 */
- (void)GETLivingFollowAnchorWithVid:(NSString *)vid
                                name:(NSString *)name
                              follow:(FollowType)type;


- (void)GETUserfriendlistStart:(NSInteger)start
                         count:(NSInteger)count
                         start:(void(^)())startBlock
                          fail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *result))successBlock
                  essionExpire:(void(^)())sessionExpireBlock;
/** 获取个人中心用户视频列表数据 */
- (void)GETUserVideoListWithName:(NSString *)name
                            type:(NSString *)type
                           start:(NSInteger)start
                           count:(NSInteger)count
                      startBlock:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSArray *videos))successBlock
                    essionExpire:(void(^)())sessionExpireBlock;


/** 获取个人中心主页直播列表数据 */
- (void)GETHVCenterVideoListWithUserid:(NSString *)userid
                           start:(NSInteger)start
                           count:(NSInteger)count
                      startBlock:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *retinfo))successBlock
                    essionExpire:(void(^)())sessionExpireBlock;

/** 获取个人中心主页文章列表数据 */
- (void)GETHVCenterNewsListWithUserid:(NSString *)userid
                                start:(NSInteger)start
                                count:(NSInteger)count
                           startBlock:(void(^)())startBlock
                                 fail:(void(^)(NSError *error))failBlock
                              success:(void(^)(NSDictionary *retinfo))successBlock
                         essionExpire:(void(^)())sessionExpireBlock;

/** 获取个人中心主页评论列表数据 */
- (void)GETHVCenterCommentListWithUserid:(NSString *)userid
                                personid:(NSString *)personid
                                   start:(NSInteger)start
                                   count:(NSInteger)count
                              startBlock:(void(^)())startBlock
                                    fail:(void(^)(NSError *error))failBlock
                                 success:(void(^)(NSDictionary *retinfo))successBlock
                            essionExpire:(void(^)())sessionExpireBlock;

//点赞
- (void)GETLikeOrNotWithUserName:(NSString *)name
                            Type:(NSString *)type
                          action:(NSString *)action
                          postid:(NSString *)postid
                           start:(void(^)())startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)())successBlock
                    essionExpire:(void(^)())sessionExpireBlock;

//文章like
- (void)GETLikeNewsWithNewsid:(NSString *)newsid
                       action:(NSString *)action
                        start:(void(^)())startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)())successBlock
                 essionExpire:(void(^)())sessionExpireBlock;

//获取我的发布
- (void)GETMyReleaseListWithUserid:(NSString *)userid
                              type:(NSString *)type
                             start:(NSInteger)start
                             count:(NSInteger)count
                        startBlock:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *videos))successBlock
                      essionExpire:(void(^)())sessionExpireBlock;



/** 退出登录，注销账号 */
- (void)GETLogoutWithFail:(void(^)(NSError *error))failBlock
                  success:(void(^)())successBlock
             essionExpire:(void(^)())sessionExpireBlock;



/** 账号解绑 */
-(void)GETUnbundlingtype:(EVUnbundlingAuthtype)unbundling
                   start:(void (^)())startBlock
                    fail:(void (^)(NSError *error))failBlock
                 success:(void (^)(id success))successBlock
            essionExpire:(void (^)())sessionExpireBlock;

/**< 获取用户个人设置 */
- (void)GETUserSettingInfoStart:(void(^)())startBlock
                        success:(void(^)(NSDictionary *info))successBlock
                           fail:(void(^)(NSError *error))failBlock
                  sessionExpire:(void(^)())sessionExpireBlock;

/**
 *  编辑用户设置
 *
 *  @param follow             关注消息推送开关，"1"推送，"0"不推送
 *  @param disturb            免打扰开关， "1"开启，"0"关闭
 *  @param live               直播消息推送总开关，"1"推送，"0"不推送
 *
 *  @return
 */
- (void)GETUserEditSettingWithFollow:(BOOL)follow
                             disturb:(BOOL)disturb
                                live:(BOOL)live
                               start:(void(^)())startBlock
                                fail:(void(^)(NSError *error))failBlock
                             success:(void(^)())successBlock
                       sessionExpire:(void(^)())sessionExpireBlock;






/**
 *  提现记录
 *  consumptionDetailslistWithStart
 * @param  recordlist，消费记录列表对象
 * @param  time，消费时间，string
 * @param  rmb，获取的金额，int
 * @param  riceroll，花费的云票数，int
 */
- (void)GETWithdrawallistWithStart:(NSInteger)start
                             count:(NSInteger)count
                             start:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock;

/**
 * 提现记录
 * consumptionDetailslistWithStart
 * @param  optionlist，可充值列表对象
 * @param  rmb，充值金额，单位为元，int
 * @param   ecoin，获取的火眼豆数，int
 * @param  free，赠送的火眼豆数，int
 */
- (void)GETPrepaidRecordslistWithStart:(NSInteger)start
                                 count:(NSInteger)count
                                 start:(void(^)())startBlock
                                  fail:(void(^)(NSError *error))failBlock
                               success:(void(^)(NSDictionary *info))successBlock
                        sessionExpired:(void(^)())sessionExpiredBlock;


//充值成功回调
- (void)GETSuccessPayToServiceWithUid:(NSString *)userid
                              orderid:(NSString *)orderid
                                  rmb:(NSString *)rmb
                                start:(void(^)())startBlock
                                 fail:(void(^)(NSError *error))failBlock
                              success:(void(^)(NSDictionary *info))successBlock
                       sessionExpired:(void(^)())sessionExpiredBlock;



/**
 消费记录

 @param start <#start description#>
 @param count <#count description#>
 @param startBlock <#startBlock description#>
 @param failBlock <#failBlock description#>
 @param successBlock <#successBlock description#>
 @param sessionExpiredBlock <#sessionExpiredBlock description#>
 */
- (void)GETConsumeListWithStart:(NSInteger)start
                          count:(NSInteger)count
                          start:(void(^)())startBlock
                           fail:(void(^)(NSError *error))failBlock
                        success:(void(^)(NSDictionary *info))successBlock
                 sessionExpired:(void(^)())sessionExpiredBlock;
/**
 *  充值选项
 *
 *  @param plateform           充值平台
 *
 *  @return 请求的URL
 */
- (void)GETCashinOptionWith:(EVPayPlatform)plateform
                      start:(void(^)())startBlock
                       fail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSDictionary *info))successBlock
             sessionExpired:(void(^)())sessionExpiredBlock;

/**
 *  苹果支付
 *
 *  @param receipt             苹果的字符串
 *  @param startBlock          开始
 *  @param failBlock           错误
 *  @param successBlock        成功
 *  @param sessionExpiredBlock session过期
 *
 *  @return <#return value description#>
 */
- (void)POSTApplevalidWith:(NSString *)receipt platfrom:(NSString *)platfrom amound:(NSString *)amound
                     start:(void(^)())startBlock
                      fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *info))successBlock
            sessionExpired:(void(^)())sessionExpiredBlock;




/**
 获取多个视频接口

 @param list <#list description#>
 @param failBlock <#failBlock description#>
 @param successBlock <#successBlock description#>
 */
- (void)GETVideoInfosList:(NSString *)list fail:(void(^)(NSError *error))failBlock
                  success:(void(^)(NSDictionary *info))successBlock;



/**
 用户标签

 @param failBlock <#failBlock description#>
 @param successBlock <#successBlock description#>
 */
- (void)GETUserTagsListfail:(void(^)(NSError *error))failBlock
                    success:(void(^)(NSDictionary *info))successBlock;





/**
 用户所有标签

 @param failBlock <#failBlock description#>
 @param successBlock <#successBlock description#>
 */
- (void)GETAllUserTagsListfail:(void(^)(NSError *error))failBlock
                       success:(void(^)(NSDictionary *info))successBlock;


/**
 设置标签

 @param list <#list description#>
 @param failBlock <#failBlock description#>
 @param successBlock <#successBlock description#>
 */
- (void)GETSetUserTagsList:(NSString *)list fail:(void(^)(NSError *error))failBlock
                   success:(void(^)(NSDictionary *info))successBlock;
@end
