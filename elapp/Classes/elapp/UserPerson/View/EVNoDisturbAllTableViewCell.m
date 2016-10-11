//
//  EVNoDisturbAllTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNoDisturbAllTableViewCell.h"

@interface EVNoDisturbAllTableViewCell ()

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@end

@implementation EVNoDisturbAllTableViewCell

#pragma mark - life circle

- (void)awakeFromNib {
//    self.mySwitch.on = ![CCBaseTool pushNotificationIsOff];
    self.mySwitch.onTintColor = [CCAppSetting shareInstance].appMainColor;
}


#pragma mark - event response

- (IBAction)switchHandle:(UISwitch *)sender {
    if (self.switchHandle) {
        self.switchHandle(sender.on);
    }
}


#pragma mark - getters and setters

- (void)setLive:(BOOL)live
{
    _live = live;
    
    self.mySwitch.on = live;
}

@end
