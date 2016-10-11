//
//  EVStartGoodModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

typedef NS_ENUM(NSInteger, CCPresentAniType)
{
    CCPresentAniTypeNone,
    CCPresentAniTypeStaticImage,
    CCPresentAniTypeGif,
    CCPresentAniTypeZip,
    CCPresentAniTypeRedPacket
};

@interface EVStartGoodModel : CCBaseObject

/** id */
@property (nonatomic, assign) NSInteger ID;

/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 图片 */
@property (nonatomic, copy) NSString *pic;

/** 动画图片 */
@property (nonatomic, copy) NSString *ani;

/** 动画类型 */
@property (nonatomic, assign) CCPresentAniType anitype;

/** 价格 */
@property (nonatomic, assign) NSInteger cost;

/** 经验值 */
@property (nonatomic, assign) NSInteger exp;

/** 消费类型 */
@property (nonatomic, assign) NSInteger costtype;

/** 标记消费类型的图片 */
@property (nonatomic, strong) UIImage *costImage;

/** 礼物类型 */
@property (nonatomic, assign) CCPresentType type;

/********* 附加属性  **********/
/** 选中个数 */
@property (nonatomic, assign) NSInteger selectNum;

/** 是否选中 */
@property (nonatomic, assign) BOOL selected;

+ (EVStartGoodModel *)modelWithDict:(NSDictionary *)dict;
@end
