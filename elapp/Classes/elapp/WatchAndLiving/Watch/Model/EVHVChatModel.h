//
//  EVHVChatModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessage.h"

@interface EVHVChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)addSpecifiedItem:(NSDictionary *)dic messageFrom:(EVMessageFrom)messageFrom isHistory:(BOOL)isHistory;
@end
