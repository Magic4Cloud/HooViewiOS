//
//  EVMyReleaseOfLiveViewController.h
//  elapp
//
//  Created by 周恒 on 2017/4/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVWatchVideoInfo.h"
#import "EVUserModel.h"

typedef void(^pushTextLiveBlock)(EVUserModel *watchVideoInfo);

typedef void(^pushVideoBlock)(EVWatchVideoInfo *videoModel);


@interface EVMyReleaseOfLiveViewController : UIViewController

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, copy) pushVideoBlock videoBlock;

@property (nonatomic, copy) pushTextLiveBlock textLiveBlock;



@end
