//
//  EVTextLiveModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVTextLiveModel : EVBaseObject

@property (nonatomic, copy) NSString *streamid;


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) NSInteger viewcount;

- (void)synchronized;
+ (EVTextLiveModel *)textLiveObject;

+ (void)cleanTextLiveInfo;
@end
