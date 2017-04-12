//
//  EVTopicModel.h
//  elapp
//
//  Created by 唐超 on 4/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVNewsModel.h"
/**
 专题model
 */
@interface EVTopicModel : NSObject

@property (nonatomic, copy)NSString * id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * introduce;
@property (nonatomic, copy)NSString * cover;
@property (nonatomic, copy)NSString * viewCount;
@property (nonatomic, strong)NSArray * news;
@end
