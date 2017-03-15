//
//  EVRedEnvelopeModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

typedef NS_ENUM(NSInteger, CCRedEnvelopeType)
{
    CCRedEnvelopeTypeSystem,    // 系统发的红包
    CCRedEnvelopeTypeAudience,  // 观看者发的红包
    CCRedEnvelopeTypeAnchor,     // 主播发的红包
};

@interface EVRedEnvelopeItemModel : EVBaseObject

@property (nonatomic,copy) NSString *hid;   // 红包编号（字符串）

/** 红包名称，如果是非系统红包，显示祝福语 */
@property (nonatomic,copy) NSString *hnm;   // 红包名称（字符串）
@property (nonatomic,copy) NSString *hlg;   // 红包logo（字符串）
@property ( nonatomic ) CCRedEnvelopeType htp;    // 红包类型
@property (nonatomic,assign) int htm;       // 红包持续时间(数字 范围秒)
@property (nonatomic,assign) int open;      // 红包触发标志（数字，1-发红包，0-拆过红包的人）
@property (nonatomic,copy) NSString *name;   // 领红包者云播号 （字符串）

/** 领红包、发红包者昵称 （字符串） */
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *ulg;   //领红包者头像 (字符串) 一个完整的用户图标应该由用户图标前缀，加上对应后缀组成
@property (nonatomic, copy) NSString *ecoin;        // 所领取的金额（数字 单位火眼豆）
@property (nonatomic, copy) NSString *isbest;        // 最佳标志(数字 1-最佳)

@property (nonatomic,copy) NSString *logoUrl;


@end


@interface EVRedEnvelopeModel : EVBaseObject

@property (nonatomic,copy) NSArray *htb;


@property (nonatomic, copy) NSString *ecoin;

@property (nonatomic, copy) NSString *isbest;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *nickname;

@end
