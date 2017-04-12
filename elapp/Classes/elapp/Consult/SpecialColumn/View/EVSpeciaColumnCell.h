//
//  EVSpeciaColumnCell.h
//  elapp
//
//  Created by 周恒 on 2017/4/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVSpeciaColumnModel.h"
typedef void(^CollectionSeletedBlock)(EVSpeciaAuthor *userInfo);

@interface EVSpeciaColumnCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsCoverImage;
@property (weak, nonatomic) IBOutlet UIImageView *authHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *authNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageWidth;

@property (weak, nonatomic) IBOutlet UIButton *toUserButton;

@property (nonatomic, strong) EVSpeciaColumnModel *columnModel;

@property (nonatomic, copy) CollectionSeletedBlock collectionSeletedBlock;



@end
