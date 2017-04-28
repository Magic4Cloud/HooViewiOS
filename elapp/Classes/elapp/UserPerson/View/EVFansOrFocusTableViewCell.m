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
    [super awakeFromNib];
    [self handleButtonstyle:_avatar];
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
    
    __weak typeof(self) weakself = self;
    [self.engine GETFollowUserWithName:self.model.name followType:!self.model.followed start:nil fail:^(NSError *error) {
        [EVProgressHUD showSuccess:@"失败"];
    } success:^{
        weakself.model.followed = !weakself.model.followed;
        self.changeState.selected = weakself.model.followed;
        self.changeState.backgroundColor = weakself.model.followed ?[UIColor  evBackGroundDeepGrayColor]:[UIColor  evMainColor];
        [EVProgressHUD showSuccess:@"成功"];
        if (weakself.iconClick)
        {
            weakself.iconClick(weakself.model);
        }
    } essionExpire:^{
        [EVProgressHUD showSuccess:@"失败"];
    }];

}

#pragma mark - private methods

- (void)handleButtonstyle:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.bounds.size.width / 2.0f;
    btn.layer.masksToBounds = YES;
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
        self.changeState.selected = model.followed;
        self.changeState.backgroundColor = model.followed ?[UIColor  evBackGroundDeepGrayColor]:[UIColor  evMainColor];
    
    if ([model.name isEqualToString:[EVLoginInfo localObject].name]) {
        _changeState.hidden = YES;
    } else {
        _changeState.hidden = NO;
    }
}

- (EVBaseToolManager *)engine
{
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
