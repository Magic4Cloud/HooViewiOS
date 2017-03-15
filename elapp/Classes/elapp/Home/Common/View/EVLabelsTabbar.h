//
//  EVLabelsTabbar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVLabelsTabbarItem,EVLabelsTabbar;

#define LABELTABBAR_HEIGHT 44

@protocol EVLabelsTabbarDelegate <NSObject>

@optional
- (void)labelsTabbar:(EVLabelsTabbar *)tabbar didSelectedItem:(EVLabelsTabbarItem *)item;

@end

@interface EVLabelsTabbar : UIView

@property (nonatomic,weak) id<EVLabelsTabbarDelegate> delegate;

@property (nonatomic,strong) NSArray *items;

@property (nonatomic, assign) NSInteger sliderIndex;

@property (nonatomic,weak) UICollectionView *collectionView;

@end
