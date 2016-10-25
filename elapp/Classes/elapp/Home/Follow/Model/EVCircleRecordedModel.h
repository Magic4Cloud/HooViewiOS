//
//  EVCircleRecordedModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"
#import "CCEnums.h"

@class EVOutCommentModel;


@interface EVCircleRecordedModel : CCBaseObject

@property (copy, nonatomic) NSString *bgpic;
@property (assign, nonatomic) NSInteger gps;
@property (copy, nonatomic) NSString *gps_latitude;
@property (copy, nonatomic) NSString *gps_longitude;
@property (assign, nonatomic) BOOL living;
@property (assign, nonatomic) NSInteger living_status;
@property (copy, nonatomic) NSString *location;
@property (assign, nonatomic) BOOL accompany;


@property (copy, nonatomic) NSString *vid;                      /**< 视频vid */

@property (nonatomic,copy) NSString *play_url;                  /** 视频播放地址 */

@property (copy, nonatomic) NSString *title;                    /**< 视频标题 */
@property (copy, nonatomic) NSString *thumb;                    /**< 视频缩略图url地址 */
@property (nonatomic,strong) UIImage *thumbImage;

@property (copy, nonatomic) NSString *name;                     /**< 视频直播者名字 */
@property (copy, nonatomic) NSString *nickname;                 /**< 用户昵称 */
@property (copy, nonatomic) NSString *logourl;                  /**< 直播用户头像 */
@property (assign, nonatomic) NSInteger vip;                    /**< 是否是vip 0 否 1 是 */
@property (assign, nonatomic) NSInteger watch;            /**< 观看数 */
@property (assign, nonatomic) NSInteger like_count;             /**< 点赞次数 */
@property (assign, nonatomic) NSInteger watching;         /**< 正在观看数 */
@property (assign, nonatomic) NSInteger duration;               /**< 视频时长 */
@property (copy, nonatomic) NSString *living_device;            /**< 直播设备 */
@property (copy, nonatomic) NSString *network_type;             /**< 网络类型 */
@property (copy, nonatomic) NSString *start_time;               /**< 直播开始时间(change by 佳南) */
@property (copy, nonatomic) NSString *live_stop_time;           /**< 直播结束时间 */
@property (assign, nonatomic) NSInteger live_start_time_span;   /**< 直播开始距离现在的描述 */
@property (assign, nonatomic) NSInteger live_stop_time_span;    /**< 直播结束距离现在的秒数 */
@property (assign, nonatomic) NSInteger outliked;               /**< 是否点赞了 0 未点 1 点了 */
@property (assign, nonatomic) NSInteger outlike_count;          /**< 外部点赞数 */
@property (assign, nonatomic) NSInteger outcomment_count;       /**< 外部点赞数 */
@property ( strong, nonatomic ) NSArray *outcomments;           /**< 回放外部评论列表 */
@property (nonatomic, strong ) NSArray  *likeusers;            //点赞数组
@property (strong, nonatomic) NSArray *comments;        //话题评论列表
@property (nonatomic, copy) NSString *distance;                 /**< 离主播的距离 */
@property (copy, nonatomic) NSString *share_url;
@property (copy, nonatomic) NSString *share_thumb_url;
@property (assign, nonatomic) BOOL recommend;                   /**< 是否推荐，1为推荐，0为非推荐 */
@property (copy, nonatomic) NSString *logo_thumb;               /**< 用户封面头像 */
@property (assign, nonatomic) NSInteger share_count;
/**< 是否展示距离，只有附近的视频页面为yes */
@property (nonatomic, assign) BOOL showDistance;

@property (nonatomic ,assign) NSInteger isliked;

@property (assign, nonatomic,readonly) CGFloat subjectCommentHeight;


@property (nonatomic, assign) CGFloat  calButtonHeight;

@property (assign, nonatomic) EVLivePermission permission;      /**< 0公开,6带密码 */

/**
 *  @author 杨尚彬
 *
 *  解析数据
 *
 *  @param messageData 请求返回的数据
 *
 *  @return 视频对象数据
 */
+ (NSArray *)videosAarryWithMessageData:(id)messageData;


+ (NSArray *)cityVidesArrayWithMessageData:(id)messageData;


+ (NSArray *)videosArrayWithSubjectData:(id)videoData;



@end

