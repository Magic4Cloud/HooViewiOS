//
//  EVNewsListViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVBaseNewsModel.h"
#import "EVHVEyesModel.h"
#import "EVLineTableViewCell.h"
@class EVNewsModel;

@interface EVNewsListViewCell : EVLineTableViewCell

/**
 首页新闻
 */
@property (nonatomic, strong) EVNewsModel *consultNewsModel;

/**
 搜索结果
 */
@property (nonatomic, strong) EVBaseNewsModel *searchNewsModel;

/**
 火眼金睛
 */
@property (nonatomic, strong) EVHVEyesModel *eyesModel;

/**
 我的收藏
 */
@property (nonatomic, strong) EVBaseNewsModel *collectNewsModel;

@property (weak, nonatomic) IBOutlet UIImageView *newsBackImage;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsReadLabel;

@end
