//
//  EVWatchHistoryView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVVideoAndLiveModel;

typedef void(^pushWatchVC)(EVVideoAndLiveModel *watchVideoInfo);
@interface EVWatchHistoryView : UIView

@property (nonatomic, copy) pushWatchVC pushWatchBlock;
- (void)loadNewData;
@end
