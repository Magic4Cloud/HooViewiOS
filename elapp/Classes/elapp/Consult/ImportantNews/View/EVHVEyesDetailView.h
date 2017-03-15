//
//  EVHVEyesDetailView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVHVEyesModel.h"
#import "EVBaseToolManager+EVNewsAPI.h"


typedef void(^eyesDetailBlock)(EVHVEyesModel *eyesModel);

@interface EVHVEyesDetailView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *eyesID;

@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) EVHVEyesModel *eyesModel;

@property (nonatomic, strong) eyesDetailBlock eyesBlock;

- (instancetype)initWithFrame:(CGRect)frame model:(EVHVEyesModel *)model;
@end
