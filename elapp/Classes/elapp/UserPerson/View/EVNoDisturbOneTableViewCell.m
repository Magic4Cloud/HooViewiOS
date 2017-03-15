//
//  EVNoDisturbOneTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNoDisturbOneTableViewCell.h"
#import "EVFanOrFollowerModel.h"
#import "EVHeaderView.h"

@interface EVNoDisturbOneTableViewCell ()

@property (weak, nonatomic) IBOutlet EVHeaderButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end

@implementation EVNoDisturbOneTableViewCell

#pragma mark - life circle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self handleButtonstyle:_avatar];
    self.switcher.onTintColor = [UIColor evMainColor];
}

#pragma mark - event response

- (IBAction)lookOverOnebodyProfile:(UIButton *)sender {
    if (self.lookOver) {
        self.lookOver();
    }
}

- (IBAction)switchHandle:(UISwitch *)sender {
    EVLog(@"swith:%d", sender.on);
    if (self.switchHandle) {
        self.switchHandle(sender.on, self);
    }
}

#pragma mark - private method

- (void)handleButtonstyle:(UIButton *)btn
{
//    btn.layer.cornerRadius = CGRectGetWidth(btn.bounds) / 2.0f;
//    btn.layer.masksToBounds = YES;
}

#pragma mark - getters and setters

- (void)setModel:(EVFanOrFollowerModel *)model {
//    if (_model != model) {
        _model = model;
        [self.avatar cc_setBackgroundImageURL:self.model.logourl placeholderImageStr:kUserLogoPlaceHolder isVip:model.vip vipSizeType:EVVipMini];
        
//        [self.avatar cc_setBackgroundImageURL:self.model.logourl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:kUserLogoPlaceHolder]];
        
        
        if ( ![_model.remarks isEqualToString:@""] && _model.remarks )
        {
            self.nickname.text = _model.remarks;
        }
        else
        {
            self.nickname.text = _model.nickname;
        }
        self.introduction.text = self.model.signature;
        self.switcher.on = self.model.subscribed;
//    }
//    if ([CCBaseTool pushNotificationIsOff]) {
//        self.switcher.enabled = NO;
//    } else {
//        self.switcher.enabled = YES;
//    }
    
}

- (void)setSwitchEnable:(BOOL)switchEnable
{
    _switchEnable = switchEnable;
    
    self.switcher.enabled = self.switchEnable;
}

@end
