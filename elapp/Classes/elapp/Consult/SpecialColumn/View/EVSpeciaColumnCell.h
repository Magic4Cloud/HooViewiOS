//
//  EVSpeciaColumnCell.h
//  elapp
//
//  Created by 周恒 on 2017/4/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUserModel.h"
#import "EVBaseNewsModel.h"

@interface EVSpeciaColumnCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsCoverImage;
@property (weak, nonatomic) IBOutlet UIImageView *authHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *authNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageWidth;


@property (nonatomic, strong) EVUserModel *userModel;
@property (nonatomic, strong) EVBaseNewsModel *columnNewsModel;


@end
