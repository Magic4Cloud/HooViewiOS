//
//  EVBeatyCollectionViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@interface EVBeatyCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) EVCircleRecordedModel *model; /**< 视频数据 */


+ (CGSize)cellSize;
+ (NSString *)cellIdentifier;

@property (copy, nonatomic) void(^avatarClick)(EVCircleRecordedModel *model);  /**< 头像点击 */

@end
