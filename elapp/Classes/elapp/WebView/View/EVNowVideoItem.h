//
//  EVNowVideoItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"
@class EVDiscoverNowVideoCell;

@interface EVNowVideoListItem : EVBaseObject

@property (nonatomic, assign) NSInteger next;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSMutableArray *videos;

- (void)mergeWithVides:(NSArray *)videos;

/**
 *  @author gaopeirong, 15-10-20 17:10:31
 *
 *  更新视频信息
 *
 *  @param videoDicts 视频信息字典
 *
 *  @return 更新后的视频数组
 */
- (NSArray *)updateViedoItemDictionaries:(NSArray *)videoDicts;
- (BOOL)mergeWithNoSquenceVides:(NSArray *)videos;

@end

@interface EVNowVideoItem : EVBaseObject

@property (nonatomic, assign) BOOL hasAppear;

@property (nonatomic, assign) BOOL updateThumb;

@property (nonatomic,weak) EVDiscoverNowVideoCell *cell;

/**视频的id*/
@property (nonatomic, copy) NSString *vid;
/**视频的标题*/
@property (nonatomic, copy) NSString *title;
/**视频图片地址*/
@property (nonatomic, copy) NSString *thumb;
/**视频直播者名称*/
@property (nonatomic, copy) NSString *nickname;
/**视频直播者头像*/
@property (nonatomic, copy) NSString *logourl;
/**云播号*/
@property (nonatomic,copy)  NSString  *name;
/**1是直播0是录播*/
@property (nonatomic, assign) BOOL living;

@property (nonatomic, assign) NSInteger vip;
/**视频正在观看用户数*/
@property(nonatomic,assign) NSUInteger watching_count;
/**直播开始时间*/
@property (nonatomic, copy) NSString *live_start_time;
/**直播结束时间*/
@property (nonatomic,copy) NSString *live_stop_time;
/**直播开始时间距的秒数*/
@property (nonatomic, assign) NSUInteger live_start_time_span;
/**直播结束时间距离现在的秒数*/
@property (nonatomic, assign) NSUInteger live_stop_time_span;

/**音视频模式，1为音频，0为视频*/
@property (nonatomic, assign) int mode;
/** 视频播放地址用于加速 */
@property (nonatomic,copy) NSString *play_url;

@property (nonatomic,strong) NSData *data;
/** 用户的备注信息，主要用于备注用户的姓名 */
@property (copy, nonatomic) NSString *remarks;
/**location，直播位置信息，string*/
@property (nonatomic,copy) NSString *location;
/**录播的总时长*/
@property (nonatomic,copy) NSString *duration;
/**视频观看次数*/
@property (nonatomic,assign) NSUInteger watch_count;
/**视频喜欢次数*/
@property (nonatomic,assign) NSUInteger like_count;
/** 评论次数 */
@property (nonatomic, assign) NSUInteger comment_count;
@property (copy, nonatomic) NSString *password;  /**< 如果是自己的，并且permission为6，则表示视频的密码，否则不存在 */
@property (assign, nonatomic) EVLivePermission permission;  /**< 视频权限信息， 如果不是访问自己的视频，则不会显示 */

- (BOOL)updateWithInfo:(NSDictionary *)info;
- (void)updateWithItem:(EVNowVideoItem *)item;

@end
