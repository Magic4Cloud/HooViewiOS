//
//  EVHomeLiveVideoListCollectionViewCell.h
//  elapp
//
//  Created by Ananwu on 2016/10/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@protocol EVHomeLiveVideoListCollectionViewCellDelegate <NSObject>

@required
- (void)toOtherPersonalUserCenter:(EVCircleRecordedModel *)model;
- (void)playVideo:(EVCircleRecordedModel *)model;

@end

@interface EVHomeLiveVideoListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) EVCircleRecordedModel *model; /**< 视频数据 */
@property (nonatomic, weak) id<EVHomeLiveVideoListCollectionViewCellDelegate> delegate;
+ (CGSize)cellSize;

@end
