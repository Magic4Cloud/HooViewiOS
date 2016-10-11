//
//  EVHomeCommonBaseViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"
#import "EVLabelsTabbarItem.h"
#import "EVHomeScrollViewController.h"

@protocol CCHomeCommonBaseViewControllerProtocal <NSObject>

@optional
- (void)homeScrollViewDidScroll;

@end

@interface EVHomeCommonBaseViewController : EVViewController<CCHomeCommonBaseViewControllerProtocal>

@property (nonatomic,strong) EVLabelsTabbarItem *viewControllerItem;

@property (nonatomic, assign) BOOL gesturePrepared;

@property (nonatomic,weak) id<CCHomeScrollViewControllerProtocol> homeScrollView;

@end
