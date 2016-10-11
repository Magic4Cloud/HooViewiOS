//
//  EVInterestingGuyTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVInterestingGuyTableViewCell.h"
#import "EVFanOrFollowerModel.h"
#import "EVBaseToolManager+EVGroupAPI.h"
#import "EVHeaderView.h"
#import "EVLoginInfo.h"
#import "EVNickNameAndLevelView.h"
#import <PureLayout.h>

#define CCInterestingGuyTableViewCellID @"CCInterestingGuyTableViewCellID"

@interface EVInterestingGuyTableViewCell ()<UIActionSheetDelegate>

@property (weak, nonatomic) EVHeaderButton *avatar;
@property (weak, nonatomic) UILabel *nickNameLabel;
@property (weak, nonatomic) UILabel *introduction;
@property (strong, nonatomic) EVBaseToolManager  *engine;
@property ( weak, nonatomic ) EVNickNameAndLevelView *levelView;

@end

@implementation EVInterestingGuyTableViewCell

#pragma mark - class methods

+ (NSString *)cellID
{
    return CCInterestingGuyTableViewCellID;
}


#pragma mark - life circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        __weak typeof(self) weakself = self;
        [self.engine GETFollowUserWithName:self.model.name followType:!self.model.followed start:nil fail:^(NSError *error) {
            
        } success:^{
            weakself.model.followed = !weakself.model.followed;
            self.changeStateBtn.selected = weakself.model.followed;
        } essionExpire:^{
            
        }];
    }
}


#pragma mark - event response
- (void)avatarClick:(UIButton *)sender
{
    if (self.avatarClickBlock)
    {
        self.avatarClickBlock(self.model);
    }
}

- (void)changeState:(UIButton *)sender
{
    if (self.model.followed)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"阿奥，他（她）惹你不高兴了吗，确定取消关注吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [sheet showInView:self.superview];
    }
    else
    {
        __weak typeof(self) weakself = self;
        [self.engine GETFollowUserWithName:self.model.name followType:!self.model.followed start:nil fail:^(NSError *error) {
        } success:^{
            weakself.model.followed = !weakself.model.followed;
            self.changeStateBtn.selected = weakself.model.followed;
        } essionExpire:^{
            
        }];
    }
}

#pragma mark - private methods

- (void)setUpUI
{
    EVHeaderButton * avatar = [[EVHeaderButton alloc] init];
    [avatar addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:avatar];
    [avatar autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [avatar autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [avatar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    self.avatar = avatar;
    
    UILabel * nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textColor = [UIColor colorWithHexString:@"#403B37"];
    nickNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nickNameLabel];
    [nickNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatar withOffset:15];
    [nickNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:avatar withOffset:-3];
    self.nickNameLabel = nickNameLabel;
    
    EVNickNameAndLevelView * levelView = [[EVNickNameAndLevelView alloc] init];
    [self.contentView addSubview:levelView];
    [levelView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel withOffset:-3];
    [levelView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:avatar withOffset:2];
    self.levelView = levelView;
    
    UILabel * introduction = [[UILabel alloc] init];
    introduction.textColor = [UIColor colorWithHexString:@"#403B37" alpha:0.5];
    introduction.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:introduction];
    [introduction autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:avatar withOffset:3];
    [introduction autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    self.introduction = introduction;
    
    UIButton * changeStateBtn = [[UIButton alloc] init];
    [changeStateBtn setBackgroundImage:[UIImage imageNamed:@"personal_icon_add"] forState:UIControlStateNormal];
    [changeStateBtn setBackgroundImage:[UIImage imageNamed:@"personal_icon_already"] forState:UIControlStateSelected];
    [changeStateBtn addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:changeStateBtn];
    [changeStateBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [changeStateBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    self.changeStateBtn = changeStateBtn;

}

#pragma mark - getters and setters

- (void)setModel:(EVFanOrFollowerModel *)model
{
    _model = model;
    [self.avatar cc_setBackgroundImageURL:self.model.logourl placeholderImageStr:kUserLogoPlaceHolder isVip:model.vip vipSizeType:CCVipMiddle];
    [self.avatar cc_setBackgroundImageURL:self.model.logourl placeholderImageStr:kUserLogoPlaceHolder isVip:model.vip vipSizeType:CCVipMiddle];
    if ( ![_model.remarks isEqualToString:@""] && _model.remarks )
    {
        self.nickNameLabel.text = _model.remarks;
    }
    else
    {
        self.nickNameLabel.text = _model.nickname;
    }
    
    if (_model.faned) {
        [self.changeStateBtn setBackgroundImage:[UIImage imageNamed:@"personal_icon_mutual"] forState:UIControlStateSelected];
    } else {
        [self.changeStateBtn setBackgroundImage:[UIImage imageNamed:@"personal_icon_already"] forState:UIControlStateSelected];
    }
    
    self.introduction.text = _model.signature;
    if ([self.introduction.text isEqualToString:@""] || self.introduction.text == nil) {
        self.introduction.text = @"TA太忙了,忘了自我介绍了";
    }
    self.changeStateBtn.selected = _model.followed;
    self.levelView.gender = model.gender;
    if ([EVLoginInfo checkCurrUserByName:_model.name])
    {
        self.changeStateBtn.hidden = YES;
    } else {
        self.changeStateBtn.hidden = NO;
    }
}

- (EVBaseToolManager  *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
