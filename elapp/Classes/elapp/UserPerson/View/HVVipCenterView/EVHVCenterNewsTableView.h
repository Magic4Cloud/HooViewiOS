//
//  EVHVCenterNewsTableView.h
//  elapp
//
//  Created by 周恒 on 2017/4/28.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNewsModel.h"
#import "EVWatchVideoInfo.h"
typedef void(^pushArticleBlock)(EVNewsModel *newsModel);

@interface EVHVCenterNewsTableView : UITableView

@property (nonatomic, strong) EVWatchVideoInfo *WatchVideoInfo;

@property (nonatomic, copy) pushArticleBlock ArticleBlock;

- (void)loadNewData;

@end

