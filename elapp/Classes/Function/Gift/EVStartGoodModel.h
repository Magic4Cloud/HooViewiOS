//
//  EVStartGoodModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

typedef NS_ENUM(NSInteger, EVPresentAniType)
{
    EVPresentAniTypeNone,
    EVPresentAniTypeStaticImage,
    EVPresentAniTypeGif,
    EVPresentAniTypeZip,
    EVPresentAniTypeRedPacket
};

@interface EVStartGoodModel : EVBaseObject

/** id */
@property (nonatomic, assign) NSInteger ID;

/** 名称 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *giftName;

/** 图片 */
@property (nonatomic, copy) NSString *pic;

/** 动画图片 */
@property (nonatomic, copy) NSString *ani;

/** 动画类型 */
@property (nonatomic, assign) EVPresentAniType anitype;

/** 价格 */
@property (nonatomic, assign) NSInteger cost;

/** 经验值 */
@property (nonatomic, assign) NSInteger exp;

/** 消费类型 */
@property (nonatomic, assign) NSInteger costtype;

/** 标记消费类型的图片 */
@property (nonatomic, strong) UIImage *costImage;

/** 礼物类型 */
@property (nonatomic, assign) EVPresentType type;

/** 选中个数 */
@property (nonatomic, assign) NSInteger selectNum;

/** 是否选中 */
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) NSString *colorStr;

@property (nonatomic, assign) long long timeLong;

+ (EVStartGoodModel *)modelWithDict:(NSDictionary *)dict;
@end
