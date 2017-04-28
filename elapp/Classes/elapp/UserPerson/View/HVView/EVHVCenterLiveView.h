//
//  EVHVCenterLiveView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVUserModel.h"
#import "EVTextLiveModel.h"

@class EVUserVideoModel;
typedef void(^pushTextLiveBlock)(EVUserModel *watchVideoInfo);

typedef void(^pushVideoBlock)(EVWatchVideoInfo *videoModel);
@interface EVHVCenterLiveView : UITableView

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, copy) pushVideoBlock videoBlock;

@property (nonatomic, copy) pushTextLiveBlock textLiveBlock;

- (void)getDataWithName:(NSString *)name;
- (void)loadNewData;

@end
