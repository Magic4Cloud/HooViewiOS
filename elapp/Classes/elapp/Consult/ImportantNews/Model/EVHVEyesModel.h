//
//  EVHVEyesModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVHVEyesModel : NSObject

@property (nonatomic, copy) NSString *eyesID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *viewCount;

@property (nonatomic, copy) NSString *priority;

@property (nonatomic, assign) BOOL haveRead;
@end
