//
//  EVSelfStockViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"

typedef NS_ENUM(NSUInteger, EVSelfStockType) {
    EVSelfStockTypeAll = 0,     /**< 所有 */
    EVSelfStockTypeSZSH,        /**< 沪深 */
    EVSelfStockTypeHK,          /**< 香港 */
    EVSelfStockTypeUS,          /**< 美国 */
    EVSelfStockTypeIXIX,        /**< 全球 */
};

@protocol  EVSelfStockVCDelegate<NSObject>

- (void)addStockClick;
- (void)refreshWithType:(EVSelfStockType)type;

@end

/**
 自选子页面
 */
@interface EVSelfStockViewController : EVViewController

@property (nonatomic, weak) id<EVSelfStockVCDelegate> Sdelegate;
@property (nonatomic, weak) UITableView *listTableView;
@property (nonatomic, assign) EVSelfStockType stockType;

- (void)updateDataArray:(NSArray *)array;

@end
