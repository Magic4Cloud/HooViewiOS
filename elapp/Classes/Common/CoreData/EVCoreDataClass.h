//
//  EVCoreDataClass.h
//  elapp
//
//  Created by 唐超 on 5/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 数据库操作类  (阅读历史记录)
 */
@interface EVCoreDataClass : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;
- (long long)getDbFileSize;
+ (instancetype)shareInstance;
- (void)cleanUpAllData;
- (BOOL)insertReadNewsId:(NSString *)newsid;
- (BOOL)checkHaveReadNewsid:(NSString *)newsid;
@end
