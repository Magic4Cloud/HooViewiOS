//
//  EVSpeciaColumnCell.m
//  elapp
//
//  Created by 周恒 on 2017/4/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSpeciaColumnCell.h"

@implementation EVSpeciaColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _newsCoverImage.backgroundColor = [UIColor grayColor];
    
    
    if (ScreenWidth == 320) {
        _authHeaderImage.layer.cornerRadius = 12.5;
    } else {
        _authHeaderImage.layer.cornerRadius = 15;
    }
    _authHeaderImage.layer.masksToBounds = YES;
    _authHeaderImage.backgroundColor = [UIColor brownColor];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    
    
}

- (void)setUserModel:(EVUserModel *)userModel {
    _userModel = userModel;
    if (!userModel) {
        return;
    }
    _authNameLabel.text  = userModel.nickname;
    _authIntroduceLabel.text  = userModel.signature;
//    [_authHeaderImage cc_setImageWithURLString:userModel.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
}

- (void)setTitleWidth:(NSLayoutConstraint *)titleWidth {
    if (ScreenWidth == 320) {
        titleWidth.constant = 120.f;
    } else {
        titleWidth.constant = 147.f;
    }
}

- (void)setHeaderImageWidth:(NSLayoutConstraint *)headerImageWidth {
    if (ScreenWidth == 320) {
        headerImageWidth.constant = 25.f;
    } else {
        headerImageWidth.constant = 30.f;
    }

}



@end
