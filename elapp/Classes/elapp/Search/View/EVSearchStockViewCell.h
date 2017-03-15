//
//  EVSearchStockViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVStockBaseModel.h"

@class EVSearchStockViewCell;
@protocol EVSearchStockDelegate <NSObject>

- (void)buttonClickCell:(EVSearchStockViewCell *)cell;

@end


@interface EVSearchStockViewCell : UITableViewCell

@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;

@property (nonatomic, weak) id<EVSearchStockDelegate> delegate;

- (void)changeButtonStatus;
@end
