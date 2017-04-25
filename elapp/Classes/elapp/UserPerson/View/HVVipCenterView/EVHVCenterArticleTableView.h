//
//  EVHVCenterArticleTableView.h
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNewsModel.h"
#import "EVWatchVideoInfo.h"
typedef void(^pushArticleBlock)(EVNewsModel *newsModel);

@interface EVHVCenterArticleTableView : UITableView

@property (nonatomic, strong) EVWatchVideoInfo *WatchVideoInfo;

@property (nonatomic, copy) pushArticleBlock ArticleBlock;

@end
