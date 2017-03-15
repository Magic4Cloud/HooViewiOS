//
//  EVHVMessageCellModel.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessage.h"


#define ChatMargin 10       //间隔
#define ChatContentFont [UIFont systemFontOfSize:16]//内容字体

@interface EVHVMessageCellModel : NSObject

@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign, readonly) CGRect tipLabelF;

@property (nonatomic, strong) EVMessage *message;

@end
