//
//  EVStockTopView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVStockBaseModel.h"

@protocol EVStockTopViewDelegate <NSObject>

- (void)didSelectItemBaseModel:(EVStockBaseModel *)stockModel;

@end

@interface EVStockTopView : UIView

@property (nonatomic, weak) id <EVStockTopViewDelegate> delegate;

- (void)updateStockData:(NSMutableArray *)data;
@end
