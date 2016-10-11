//
//  EVBlackListItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import "EVBlackListItem.h"

@implementation EVBlackListItem
- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    self.logoUrl = userModel.logourl;
    self.name = userModel.name;
    self.nickName = userModel.nickname;
    self.imUser = userModel.imuser;
}

@end
