//
//  EVConsumptionModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVRecordlistItemModel : EVBaseObject

//消费时间
@property (nonatomic, copy) NSString *time;
//消费薏米数
@property (nonatomic, assign) NSInteger barley;
//购买的物品id号
@property (nonatomic, assign) NSInteger goodsid;
//获取的金额
@property (nonatomic, assign) NSInteger rmb;
//花费的云票数
@property (nonatomic,assign) NSInteger riceroll;

//获取的火眼豆数
@property (nonatomic,assign) NSInteger ecoin;
//花费描述
@property (nonatomic,copy) NSString *descriptionss;
//礼物名称
@property (nonatomic,copy) NSString *goodsname;
//礼物类型
@property (nonatomic,assign) NSInteger goodstype;

@property (nonatomic,assign) NSInteger  client_ip;

@property (nonatomic,copy) NSString  *commit_time;

@property (nonatomic,copy) NSString *complete_time;

@property (nonatomic,copy) NSString *openid;

@property (nonatomic,copy) NSString  *orderid;

@property (nonatomic,assign)NSInteger platform;

@property (nonatomic,assign) NSInteger server_ip;

@property (nonatomic,assign) NSInteger status;



@end

@interface CCConsumptionModel : EVBaseObject

@property (nonatomic, copy) NSArray *recordlist;

@end
