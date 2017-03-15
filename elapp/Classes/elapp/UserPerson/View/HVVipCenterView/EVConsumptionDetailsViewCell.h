//
//  EVConsumptionDetailsViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/25.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVConsumptionModel.h"
#import "EVConsumptionDetailsController.h"

@interface EVConsumptionDetailsViewCell : UITableViewCell

@property (nonatomic, strong) EVRecordlistItemModel *listItemModel;

@property (nonatomic, assign) EVDetailType type;

@end
