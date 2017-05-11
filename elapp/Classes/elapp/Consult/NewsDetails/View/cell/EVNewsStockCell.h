//
//  EVNewsStockCell.h
//  elapp
//
//  Created by 周恒 on 2017/5/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNewsDetailModel.h"

@interface EVNewsStockCell : UITableViewCell
@property (nonatomic, strong) NSArray *stockModelArray;
@property (nonatomic, strong) EVStockModel *stockModel;
@end
