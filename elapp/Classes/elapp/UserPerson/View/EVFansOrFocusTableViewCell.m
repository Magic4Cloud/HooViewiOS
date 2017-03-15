//
//  EVFansOrFocusTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFansOrFocusTableViewCell.h"
#import "UIButton+Extension.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVFanOrFollowerModel.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

@interface EVFansOrFocusTableViewCell ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIButton *changeState;
@property (strong, nonatomic) EVBaseToolManager *engine;


@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@end

@implementation EVFansOrFocusTableViewCell

#pragma mark - life circle

- (void)awakeFromNib
{
    [self handleButtonstyle:_avatar];
//    [_changeState setBackgroundImage:[UIImage imageNamed:@"home_person_icon_add"] forState:UIControlStateNormal];
//    [self addVipImageView];
    self.changeState.layer.cornerRadius = 12.5;
    self.changeState.layer.masksToBounds = YES;
    self.changeState.backgroundColor = [UIColor  evMainColor];
    
    
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
    }
}

#pragma mark - event response

- (IBAction)avatarClick:(UIButton *)sender
{
//    if (self.iconClick)
//    {
//        self.iconClick(self.model);
//    }
}

- (IBAction)changeState:(UIButton *)sender
{
    if (self.iconClick)
    {
        self.iconClick(self.model);
    }
    __weak typeof(self) weakself = self;
    [self.engine GETFollowUserWithName:self.model.name followType:!self.model.followed start:nil fail:^(NSError *error) {
        
    } success:^{
        weakself.model.followed = !weakself.model.followed;
        self.changeState.selected = weakself.model.followed;
        [EVProgressHUD showSuccess:@"已取消关注"];
    } essionExpire:^{
        
    }];
//    if (self.model.followed)
//    {
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:kE_GlobalZH(@"provoke_unhappy_cancel_follow") delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:kOK otherButtonTitles:nil, nil];
//        [sheet showInView:self.superview];
//    }
//    else
//    {
//        __weak typeof(self) weakself = self;
//        [self.engine GETFollowUserWithName:self.model.name followType:!self.model.followed start:nil fail:^(NSError *error) {
//        } success:^{
//            weakself.model.followed = !weakself.model.followed;
//            self.changeState.selected = weakself.model.followed;
//        } essionExpire:^{
//            
//        }];
//    }
}

#pragma mark - private methods

- (void)handleButtonstyle:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.bounds.size.width / 2.0f;
    btn.layer.masksToBounds = YES;
}

- (void)addVipImageView
{
    UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_ medium_vip"]];
    [self.contentView addSubview:vipImageView];
    self.vipImageView = vipImageView;
    self.vipImageView.hidden = YES;
    
    self.vipImageView.center = CGPointMake(CGRectGetMaxX(self.avatar.frame) - CGRectGetWidth(self.avatar.frame) / 8, CGRectGetMaxY(self.avatar.frame) - CGRectGetWidth(self.avatar.frame) / 8);
}


#pragma mark - setter and getter

- (void)setModel:(EVFanOrFollowerModel *)model{
        _model = model;
        [self.avatar cc_setBackgroundImageURL:self.model.logourl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:kUserLogoPlaceHolder]];
    
        self.vipImageView.hidden = !self.model.vip;
    
        if ( ![self.model.remarks isEqualToString:@""] && self.model.remarks )
        {
            self.name.text = self.model.remarks;
        }
        else
        {
            self.name.text = self.model.nickname;
        }
        self.introduction.text = self.model.signature && ![self.model.signature isEqualToString:@""] ? self.model.signature : kDefaultSignature_other;
        self.changeState.hidden =    self.type == FOCUSES ? NO : YES;
    
    
}

- (EVBaseToolManager *)engine
{
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
