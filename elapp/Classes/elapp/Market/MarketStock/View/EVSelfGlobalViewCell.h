//
//  EVSelfGlobalViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVStockBaseModel.h"


@interface EVSelfGlobalViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL status;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIView *hvContentView;


@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;
@end
