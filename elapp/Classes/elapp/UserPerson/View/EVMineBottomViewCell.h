//
//  EVMineBottomViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVUserModel.h"

@interface EVMineBottomViewCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *topImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UIButton *readBtn;

@property (nonatomic, strong) EVUserModel *userModel;

@property (nonatomic, copy) NSString *ecoin;//火眼豆

@property (nonatomic, assign) NSUInteger unreadCount;

@property (nonatomic, strong) UIView * separateLineView;
@property (nonatomic, assign) BOOL isSession;
@end
