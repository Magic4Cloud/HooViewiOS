//
//  EVMyVideoTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVUserVideoModel;
@class EVMyVideoTableViewCell;
#import "EVImageViewWithMask.h"


@interface EVMyVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EVImageViewWithMask *videoShot;        // 视频截图
@property (strong, nonatomic) EVUserVideoModel *videoModel;                 // cell的视频模型

@end
