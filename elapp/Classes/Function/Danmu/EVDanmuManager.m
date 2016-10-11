//
//  EVDanmuManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVDanmuManager.h"
#import "EVDanmuView.h"
#import <PureLayout.h>


@interface EVDanmuManager ()
@property (nonatomic, strong) NSMutableSet * danmuSet;

@property (nonatomic, strong) NSMutableArray * danmuQueue;
@end

@implementation EVDanmuManager

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDanmuViews];
    }
    return self;
}


- (void)receiveDanmu:(EVDanmuModel *)danmuModel
{
    [self.danmuQueue addObject:danmuModel];
}

- (void)handleDanmu
{
    if (self.danmuQueue.count > 0 && self.danmuSet.count > 0) {
        EVDanmuModel * danmuModel = self.danmuQueue.firstObject;
        [self.danmuQueue removeObject:danmuModel];
        EVDanmuView * danmuView = [self.danmuSet anyObject];
        [self.danmuSet removeObject:danmuView];
        [self playDanmuAnimationWithDanmuView:danmuView];
        danmuView.model = danmuModel;
    }
    [self performSelector:@selector(handleDanmu) withObject:nil afterDelay:0.5f];
}

- (void)playDanmuAnimationWithDanmuView:(EVDanmuView *)danmuView
{
    [self bringSubviewToFront:danmuView];
    danmuView.leftConstraint.constant = -ScreenWidth*2;
    [UIView animateWithDuration:8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        danmuView.leftConstraint.constant = ScreenWidth;
        danmuView.model = nil;
        [self layoutIfNeeded];
        [self.danmuSet addObject:danmuView];
    }];
}

- (void)setupDanmuViews
{
    for (int i = 0; i < 4; i++) {
        EVDanmuView * danmuView = [[EVDanmuView alloc] init];
        [self addSubview:danmuView];
        [danmuView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:40*i-30];
        danmuView.leftConstraint = [danmuView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:ScreenWidth];
        [danmuView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 35)];
        [danmuView setAvatarClick:^(EVDanmuModel *model) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(presentViewShowFloatingView:)]) {
                [self.delegate presentViewShowFloatingView:model];
            }
        }];
        [self.danmuSet addObject:danmuView];
    }
    [self performSelector:@selector(handleDanmu) withObject:nil afterDelay:0.5f];
}

- (NSMutableSet *)danmuSet
{
    if (!_danmuSet) {
        _danmuSet = [[NSMutableSet alloc] init];
    }
    return _danmuSet;
}

- (NSMutableArray *)danmuQueue
{
    if (!_danmuQueue) {
        _danmuQueue = [[NSMutableArray alloc] init];
    }
    return _danmuQueue;
}


@end
