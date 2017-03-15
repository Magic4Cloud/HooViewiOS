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


@interface EVNewsListViewCell : UITableViewCell

@property (nonatomic, strong) EVBaseNewsModel *consultNewsModel;

@property (nonatomic, strong) EVBaseNewsModel *searchNewsModel;

@property (nonatomic, strong) EVHVEyesModel *eyesModel;

@property (nonatomic, strong) EVBaseNewsModel *collectNewsModel;

@property (weak, nonatomic) IBOutlet UIImageView *newsBackImage;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsReadLabel;

@end
