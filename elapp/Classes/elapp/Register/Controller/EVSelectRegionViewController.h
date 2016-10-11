//
//  EVSelectRegionViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
@class EVRegionCodeModel;

@protocol CCSelectRegionViewControllerDelegate <NSObject>

//地区选择的代理方法
- (void)selectRegiton:(EVRegionCodeModel *)region;

@end

@interface EVSelectRegionViewController : EVViewController

@property (nonatomic, weak) id<CCSelectRegionViewControllerDelegate> delegate;

@end
