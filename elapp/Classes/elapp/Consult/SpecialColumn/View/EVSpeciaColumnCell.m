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
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = _newsCoverImage.bounds;
    effectView.alpha = 10.3f;
    [_newsCoverImage addSubview:effectView];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    
    
}


- (void)setColumnModel:(EVSpeciaColumnModel *)columnModel {
    _columnModel = columnModel;
    if (!columnModel) {
        return;
    }
    _newsTitleLabel.text = columnModel.title;
    _newsContentLabel.text = columnModel.introduce;
    [_newsCoverImage cc_setImageWithURLString:columnModel.cover placeholderImage:nil];
    
    _authNameLabel.text = columnModel.author.nickname;
    [_authHeaderImage cc_setImageWithURLString:columnModel.author.avatar placeholderImage:nil];
    _authIntroduceLabel.text = columnModel.author.introduce;
    
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


- (IBAction)toUser:(id)sender {
    EVSpeciaAuthor *userInfo = self.columnModel.author;
    if (self.collectionSeletedBlock) {
        self.collectionSeletedBlock(userInfo);
    }
}

@end
