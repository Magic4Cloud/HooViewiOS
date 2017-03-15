//
//  EVUserSettingModel.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/27.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMineHeader.h"

@interface EVUserSettingModel : NSObject

@property (nonatomic, copy) NSString *nameLabel;

@property (nonatomic, assign) EVSettingCellType cellType;

@end


