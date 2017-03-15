//
//  EVLiveWatchManager.m
//  elapp
//
//  Created by 杨尚彬 on 16/9/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVLiveWatchManager.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVVideoViewProtocol.h"

@interface EVLiveWatchManager ()

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;


@end


@implementation EVLiveWatchManager


- (void)settingManagerWithName:(NSString *)name vid:(NSString *)vid state:(BOOL)state
{
    NSString *manager = [NSString stringWithFormat:@"%d",state];
    [self.baseToolManager GetUserManagerVid:vid userName:name manager:manager start:^{
        
    } fail:^(NSError *error) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(settingManagerFail)]) {
            [self.protocol settingManagerFail];
        }
    } success:^(NSDictionary *retinfo) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(settingManagerSuccess)]) {
            [self.protocol settingManagerSuccess];
        }
    } sessionExpire:^{
        
    }];
}

- (void)kickUserWithName:(NSString *)name vid:(NSString *)vid state:(BOOL)state
{
    NSString *kick = [NSString stringWithFormat:@"%d",state];
   [self.baseToolManager GETKictUserVid:vid userName:name kick:kick fail:^(NSError *error) {
       if (self.protocol && [self.protocol respondsToSelector:@selector(settingManagerFail)]) {
           [self.protocol settingManagerFail];
       }
   } success:^(NSDictionary *retinfo) {
       if (self.protocol && [self.protocol respondsToSelector:@selector(settingManagerSuccess)]) {
           [self.protocol settingManagerSuccess];
       }
   } sessionExpire:^{
       
   }];
}

- (void)shutupAudienceWithAudienceName:(NSString *)name vid:(NSString *)vid shutupState:(BOOL)shutup
{
    NSString *shutpStr = [NSString stringWithFormat:@"%d",shutup];
    [self.baseToolManager GETUserShutVid:vid userName:name shutUp:shutpStr start:^{
        
        
    } fail:^(NSError *error) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(audienceShutedupFail)]) {
            [self.protocol audienceShutedupFail];
        }
    } success:^(NSDictionary *retinfo) {
        
        if (self.protocol && [self.protocol respondsToSelector:@selector(audienceShutedupSuccess)]) {
            [self.protocol audienceShutedupSuccess];
        }
    } sessionExpire:^{
        
        
    }];
}



+ (NSArray *)isManagerUserAndShutupName:(NSString *)name shutUsers:(NSMutableArray *)shutusers mngUsers:(NSMutableArray *)mngusers
{
    NSMutableArray *arrayCon = [NSMutableArray arrayWithObjects:kE_GlobalZH(@"setting_manager"),kE_GlobalZH(@"manager_list"),kE_GlobalZH(@"e_gag"),kE_GlobalZH(@"e_report"),kE_GlobalZH(@"e_kickuser"), nil];

    if (mngusers.count == 0) {
        if (shutusers == 0) {
            
        }else{
            for (NSString *users in shutusers) {
                if ([users isEqualToString:name]) {
                    [arrayCon replaceObjectAtIndex:2 withObject:kE_GlobalZH(@"complete_gag")];
                    break;
                }
            }
        }
    }else{
        for (NSString *managerUser in mngusers) {
            if ([managerUser isEqualToString:name]) {
                if (shutusers.count == 0) {
                    [arrayCon replaceObjectAtIndex:0 withObject:kE_GlobalZH(@"cancel_manager")];
                    break;
                }else {
                    for (NSString *users in shutusers) {
                        if ([users isEqualToString:name]) {
                            [arrayCon replaceObjectAtIndex:0 withObject:kE_GlobalZH(@"cancel_manager")];
                            [arrayCon replaceObjectAtIndex:2 withObject:kE_GlobalZH(@"complete_gag")];
                            break;
                        } else {
                            [arrayCon replaceObjectAtIndex:0 withObject:kE_GlobalZH(@"cancel_manager")];
                        }
                    }
                }
            }else{
                if (shutusers.count == 0) {
                  
                }else {
                    for (NSString *users in shutusers) {
                        if ([users isEqualToString:name]) {
                            [arrayCon replaceObjectAtIndex:0 withObject:kE_GlobalZH(@"cancel_manager")];
                            [arrayCon replaceObjectAtIndex:2 withObject:kE_GlobalZH(@"complete_gag")];
                            break;
                        } else {
                           [arrayCon replaceObjectAtIndex:0 withObject:kE_GlobalZH(@"cancel_manager")];
                        }
                    }
                }
            }
        }
    }
    return arrayCon;
}





- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc]init];
        
    }
    return _baseToolManager;
}
- (void)dealloc
{
    _baseToolManager = nil;
    
}
@end
