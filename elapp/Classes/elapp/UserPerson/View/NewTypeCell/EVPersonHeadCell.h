//
//  EVPersonHeadCell.h
//  elapp
//
//  Created by 唐超 on 4/17/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVUserModel;
#import  <TTTAttributedLabel.h>
/**
 个人中心  头像cell
 */
@interface EVPersonHeadCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellIntroduceLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *cellFollowAndFansLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellAvatarImageView;

@property (nonatomic, strong) EVUserModel * userModel;
@property (weak, nonatomic) IBOutlet UIImageView *cellVipImageView;
@property (nonatomic, copy) void(^fansAndFollowClickBlock)(controllerType type);
@end
