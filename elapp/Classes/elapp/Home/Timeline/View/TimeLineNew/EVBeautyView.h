//
//  EVBeautyView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@interface EVBeautyView : UIView

@property (strong, nonatomic) EVCircleRecordedModel *model; /**< 视频数据 */
@property (copy, nonatomic) void(^avatarClick)(EVCircleRecordedModel *model);  /**< 头像点击 */
@property (weak, nonatomic) UIImageView *videoImgV;                 /**< 视频封面 */

@end
