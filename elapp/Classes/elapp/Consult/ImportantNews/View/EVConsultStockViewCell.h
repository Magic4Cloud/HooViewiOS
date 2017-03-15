//
//  EVConsultStockViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EVCSStockButton;
typedef void(^scStockBlock)(EVCSStockButton *csBtn);

@interface EVConsultStockViewCell : UITableViewCell

@property (nonatomic, copy) scStockBlock scStock;

@property (nonatomic, strong) NSArray *stockDataArray;

@end
