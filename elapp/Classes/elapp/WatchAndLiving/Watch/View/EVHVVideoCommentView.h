//
//  EVHVVideoCommentView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVHVVideoCommentModel.h"


@interface EVHVVideoCommentView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *commentTableView;

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, copy) void(^listToVipCenterBlock)(EVHVVideoCommentModel *commentModel);



- (void)loadDataVid:(NSString *)vid start:(NSString *)start count:(NSString *)count;
@end
