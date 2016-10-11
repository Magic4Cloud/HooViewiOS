//
//  EVDanmuManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVDanmuModel.h"

@protocol EVDanmuDelegate <NSObject>

- (void)presentViewShowFloatingView:(EVDanmuModel *)model;

@end

@interface EVDanmuManager : UIView
@property (nonatomic, weak) id <EVDanmuDelegate> delegate;

- (void)receiveDanmu:(EVDanmuModel *)danmuModel;
@end
