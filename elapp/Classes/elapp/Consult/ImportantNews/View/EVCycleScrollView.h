//
//  EVCycleScrollView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"
#import "SDCycleScrollView.h"

@class EVCarouselItem;
@protocol EVCycleScrollViewDelegate;


@interface EVCycleScrollView : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak  ) id<EVCycleScrollViewDelegate> delegate;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end


@protocol EVCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDidSelected:(EVCarouselItem *)item
                             index:(NSInteger)index;
@end
