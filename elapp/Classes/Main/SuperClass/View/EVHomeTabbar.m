//
//  EVHomeTabbar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVHomeTabbar.h"
#import <PureLayout.h>
#import "EVTabbarItem.h"  ,   

#define K_ANIMATION_TIME 0.3

static CGFloat const kAnimationDuration = 0.3f;
static CGFloat const kBackgroundViewHeight = 49.f;
static CGFloat const kItemLeft = 5.f;
CGFloat const HOMETABBAR_HEIGHT = 71.f;

@interface EVHomeTabbar () <EVTabbarItemDelegate>

@property (nonatomic, assign) BOOL tabbarShow;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) EVTabbarItem *firstItem;
@property (nonatomic, strong) EVTabbarItem *secondItem;
@property (nonatomic, strong) EVTabbarItem *thirdItem;
@property (nonatomic, strong) EVTabbarItem *fourthItem;
@property (nonatomic, strong) EVTabbarItem *selectedItem;   /**< 用作标识 */
//@property (nonatomic, strong) EVTabLiveItem *liveItem;

@end


@implementation EVHomeTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTabViews];
    }
    return self;
}

- (void)setupTabViews {
    CGFloat itemWidth = ScreenWidth/4;
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.bgView autoSetDimension:ALDimensionHeight toSize:kBackgroundViewHeight];
    
    // 顶部线
//    EVLineView *topLine = [EVLineView addTopLineToView:self.bgView];
//    topLine.backgroundColor = [UIColor evLineColor];
    
    
    self.firstItem = [[EVTabbarItem alloc] initWithSelectImg:[UIImage imageNamed:@"appbar_icon_first"]
                                                   normalImg:[UIImage imageNamed:@"appbar_icon_first_nor"]
                                                       title:@"资讯"];
    [self.bgView addSubview:self.firstItem];
    [self.firstItem autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.firstItem autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.firstItem autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kItemLeft];
    [self.firstItem autoSetDimension:ALDimensionWidth toSize:itemWidth];
    
    self.secondItem = [[EVTabbarItem alloc] initWithSelectImg:[UIImage imageNamed:@"appbar_icon_two"]
                                                    normalImg:[UIImage imageNamed:@"appbar_icon_two_nor"]
                                                        title:@"直播"];
    [self.bgView addSubview:self.secondItem];
    [self.secondItem autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.secondItem autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.secondItem autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.firstItem];
    [self.secondItem autoSetDimension:ALDimensionWidth toSize:itemWidth];
    
    self.fourthItem = [[EVTabbarItem alloc] initWithSelectImg:[UIImage imageNamed:@"appbar_icon_four"]
                                                    normalImg:[UIImage imageNamed:@"appbar_icon_four_nor"]
                                                        title:@"个人"];
    [self.bgView addSubview:self.fourthItem];
    [self.fourthItem autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.fourthItem autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.fourthItem autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kItemLeft];
    [self.fourthItem autoSetDimension:ALDimensionWidth toSize:itemWidth];
    
    self.thirdItem = [[EVTabbarItem alloc] initWithSelectImg:[UIImage imageNamed:@"appbar_icon_three"]
                                                   normalImg:[UIImage imageNamed:@"appbar_icon_three_nor"]
                                                       title:@"行情"];
    [self.bgView addSubview:self.thirdItem];
    [self.thirdItem autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.thirdItem autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.thirdItem autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.fourthItem];
    [self.thirdItem autoSetDimension:ALDimensionWidth toSize:itemWidth];
    
    
//    self.liveItem = [CCTabLiveItem new];
//    [self addSubview:self.liveItem];
//    [self.liveItem autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [self.liveItem autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [self.liveItem autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [self.liveItem autoSetDimensionsToSize:CGSizeMake(kLiveItemWidth, kLiveItemHeight)];
    
    
    self.firstItem.delegate = self;
    self.secondItem.delegate = self;
    self.fourthItem.delegate = self;
    self.thirdItem.delegate = self;
