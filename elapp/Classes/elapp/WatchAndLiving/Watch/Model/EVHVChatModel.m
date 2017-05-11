//
//  EVHVChatModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVChatModel.h"
#import "EVHVMessageCellModel.h"

@implementation EVHVChatModel

- (void)addSpecifiedItem:(NSDictionary *)dic messageFrom:(EVMessageFrom)messageFrom isHistory:(BOOL)isHistory
{
    EVHVMessageCellModel *cellModel = [[EVHVMessageCellModel alloc] init];
    EVMessage *message = [[EVMessage alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict setValue:@(messageFrom) forKey:@"from"];
    [message setWithDict:dict];
//    [cellModel setMessage:message];
    [cellModel initMessage:message andDic:dic];
  
    
    if (isHistory) {
        [self.dataSource insertObject:cellModel atIndex:0];
    }else {
        [self.dataSource addObject:cellModel];
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
