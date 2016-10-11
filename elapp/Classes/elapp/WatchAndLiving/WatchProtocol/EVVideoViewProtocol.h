//
//  EVVideoViewProtocol.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>
@class EVWatchLiveEndData;

@protocol CCVideoViewProtocol <NSObject>

@optional



/**
 *  @author shizhiang, 16-03-21 17:03:19
 *
 *  更新直播状态
 *
 *  @param living 直播状态
 */
- (void)updateLiveState:(BOOL)living;

/**
 *  @author shizhiang, 16-03-08 19:03:50
 *
 *  更新回放进度条
 *
 *  @param info 最新信息
 */
- (void)updateRecorderProgressWithInfo:(NSDictionary *)info;

/**
 *  @author shizhiang, 16-03-07 18:03:45
 *
 *  更新视频数据
 *
 *  @param type 要更新的数据类型
 *  @param data 新的数据
 */
- (void)updateDataWithType:(NSInteger)type
                      data:(NSMutableArray *)data;

/**
 *  @author shizhiang, 16-03-10 16:03:21
 *
 *  增加收到的礼物
 *
 *  @param presents 收到的礼物
 */
- (void)updatePresents:(NSArray *)presents;

/**
 *  @author shizhiang, 16-03-09 19:03:40
 *
 *  展示红包
 *
 *  @param data 红包信息
 */
- (void)showRedEnvelopWithData:(NSDictionary *)data;





/**
 *  @author shizhiang, 16-03-07 19:03:36
 *
 *  获取评论失败
 */
- (void)updateMoreCommentFail;

/**
 *  @author shizhiang, 16-03-07 19:03:53
 *
 *  被禁言
 */
- (void)audienceShutedup;

/**
 *  @author shizhiang, 16-03-07 19:03:53
 *
 *  禁言成功
 */
- (void)audienceShutedupSuccess;

/**
 *  @author shizhiang, 16-03-07 19:03:53
 *
 *  没有权限
 */
- (void)audienceShutedupDenied;

/**
 *  修改人  :杨尚彬
 *  增加用户消息啊
 *
 *  @param dict <#dict description#>
 */
- (void)updateManegerUserAndShuteDup:(NSDictionary *)dict;

/**
 *  修改人:杨尚彬
 *  跑道消息
 *  @param dict <#dict description#>
 */
- (void)updateNewMessageListRunWay:(NSDictionary *)dict;

/**
 * 弹幕信息
 *
 */
- (void)updateNewMessageListBarrage:(NSDictionary *)dict;

/**
 *  聊天服务器告诉观看端要更换播放的流地址
 *
 *  @param newPlayUrl 下发的新的流地址
 */
- (void)chatServerSaidToChangeVideoStreamPlayUrl:(NSString *)newPlayUrl;
@end

