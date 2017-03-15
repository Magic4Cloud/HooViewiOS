//
//  EVStockCollectionViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVStockBaseModel.h"

@interface EVStockCollectionViewCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;

- (void)updateCellItems:(NSInteger)items;
@end
