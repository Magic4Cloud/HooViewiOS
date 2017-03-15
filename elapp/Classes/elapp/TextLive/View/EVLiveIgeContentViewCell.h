//
//  EVLiveIgeContentViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEaseMessageModel.h"

@interface EVLiveIgeContentViewCell : UITableViewCell

@property (nonatomic, strong)  EVEaseMessageModel *easeMessageModel;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIImageView *leftCircleIgeView;

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UILabel *rpContentLabel;
@end
