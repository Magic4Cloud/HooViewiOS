//
//  EVHVVipCenterView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/8.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVVipCenterView.h"
#import "EVUserTagsView.h"
#import "EVUserTagsModel.h"
#import "EVLoginInfo.h"
@interface EVHVVipCenterView ()
@property (nonatomic, weak) UIImageView *topBackImageView;



@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) EVUserTagsView *userTagsView;

@property (nonatomic, weak) UILabel *numberLabel;

@property (nonatomic, weak) UILabel *introLabel;
@end

@implementation EVHVVipCenterView

- (instancetype)initWithFrame:(CGRect)frame isTextLive:(BOOL)istextlive
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
        if (istextlive) {
             [self textLiveHeadView];
        }else {
            [self addUserHeadView];
        }
       
    }
    return self;
}


- (void)addUpView
{
    UIImageView *topBackImageView = [[UIImageView alloc] init];
    [self addSubview:topBackImageView];
    self.topBackImageView = topBackImageView;
    topBackImageView.image = [UIImage imageNamed:@"Account_bitmap_user"];
    topBackImageView.frame = CGRectMake(0, 0,ScreenWidth, 216);
    topBackImageView.contentMode = UIViewContentModeScaleToFill;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = self.topBackImageView.bounds;
    effectView.alpha = .8f;
    [self.topBackImageView addSubview:effectView];
    
    
    UIView *userInfoView = [[UIView alloc] init];
    [self addSubview:userInfoView];
    userInfoView.backgroundColor = [UIColor whiteColor];
    userInfoView.frame = CGRectMake(0, 104, ScreenWidth, 126);
    
    UIButton *backButton = [[UIButton alloc] init];
    [self addSubview:backButton];
    backButton.frame = CGRectMake(11, 30, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"btn_return_watch_n"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *reportButton = [[UIButton alloc] init];
    [self addSubview:reportButton];
    self.reportBtn = reportButton;
    [reportButton setImage:[UIImage imageNamed:@"btn_report_n"] forState:(UIControlStateNormal)];
    [reportButton addTarget:self action:@selector(reportButton) forControlEvents:(UIControlEventTouchUpInside)];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
    [reportButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [reportButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    UIImageView *userHeadIgeView = [[UIImageView alloc] init];
    [self addSubview:userHeadIgeView];
    self.userHeadIgeView = userHeadIgeView;
    [userHeadIgeView autoSetDimensionsToSize:CGSizeMake(60, 60)];
    [userHeadIgeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:58];
    [userHeadIgeView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    userHeadIgeView.layer.masksToBounds = YES;
    userHeadIgeView.layer.cornerRadius = 30;
    
    userHeadIgeView.image = [UIImage imageNamed:@"Account_bitmap_user"];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:18.f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor evTextColorH1];
    nameLabel.text = @"";
    [nameLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 25)];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userHeadIgeView withOffset:5];
    [nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];

    [_topBackImageView cc_setImageWithURLString:self.watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [_userHeadIgeView cc_setImageWithURLString:self.watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [_nameLabel setText:self.watchVideoInfo.nickname];

    
   

}

- (void)textLiveHeadView
{
    UILabel *introLabel = [[UILabel alloc] init];
    [self addSubview:introLabel];
    introLabel.textColor = [UIColor evTextColorH1];
    introLabel.font = [UIFont textFontB3];
    self.introLabel = introLabel;
    introLabel.textAlignment = NSTextAlignmentCenter;
    [introLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel];
    [introLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [introLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [introLabel autoSetDimension:ALDimensionHeight toSize:20];
    
    
    
    EVUserTagsView *userTagsView = [[EVUserTagsView alloc] initWithCenterFrame:CGRectZero];
    [self addSubview:userTagsView];
    self.userTagsView = userTagsView;
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [userTagsView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.introLabel withOffset:12];
    [userTagsView autoSetDimension:ALDimensionHeight toSize:20];
//    NSArray *tagsArray = @[@"哈哈哈",@"呵呵哒"];
//    userTagsView.dataArray = [NSMutableArray arrayWithArray:tagsArray];
}

- (void)addUserHeadView
{
    UILabel *introLabel = [[UILabel alloc] init];
    [self addSubview:introLabel];
    introLabel.textColor = [UIColor evTextColorH2];
    introLabel.font = [UIFont textFontB3];
    introLabel.textAlignment = NSTextAlignmentCenter;
    self.introLabel = introLabel;
//    introLabel.text = @"21233231";
    [introLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel];
    [introLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [introLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [introLabel autoSetDimension:ALDimensionHeight toSize:20];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    [self addSubview:numberLabel];
    self.numberLabel = numberLabel;
    numberLabel.font = [UIFont textFontB2];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor evTextColorH2];
    [numberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.introLabel];
    [numberLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [numberLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [numberLabel autoSetDimension:ALDimensionHeight toSize:22];
//    self.numberLabel.text = @"A1140611030006";
    
    EVUserTagsView *userTagsView = [[EVUserTagsView alloc] initWithCenterFrame:CGRectZero];
    [self addSubview:userTagsView];
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [userTagsView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.numberLabel withOffset:8];
    [userTagsView autoSetDimension:ALDimensionHeight toSize:20];
//    NSArray *tagsArray = @[@"哈哈哈",@"呵呵哒"];
//    userTagsView.dataArray = [NSMutableArray arrayWithArray:tagsArray];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    
    [_topBackImageView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [_userHeadIgeView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [self.introLabel setText:watchVideoInfo.signature];
    [_nameLabel setText:watchVideoInfo.nickname];
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in watchVideoInfo.tags) {
        [titleAry addObject:model.tagname];
    }
    self.userTagsView.dataArray = titleAry.mutableCopy;
}

- (void)setUserModel:(EVUserModel *)userModel
{
    [_topBackImageView cc_setImageWithURLString:userModel.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [_userHeadIgeView cc_setImageWithURLString:userModel.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    [_nameLabel setText:userModel.nickname];
    [_introLabel setText:userModel.signature];
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in userModel.tags) {
        [titleAry addObject:model.tagname];
    }
    self.userTagsView.dataArray = titleAry.mutableCopy;
   
}
- (void)backButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButton)]) {
        [self.delegate backButton];
    }
}

- (void)reportButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportButton)]) {
        [self.delegate reportButton];
    }
}
@end
