//
//  EVMineBackgroundView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVMineHeader.h"
#import "EVLoginInfo.h"
#import "EVUserModel.h"
#import "EVUserAsset.h"

@class EVMineTopViewCell;

@protocol EVMineBackgroundViewDelegate <NSObject>

- (void)didButtonClickType:(UIMineClickButtonType)type;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface EVMineBackgroundView : UIView

@property (nonatomic, weak) UITableView *mineTableView;


@property (nonatomic, copy) NSString *ecoin;//火眼豆

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, strong) EVUserAsset *userAsset;

@property (nonatomic, assign) BOOL isSession;

@property (nonatomic, weak) id <EVMineBackgroundViewDelegate >delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)updateTableViewDatasource;

@end
