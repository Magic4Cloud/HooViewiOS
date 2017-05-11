//
//  EVRelatedNewsCell.h
//  elapp
//
//  Created by 周恒 on 2017/5/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNewsModel.h"

@interface EVRelatedNewsCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) EVNewsModel *newsModel;


@end
