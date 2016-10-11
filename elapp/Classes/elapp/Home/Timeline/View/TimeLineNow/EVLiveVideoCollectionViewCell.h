//
//  EVLiveVideoCollectionViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;
#import "EVLiveVideoView.h"

@interface EVLiveVideoCollectionViewCell : UICollectionViewCell

@property ( strong, nonatomic ) EVCircleRecordedModel *cellItem;
@property (nonatomic, weak) id<CCLiveVideoViewDelegate> delegate;

+ (CGSize)cellSize;
+ (NSString *)cellIdentifier;

- (void)replaceThumbWithLastModel:(EVCircleRecordedModel *)lastModel newModel:(EVCircleRecordedModel *)newModel;

@end
