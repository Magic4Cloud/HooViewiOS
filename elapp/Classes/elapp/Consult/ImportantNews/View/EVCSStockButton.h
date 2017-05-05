//
//  EVCSStockButton.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVStockBaseModel.h"

@interface EVCSStockButton : UIButton

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *upLabel;
@property (nonatomic, weak) UILabel *lineLabel;
@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;

@end
