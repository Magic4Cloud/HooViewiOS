//
//  EVHVCenterCommentTableView.h
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCommentTopicModel.h"
#import "EVWatchVideoInfo.h"
typedef void(^pushCommentBlock)(EVCommentTopicModel *topicModel);

@interface EVHVCenterCommentTableView : UITableView

@property (nonatomic, strong) EVWatchVideoInfo *WatchVideoInfo;

@property (nonatomic, copy) pushCommentBlock commentBlock;


- (void)loadData;

@end
