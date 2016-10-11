//
//  EVBaseToolManager+EVStartAppAPI.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseToolManager.h"

@interface EVBaseToolManager (EVStartAppAPI)


//分类接口
- (NSString *)GETNewtopicWithStart:(void(^)())startBlock
                              fail:(void(^)(NSError *error))failBlock
                           success:(void(^)(NSDictionary *info))successBlock
                    sessionExpired:(void(^)())sessionExpiredBlock;


//礼物列表
- (NSString *)GETGoodsListWithStart:(void(^)())startBlock
                               fail:(void(^)(NSError *error))failBlock
                            success:(void(^)(NSDictionary *info))successBlock
                     sessionExpired:(void(^)())sessionExpiredBlock;
/**
 *  @author shizhiang, 15-10-21 14:10:13
 *
 *  获取开机启动时需要的资源
 *
 *  @param devtype            设备类型
 *  @param startBlock         开始请求的block
 *  @param failBlock          失败的回调
 *  @param successBlock       成功的回调
 *
 *  @return
 */
- (void)GETParamsWithDevType:(NSString *)devtype
                  startBlock:(void(^)())startBlock
                        fail:(void(^)(NSError *error))failBlock
                     success:(void(^)(NSDictionary *dict))successBlock;



@end
