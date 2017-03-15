//
//  EVHotListViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"


typedef void(^hotListSeletedBlock)(EVWatchVideoInfo *watchVideoInfo);
@interface EVHotListViewCell : UITableViewCell

@property(nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) hotListSeletedBlock listSeletedBlock;

@end
