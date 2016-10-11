//
//  EVCategoryViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"
#import "EVTopicItem.h"
#import "EVVideoTopicItem.h"

@interface EVCategoryButton : UIButton

@end

@protocol EVCategoryViewControllerDelegate <NSObject>

- (void)liveCategoryViewDidSelectItem:(EVVideoTopicItem *)item;

@end

@interface EVCategoryViewController : EVViewController

@property (weak, nonatomic) id<EVCategoryViewControllerDelegate> delegate;

@property (strong, nonatomic) EVTopicItem * nowItem;

@end
