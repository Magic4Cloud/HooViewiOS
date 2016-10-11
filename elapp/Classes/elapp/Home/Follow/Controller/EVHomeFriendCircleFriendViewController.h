//
//  EVHomeFriendCircleFriendViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVHomeCommonBaseViewController.h"



@protocol EVHomeHotViewControllerDelegate <NSObject>

- (void)pushHotViewController;

@end

@interface EVHomeFriendCircleFriendViewController : EVHomeCommonBaseViewController

@property (nonatomic,weak) id<EVHomeHotViewControllerDelegate> delegate;

@end
