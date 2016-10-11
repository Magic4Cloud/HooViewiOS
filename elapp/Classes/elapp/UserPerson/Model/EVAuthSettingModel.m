//
//  EVAuthSettingModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAuthSettingModel.h"

@implementation EVAuthSettingModel

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.isOn = 2;
    }
    return self;
}

- (void)setFollow:(BOOL)follow
{
    _follow = follow;
    self.isOn = follow;
}

- (void)setDisturb:(BOOL)disturb
{
    _disturb = disturb;
    self.isOn = _disturb;
}

- (void)setPersonalMsgOpen:(BOOL)personalMsgOpen
{
    _personalMsgOpen = personalMsgOpen;
    self.isOn = _personalMsgOpen;
}

- (void)setLive:(BOOL)live
{
    _live = live;
    if ( _live )
    {
        self.isOn = 1;
    }
    else
    {
        self.isOn = 2;
    }
}

- (void)setWrong:(BOOL)wrong
{
    _wrong = wrong;
    if ( YES == _wrong )
    {
        if ( [self.name isEqualToString:k_focusCellName] )
        {
            self.follow = !self.follow;
        }
        else if ( [self.name isEqualToString:k_liveCellName] )
        {
            self.live = !self.live;
        }
        else
        {
            self.disturb = !self.disturb;
        }
    }
}

- (void)updateDataWithDictionary:(NSDictionary *)dict
{
    if ( [self.name isEqualToString:k_focusCellName] )
    {
        self.follow = [dict[kFollow] boolValue];
    }
    else if ( [self.name isEqualToString:k_liveCellName] )
    {
        self.live = [dict[kLive] boolValue];
    }
    else if ([self.name isEqualToString:k_disturbCellName])
    {
        self.disturb = [dict[kDisturb] boolValue];
    }
}

+ (instancetype) modelWithName:(NSString *)name type:(EVAuthSettingModelType)type
{
    EVAuthSettingModel *model = [[EVAuthSettingModel alloc] init];
    model.name = name;
    model.type = type;
    return model;
}

@end
