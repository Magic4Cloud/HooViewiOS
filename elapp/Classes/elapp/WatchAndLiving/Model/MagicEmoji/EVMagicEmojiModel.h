//
//  EVMagicEmojiModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

@interface EVMagicEmojiModel : CCBaseObject

/** id */
@property (nonatomic, copy) NSString *Id;

/** 图片地址 */
@property (nonatomic, copy) NSString *pic;

/** 动画需要的图片数组 */
@property (nonatomic, strong) NSArray *ani;

/** 礼物名称 */
@property (nonatomic, copy) NSString *name;

/** 赠送者昵称 */
@property (nonatomic, copy) NSString *nickName;

/** 礼物类型，0表示表情，1表示薏米，2表示礼物 */
@property (nonatomic, assign) NSInteger type;

/** 赠送礼物个数 */
@property (nonatomic, assign) NSInteger number;

/** 单价 */
@property (nonatomic, assign) NSInteger cost;

/** 消费类型，0表示薏米，1表示云币 */
@property (nonatomic, assign) NSInteger costtype;

/** 消费类型的字符串 */
@property (nonatomic, copy) NSString *costTypeStr;

/** 是否被选中 */
@property (nonatomic, assign) BOOL selected;

@end
