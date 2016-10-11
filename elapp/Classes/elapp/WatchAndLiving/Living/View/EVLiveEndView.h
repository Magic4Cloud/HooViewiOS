//
//  EVLiveEndView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveEndBaseView.h"

@class EVLiveEndView;
// 直播结束显示界面 按钮tag
typedef NS_ENUM(NSInteger, EVLiveEndViewButtonType)
{
    EVLiveEndViewReadingDestroyButton = 100,
    EVLiveEndViewSaveVideoButton
};

@protocol EVLiveEndViewDelegate <NSObject>

@optional
- (void)liveEndView:(EVLiveEndView *)liveEndView didClicked:(EVLiveEndViewButtonType)type;

@end
// 数据模型
@interface EVLiveEndViewData : NSObject
/** 观众数 */
@property (nonatomic,assign) NSInteger audienceCount;
/** 点赞数 */
@property (nonatomic,assign) NSInteger likeCount;
/** 评论数 */
@property (nonatomic,assign) NSInteger commentCount;
/** 云票数 */
@property (nonatomic,assign) long long riceCount;
/** 签名 */
@property (nonatomic,copy) NSString *signature;
/** 回放url */
@property (nonatomic,copy) NSString *playBackURLString;
/** 是否允许保存视频 */
@property (assign, nonatomic) BOOL noCanKeepVideo;

@end

@interface EVLiveEndView : EVLiveEndBaseView

@property (nonatomic,weak) id<EVLiveEndViewDelegate> delegate;
/** 数据模型 */
@property (nonatomic,strong) EVLiveEndViewData *liveViewData;
@property (nonatomic, weak) UIImage *backgroundImage;
/** 显示方法 */
- (void)show:(void(^)())complete;
/** 消失带动画的方法 */
- (void)dismiss;

@end