//    self.liveItem.delegate = self;
    self.firstItem.tag = EVHomeTabbarButtonActivity;
    self.secondItem.tag = EVHomeTabbarButtonTimeLine;
    self.thirdItem.tag = EVHomeTabbarButtonFriendCircle;
    self.fourthItem.tag = EVHomeTabbarButtonLetter;
//    self.liveItem.tag = EVHomeTabbarButtonLive;
    
    self.selectedItem = self.firstItem;
    [self.firstItem selectItem:YES];
    self.selectedIndex = 0;
    
    self.tabbarShow = YES;
}


#pragma mark - CCTabbarItemDelegate
- (void)didClickedTabbarItem:(EVTabbarItem *)item {
    if (item == self.selectedItem) {
        if (item.tag == EVHomeTabbarButtonActivity) {
            if ([self.delegate respondsToSelector:@selector(homeTabbarDicDoubleClick:)]) {
                [self.delegate homeTabbarDicDoubleClick:EVHomeTabbarButtonActivity];
            }
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(homeTabbarDidClicked:)]) {
        [self.delegate homeTabbarDidClicked:item.tag];
    }
    
    if (item.tag != EVHomeTabbarButtonLive) {
        [self.selectedItem selectItem:NO];
        [item selectItem:YES];
        self.selectedItem = item;
    }
}

#pragma mark - CCTabLiveItemDelegate
//- (void)didClickedLiveItem:(EVTabLiveItem *)item {
//    if (item.tag != CCHomeTabbarButtonLive) {
//        return;
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(homeTabbarDidClickedLiveButton)]) {
//        [self.delegate homeTabbarDidClickedLiveButton];
//    }
//}


#pragma mark - animation
- (void)hideTabbarWithAnimation:(void(^)())complete {
    if (!self.tabbarShow) {
        return;
    }
    self.tabbarShow = NO;
    
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        !complete ?: complete();
    }];
    
}

- (void)showTabbarWithAnimation:(void(^)())complete {
    if (self.tabbarShow) {
        return;
    }
    self.tabbarShow = YES;
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        !complete ?: complete();
    }];
    
}

#pragma mark - setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self.selectedItem selectItem:NO];
    EVTabbarItem *item = self.selectedItem;
    switch ( selectedIndex )
    {
        case 0:
            item = self.firstItem;
            break;
            
        case 1:
            item = self.secondItem;
            break;
            
        case 2:
            item = self.thirdItem;
            break;
            
        case 3:
            item = self.fourthItem;
            break;
            
        default:
            break;
    }
    [item selectItem:YES];
    self.selectedItem = item;
}


@end

///---------------------------
/// @name CCHomeTabbarContainer
///---------------------------
@implementation EVHomeTabbarContainer

#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        EVHomeTabbar *tabbar = [[EVHomeTabbar alloc] init];
        [self addSubview:tabbar];
        [tabbar autoPinEdgesToSuperviewEdges];
        self.layer.borderColor = [UIColor colorWithHexString:@"f8f8f8"].CGColor;
        self.layer.borderWidth = 1;
        
        self.tabbar = tabbar;
    }
    return self;
}

#pragma mark - actions
- (void)hideTabbarWithAnimation {
    [self.tabbar hideTabbarWithAnimation:nil];
}

- (void)showTabbarWithAnimation {
    [self.tabbar showTabbarWithAnimation:nil];
}

#pragma mark UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *item in self.subviews) {
        if (![item isKindOfClass:[EVHomeTabbar class]]) {
            item.hidden = YES;
        }
    }
    
    self.tabbar.frame = self.bounds;
}

// 防止响应链断开
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    NSInteger tabY = self.tabbar.frame.origin.y;
    NSInteger tabH = self.tabbar.frame.size.height;
    if (tabY == tabH) {
        CGRect touchRect = self.bounds;
        if (CGRectContainsPoint(touchRect, point)) {
            return nil;
        }
    }
    return hitView;
}

#pragma mark - getters / setters
- (void)setShowRedPoint:(BOOL)showRedPoint {
    _showRedPoint = showRedPoint;
    [self.tabbar.fourthItem showRedPoint:showRedPoint];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.tabbar.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex {
    return self.tabbar.selectedIndex;
}
@end
