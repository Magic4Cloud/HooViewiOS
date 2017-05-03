//
//  EVLiveShareView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveShareView.h"
#import <PureLayout.h>
#import "EVShareManager.h"


static CGFloat const kIconImgHeight = 48.f;
static CGFloat const kIconImgTop = 22.f;
static CGFloat const kTitleLabTop = 12.f;

@interface CCShareItemView : UIView

@property (nonatomic) UIImageView *iconImgV;
@property (nonatomic) UILabel *titleLab;

- (void)configIcon:(UIImage *)icon disableIcon:(UIImage *)disableIcon title:(NSString *)title enable:(BOOL)enable;

@end

@implementation CCShareItemView

#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgV];
        [self addSubview:self.titleLab];
        
        [self.iconImgV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kIconImgTop];
        [self.iconImgV autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.iconImgV autoSetDimensionsToSize:CGSizeMake(kIconImgHeight, kIconImgHeight)];
        
        [self.titleLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.titleLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconImgV withOffset:kTitleLabTop];
    }
    return self;
}

- (void)configIcon:(UIImage *)icon disableIcon:(UIImage *)disableIcon title:(NSString *)title enable:(BOOL)enable {
    if (!title) {
        return;
    }
    
    self.iconImgV.image = enable ? icon : disableIcon;
    self.titleLab.text = title;
}

#pragma mark - getter 💤
- (UIImageView *)iconImgV {
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
    }
    return _iconImgV;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor evTextColorH1];
        _titleLab.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab;
}

@end



CGFloat const EVShareViewHeight = 270.f;
static CGFloat const kHeaderViewHeight = 50.f;
static CGFloat const kItemPadding = 75.f;
static CGFloat const kItemHeight = 100.f;
static CGFloat const kItemWidth = 48.f;


@interface EVLiveShareView ()
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, weak) UIView *bgView;

@end


@implementation EVLiveShareView

#pragma mark - init views 💧
- (instancetype)initWithParentView:(UIView *)parentView {
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.parentView = parentView;
        [self buildShareViewUI];
    }
    return self;
}

- (void)buildShareViewUI
{
    
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.98];
    [bgView autoSetDimension:ALDimensionHeight toSize:EVShareViewHeight];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];

    
    UIView *headerView = [UIView new];
    [bgView addSubview:headerView];
    [headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [headerView autoSetDimension:ALDimensionHeight toSize:kHeaderViewHeight];
    
    UIView *contentView = [UIView new];
    [bgView addSubview:contentView];
    [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [contentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerView];
    
    // headerView
    UILabel *titleLab = [UILabel new];
    titleLab.textColor = [UIColor evTextColorH2];
    titleLab.text = @"分享";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLab];
    [titleLab autoPinEdgesToSuperviewEdges];
    
    
    // contentView
    CCShareItemView *itemWechat = [CCShareItemView new];
    CCShareItemView *itemQZone = [CCShareItemView new];
    CCShareItemView *itemQQ = [CCShareItemView new];
    CCShareItemView *itemSina = [CCShareItemView new];
    CCShareItemView *itemCircle = [CCShareItemView new];
    CCShareItemView *itemCopy = [CCShareItemView new];
    
    itemWechat.tag = EVLiveShareWeiXinButton;
    itemQZone.tag = EVLiveShareQQZoneButton;
    itemQQ.tag = EVLiveShareQQButton;
    itemSina.tag = EVLiveShareSinaWeiBoButton;
    itemCircle.tag = EVLiveShareFriendCircleButton;
    itemCopy.tag = EVLiveShareCopyButton;
    
    [itemWechat configIcon:[UIImage imageNamed:@"living_icon_share_wechat_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_wechat"] title:@"微信" enable:[EVShareManager weixinInstall]];
    [itemQZone configIcon:[UIImage imageNamed:@"living_icon_share_qq_circle_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_qq_circle"] title:@"QQ空间" enable:[EVShareManager qqInstall]];
    [itemQQ configIcon:[UIImage imageNamed:@"living_icon_share_qq_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_qq"] title:@"QQ" enable:[EVShareManager qqInstall]];
    [itemSina configIcon:[UIImage imageNamed:@"living_icon_share_webo_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_webo"] title:@"微博" enable:[EVShareManager weiBoInstall]];
    [itemCircle configIcon:[UIImage imageNamed:@"living_icon_share_circle_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_circle"] title:@"朋友圈" enable:[EVShareManager weixinInstall]];
    [itemCopy configIcon:[UIImage imageNamed:@"living_icon_share_copy_nor"] disableIcon:[UIImage imageNamed:@"living_icon_share_copy"] title:@"复制链接" enable:YES];
    
    [contentView addSubview:itemWechat];
    [contentView addSubview:itemQZone];
    [contentView addSubview:itemQQ];
    [contentView addSubview:itemSina];
    [contentView addSubview:itemCircle];
    [contentView addSubview:itemCopy];
    
    NSArray *items = @[itemWechat, itemQZone, itemQQ, itemSina, itemCircle, itemCopy];
    [items autoSetViewsDimensionsToSize:CGSizeMake(kItemWidth, kItemHeight)];
    
    [itemWechat autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [itemWechat autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [itemQQ autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:itemWechat withOffset:-kItemPadding];
    [itemQQ autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [itemSina autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:itemWechat withOffset:kItemPadding];
    [itemSina autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [itemQZone autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [itemQZone autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:itemWechat];
    
    [itemCircle autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:itemQZone withOffset:-kItemPadding];
    [itemCircle autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:itemQZone];
    
    [itemCopy autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:itemQZone withOffset:kItemPadding];
    [itemCopy autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:itemQZone];
    
    for (UIView *view in contentView.subviews) {
        if ([view isKindOfClass:[CCShareItemView class]]) {
            [view addGestureRecognizer:({
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTapItem:)];
                tap;
            })];
        }
    }
}

- (void)actionOfTapItem:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(liveShareViewDidClickButton:)]) {
        [self.delegate liveShareViewDidClickButton:gesture.view.tag];
        [self dissmiss];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point =  [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        [self dissmiss];
    }
}

- (void)dissmiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveShareViewWillHided)]) {
        [self.delegate liveShareViewWillHided];
    }
    CGRect frame = self.frame;
    frame.origin.y = self.parentView.bounds.size.height;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)show
{
    CGRect frame = self.frame;
    frame.origin.y = self.parentView.bounds.size.height - self.frame.size.height;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}



@end
