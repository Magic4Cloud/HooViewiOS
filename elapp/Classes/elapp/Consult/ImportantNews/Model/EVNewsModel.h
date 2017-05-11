//
//  EVNewsModel.h
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVCoreDataClass.h"
/**
 首页新闻model
 */
@interface EVNewsModel : NSObject
@property (nonatomic, copy)NSString * newsID;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSArray * cover;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * viewCount;

@property (nonatomic, assign)float  cellHeight;
@property (nonatomic, assign) BOOL haveRead;
@end


