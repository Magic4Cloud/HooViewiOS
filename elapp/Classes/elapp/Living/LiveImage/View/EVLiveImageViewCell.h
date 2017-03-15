//
//  EVLiveImageViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVWatchVideoInfo;
typedef void(^hotListSeletedBlock)(EVWatchVideoInfo *watchVideoInfo,EVWatchVideoInfo *liveVideoInfo);
@interface EVLiveImageViewCell : UITableViewCell
@property(nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataLiveArray;

@property (nonatomic, copy) hotListSeletedBlock listSeletedBlock;
@end
