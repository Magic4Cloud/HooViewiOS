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

/* "vid": "6k1Pgl0bi90MiOEj",
 "living_status": 2,
 "title": "测试退路",
 "living": 0,
 "duration": 18296,
 "thumb": "http://appgwdev.hooview.com/resource//user/91/08/14276c27857593079fa4300373e88026.jpg",
 "name": "17726098",
 "nickname": "火眼财经4987",
 "logourl": "http://appgwdev.hooview.com/resource/user/man.png",
 "level": 0,
 "live_start_time": "2017-04-06 10:53:59",
 "mode": 0,
 "watch_count": 59,
 "like_count": 0,
 "comment_count": 0,
 "watching_count": 0,
 "permission": 0,
 "password": "",
 "location": "未知星球"
 */
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

@end
