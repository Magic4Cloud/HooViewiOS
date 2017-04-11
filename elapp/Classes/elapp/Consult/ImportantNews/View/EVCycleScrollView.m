//
//  EVCycleScrollView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCycleScrollView.h"

#import "EVCarouselItem.h"

@interface EVCycleScrollView () <SDCycleScrollViewDelegate>


@property (nonatomic, strong) UIImageView *BannerImage;


@end


@implementation EVCycleScrollView

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cycleScrollView];
//        [self.cycleScrollView addSubview:self.BannerImage];
    }
    return self;
}

#pragma mark - Setter Method
- (void)setItems:(NSArray *)items {
    _items = items;
    if (items.count > 0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (EVCarouselItem *kItem in items) {
            [tempArray addObject:[kItem img]];
            [titleArray addObject:[kItem title]];
        }
        self.cycleScrollView.titlesGroup = titleArray;
        self.cycleScrollView.imageURLStringsGroup = tempArray;
        
    }
}

#pragma mark - Lazy Load
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView)
    {

        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
        _cycleScrollView.autoScrollTimeInterval = 5.0f;
        
        __weak typeof(self) weakSelf = self;
        _cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(cycleScrollViewDidSelected:index:)]) {
                EVCarouselItem *item = weakSelf.items[index];
                [weakSelf.delegate cycleScrollViewDidSelected:item index:index];
            }
        };
    }
    return _cycleScrollView;
}

/**
 阴影
 */
-(UIImageView *)BannerImage {
    if (!_BannerImage) {
        CGFloat headerW = ScreenWidth;
        CGFloat banderW = headerW;
        _BannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, banderW, self.bounds.size.height)];
        _BannerImage.image = [UIImage imageNamed:@"bg_banner-1"];
    }
    return _BannerImage;
}


@end
