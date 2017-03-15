//
//  EVCycleScrollView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCycleScrollView.h"
#import "SDCycleScrollView.h"
#import "EVCarouselItem.h"

@interface EVCycleScrollView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end


@implementation EVCycleScrollView

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cycleScrollView];
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
    if (!_cycleScrollView) {
        CGFloat whRate  = BannerWidthHeightRate;
        CGFloat headerW = ScreenWidth;
        CGFloat banderW = headerW;
        CGFloat banderH = banderW / whRate;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, banderW, 250)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
        _cycleScrollView.autoScrollTimeInterval = 5.0f;
        _cycleScrollView.pageControlAliment     = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotColor    = [UIColor whiteColor];
        _cycleScrollView.pageDotColor           = [UIColor colorWithHexString:@"000000" alpha:0.3];
        _cycleScrollView.pageOriginY            = 250-20;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:18];
        _cycleScrollView.titleLabelHeight = 50;
        
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

@end
