//
//  EVWatchHistoryView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVWatchVideoInfo;

typedef void(^pushWatchVC)(EVWatchVideoInfo *watchVideoInfo);
@interface EVWatchHistoryView : UIView

@property (nonatomic, copy) pushWatchVC pushWatchBlock;
@end
