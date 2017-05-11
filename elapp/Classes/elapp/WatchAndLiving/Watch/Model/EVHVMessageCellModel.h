//
//  EVHVMessageCellModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessage.h"
#import "EVEaseMessageModel.h"//为了用枚举

#define ChatMargin 10       //间隔
#define ChatContentFont [UIFont systemFontOfSize:16]//内容字体

@interface EVHVMessageCellModel : NSObject
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign, readonly) CGRect tipLabelF;
@property (nonatomic, assign, readonly) CGRect avatarRect;
@property (nonatomic, copy) NSString * avatarURLPath;
@property (nonatomic, assign) EVEaseMessageTypeState state;
@property (nonatomic, strong) EVMessage *message;
@property (nonatomic, copy) NSString * vip;

@property (nonatomic, copy) NSString * userid;

- (void)initMessage:(EVMessage *)message andDic:(NSDictionary *)dic;
@end
