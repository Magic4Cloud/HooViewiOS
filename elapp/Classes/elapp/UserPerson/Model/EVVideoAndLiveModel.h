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
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * thumb;
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * logoUrl;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * living;
@property (nonatomic, copy) NSString * watching;
@property (nonatomic, copy) NSString * watch;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * like;
@property (nonatomic, copy) NSString * timeSpan;
@property (nonatomic, copy) NSString * duration;
@property (nonatomic, copy) NSString * shareUrl;
@property (nonatomic, copy) NSString * shareThumbUrl;
@property (nonatomic, copy) NSString * live_start_time;

@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isPaid;
@property (nonatomic, assign) BOOL isUpload;
@end
