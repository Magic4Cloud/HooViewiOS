//
//  EVLiveVideoView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@protocol CCLiveVideoViewDelegate  <NSObject>

@optional

/**
 *  @author 杨尚彬
 *
 *  点击头像的代理方法
 *
 *  @param video 视频模型
 */
- (void)clickHeadImageForVideo:(EVCircleRecordedModel *)video;

/**
 *  @author 杨尚彬
 *
 *  点击缩略图的代理方法
 *
 *  @param video 视频模型
 */
- (void)clickThumbImageForVideo:(EVCircleRecordedModel *)video;

@end

@interface EVLiveVideoView : UIView

@property ( strong, nonatomic ) EVCircleRecordedModel *model;           /**< 视频模型对象 */

@property ( weak, nonatomic ) id<CCLiveVideoViewDelegate> delegate;     /**< 代理 */
//
- (void)replaceThumbWithLastModel:(EVCircleRecordedModel *)lastModel newModel:(EVCircleRecordedModel *)newModel;


@end
