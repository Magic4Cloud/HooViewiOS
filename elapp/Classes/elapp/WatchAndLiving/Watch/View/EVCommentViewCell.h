//
//  EVCommentViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHVVideoCommentModel.h"

@interface EVCommentViewCell : UITableViewCell

@property (nonatomic, strong) EVHVVideoCommentModel *videoCommentModel;
@property (nonatomic, copy) NSString *likeType;

@end
