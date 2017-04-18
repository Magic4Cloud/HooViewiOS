//
//  EVPersonHeadCell.m
//  elapp
//
//  Created by 唐超 on 4/17/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVPersonHeadCell.h"
#import "EVUserModel.h"

@implementation EVPersonHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellAvatarImageView.layer.cornerRadius = 30;
    _cellAvatarImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setUserModel:(EVUserModel *)userModel
{
    if (userModel)
    {
        _userModel = userModel;
        _cellNameLabel.text = userModel.nickname;
        _cellIntroduceLabel.text = userModel.signature;
        [_cellAvatarImageView cc_setImageWithURLString:userModel.logourl placeholderImage:nil];
        
        NSString * followString = [NSString stringWithFormat:@"%ld",(unsigned long)userModel.follow_count];
        NSString * fansString = [NSString stringWithFormat:@"%ld",(unsigned long)userModel.fans_count];
        NSString * newString = [NSString stringWithFormat:@"%@关注  %@粉丝",followString,fansString];
        NSMutableAttributedString * followAndFansString = [[NSMutableAttributedString alloc] initWithString:newString];
        [followAndFansString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:108/255.0 blue:36/255.0 alpha:1] range:NSMakeRange(0, followString.length)];
        
        [followAndFansString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:108/255.0 blue:36/255.0 alpha:1] range:NSMakeRange(followString.length+4, fansString.length)];
        
        _cellFollowAndFansLabel.attributedText = followAndFansString;
        
        if ([userModel.gender isEqualToString:@"male"]) {
            //男
            _cellSexImageView.image  = [UIImage imageNamed:@""];
        }
        else if ([userModel.gender isEqualToString:@"female"])
        {
            //女
            _cellSexImageView.image  = [UIImage imageNamed:@""];
        }
        else
        {
            //未知
            _cellSexImageView.image  = nil;
        }
        
    }
    else
    {
        _cellNameLabel.text = @"登陆/注册";
        _cellIntroduceLabel.text = @"点击登录 更多精彩";
        NSMutableAttributedString * followAndFansString = [[NSMutableAttributedString alloc] initWithString:@"0关注  0粉丝"];
        [followAndFansString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:108/255.0 blue:36/255.0 alpha:1] range:NSMakeRange(0, 1)];
        [followAndFansString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:108/255.0 blue:36/255.0 alpha:1] range:NSMakeRange(5, 1)];
        
        _cellFollowAndFansLabel.attributedText = followAndFansString;
        _cellSexImageView.image  = nil;
        _cellAvatarImageView.image = nil;
    }
}

@end
