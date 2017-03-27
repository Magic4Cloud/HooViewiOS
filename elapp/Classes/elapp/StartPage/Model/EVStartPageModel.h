//
//  EVStartPageModel.h
//  elapp
//
//  Created by 唐超 on 3/27/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 启动图model
 */
@interface EVStartPageModel : NSObject
@property (nonatomic, copy)NSString * id;
@property (nonatomic, copy)NSString * valid;
@property (nonatomic, copy)NSString * starttime;
@property (nonatomic, copy)NSString * endtime;
@property (nonatomic, copy)NSString * adurl;
- (instancetype)initModelWithDic:(NSDictionary *)dic;
@end
