//
//  EVSpeciaColumnModel.h
//  elapp
//
//  Created by 周恒 on 2017/4/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVUserModel.h"


@interface EVSpeciaColumnModel : NSObject
@property (nonatomic, copy)NSString * id;
@property (nonatomic, copy)NSString * cover;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * introduce;
@property (nonatomic, strong)EVUserModel *usermodel;
@end
