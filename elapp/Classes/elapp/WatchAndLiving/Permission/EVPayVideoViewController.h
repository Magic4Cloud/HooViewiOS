//
//  EVPayVideoViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"

/**
 *  付费直播/录播 提示付费页
 */
@interface EVPayVideoViewController : EVViewController

@property (nonatomic, copy  ) void(^payCallBack)(BOOL isPay, BOOL isRecharge, NSString *ecion);
@property (nonatomic, strong) NSDictionary *payInfoDictionary;
@property (nonatomic, strong) NSString *vid;

+ (void)fetchDataWithVid:(NSString *)vid complete:(void(^)(NSDictionary *retinfo, NSError *error))complete;
- (void)updateEcion:(NSString *)ecion;

@end
