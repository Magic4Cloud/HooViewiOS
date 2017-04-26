//
//  EVVideoAndLiveModel.h
//  elapp
//
//  Created by 唐超 on 4/19/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 精品视频  直播列表 model
 */
@interface EVVideoAndLiveModel : NSObject

@property (nonatomic, copy) NSString * vid;
@property (nonatomic, copy) NSString * living_status;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * living;
@property (nonatomic, copy) NSString * duration;
@property (nonatomic, copy) NSString * thumb;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * logourl;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * live_start_time;
@property (nonatomic, copy) NSString * mode;
@property (nonatomic, copy) NSString * watch_count;
@property (nonatomic, copy) NSString * like_count;
@property (nonatomic, copy) NSString * comment_count;
@property (nonatomic, copy) NSString * watching_count;
@property (nonatomic, copy) NSString * permission;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * location;

@property (nonatomic, assign) BOOL isHot;
@end
