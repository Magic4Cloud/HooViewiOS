//
//  EVHVEyesViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"
#import "EVHVEyesModel.h"

/**
 火眼金睛
 */
@interface EVHVEyesViewController : EVViewController

@property (nonatomic, copy) NSString *eyesID;

@property (nonatomic, strong) EVHVEyesModel *eyesModel;

@property (nonatomic, strong) NSMutableArray *eyesArray;

@end
