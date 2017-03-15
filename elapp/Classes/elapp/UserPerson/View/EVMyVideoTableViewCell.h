//
//  EVMyVideoTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVImageViewWithMask.h"
#import "EVWatchVideoInfo.h"
@class EVUserVideoModel;
@class EVMyVideoTableViewCell;
@protocol EVMyVideoCellDelegate <NSObject>

- (void)videoTableViewButton:(UIButton *)button videoCell:(EVMyVideoTableViewCell *)videoCell;

@end

@interface EVMyVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EVImageViewWithMask *videoShot;        // 视频截图
@property (strong, nonatomic) EVWatchVideoInfo *videoModel;                 // cell的视频模型

@property (nonatomic, weak) id<EVMyVideoCellDelegate> delegate;
@end
