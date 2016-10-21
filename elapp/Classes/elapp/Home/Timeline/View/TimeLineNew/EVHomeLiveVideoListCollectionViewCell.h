//
//  EVHomeLiveVideoListCollectionViewCell.h
//  elapp
//
//  Created by Ananwu on 2016/10/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@interface EVHomeLiveVideoListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) EVCircleRecordedModel *model; /**< 视频数据 */

+ (CGSize)cellSize;

@property (copy, nonatomic) void(^avatarClick)(EVCircleRecordedModel *model);  /**< 头像点击 */

@end
