//
//  EVHomeScrollNavgationBar.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVHomeScrollNavgationBar.h"
#import "EVMovingConvexView.h"
#import <PureLayout.h>
#import "EVLoginInfo.h"
#import "EVVideoTopicItem.h"

#define MENU_STAR_TAG           200

#define K_ANIMATION_TIME        0.3

@interface EVHomeScrollNavgationBar () <CCMovingConvexViewDelegate>

@property (nonatomic,weak) EVMovingConvexView *convexView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic, assign) BOOL initaled;
@property (nonatomic,strong) NSArray *titleButtons;
@property (nonatomic,weak) UIButton *selectedButton;
@property (nonatomic, assign) BOOL navigationBarShow;
@property (nonatomic,copy) NSString *logourl;
@property (nonatomic, weak) UIButton *centerBtn;

@end

@implementation EVHomeScrollNavgationBar

- (instancetype)initWithSubTitles:(NSArray *)subTitles
{
    
    if ( self = [super init] )
    {
        self.subTitles = subTitles;
        [self setUP];
    }
    return self;
}

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
}

- (void)setUP
{
    // change by 佳南

    self.backgroundColor = CCColor(98, 45, 128);
    self.layer.cornerRadius = 2.0f;
    self.layer.shadowColor = CCColor(1, 1, 1).CGColor;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.2;

    CGFloat margin = 10.f;
    EVHeaderButton *personalButton = [[EVHeaderButton alloc] init];
    personalButton.tag = CCHomeScrollNavgationBarIconButton;
    [self addSubview:personalButton];
    
    [personalButton setImage:[UIImage imageNamed:@"home_nav_account"] forState:UIControlStateNormal];
    [personalButton setImage:[UIImage imageNamed:@"home_nav_account_pre"] forState:UIControlStateHighlighted];
    [personalButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    [personalButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:27];
    [personalButton autoSetDimensionsToSize:CGSizeMake(30.f, 30.f)];
    [personalButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
//    self.personalButton = personalButton;
   
    UIButton *searchButton = [[UIButton alloc] init];
    searchButton.tag = CCHomeScrollNavgationBarSearchButton;
    [self addSubview:searchButton];
//    [searchButton setImage:[UIImage imageNamed:@"home_icon_navigation_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"home_nav_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"home_nav_search_pre"] forState:UIControlStateHighlighted];
    [searchButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    [searchButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:personalButton];
    
    [searchButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
    
    if ( self.subTitles.count )
    {
        [self setUpConvexView];
    }

    [self setUpNotification];
}

- (void)setScrollPercent:(CGFloat)scrollPercent
{
    if ( _scrollPercent != scrollPercent )
    {
        _scrollPercent = scrollPercent;
        self.convexView.scrollPercent = scrollPercent;
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setUpConvexView
{
    UIView *titleContentView = [[UIView alloc] init];
    titleContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:titleContentView];
    [titleContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [titleContentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleContentView autoSetDimension:ALDimensionWidth toSize:240.0f];
    [titleContentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:self.subTitles.count];
    for (NSInteger i = 0 ; i < self.subTitles.count; i++)
    {
        NSString *item = self.subTitles[i];
        UIButton *btn = [self titleButtonWithTitle:item];
        [titleContentView addSubview:btn];
        [buttons addObject:btn];
        btn.tag = MENU_STAR_TAG + i;
        
        [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
        
        if ( i == 0 )
        {
            [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        }
        else if ( i == ( (NSInteger)self.subTitles.count - 1 )  )
        {
            [btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        }
        if ([btn.titleLabel.text isEqualToString:@"热门"]) {
            btn.backgroundColor = [UIColor clearColor];
            [btn setImage:[UIImage imageNamed:@"homepage_classify_more"] forState:(UIControlStateSelected)];
            [btn setImage:[UIImage imageNamed:@"homepage_classify_more_nor"] forState:(UIControlStateNormal)];
        }
        
        [btn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-10];
        
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
    
    self.titleButtons = buttons;
  
    for ( NSInteger i = 0; i <= (NSInteger)buttons.count - 1; i++ )
    {
        UIButton *btn = buttons[i];
        
        if ( i == 0 )
        {
            [btn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:buttons[i + 1]];
        }
        else if ( i == (NSInteger)buttons.count - 1 )
        {
            [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:buttons[i - 1]];
        }
        else
        {
            [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:buttons[i - 1]];
            [btn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:buttons[i + 1]];
        }
        
        if ( i != (NSInteger)buttons.count - 1 )
        {
            [btn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:buttons[i + 1]];
        }
    }
    
    for ( NSInteger i = (NSInteger)buttons.count - 1; i >= 0; i-- )
    {
         UIButton *btn = buttons[i];
        if ( i != 0 )
        {
            [btn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:buttons[i - 1]];
        }
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [self addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
}


- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(updateLogo:) name:CCUpdateLogolURLNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(postTopic:) name:@"postTopicItem" object:nil];
}

- (void)postTopic:(NSNotification *)center
{
    NSDictionary *dict = center.userInfo;
    EVVideoTopicItem *item = dict[@"topicItem"];
    UIButton *button = [self viewWithTag:201];
    [button setTitle:item.title forState:(UIControlStateNormal)];
}

- (void)setLogourl:(NSString *)logourl
{
    // change by 佳南
    _logourl = logourl;
    
    [self.personalButton setImage:[UIImage imageNamed:@"home_nav_account"] forState:UIControlStateNormal];
    [self.personalButton setImage:[UIImage imageNamed:@"home_nav_account_pre"] forState:UIControlStateHighlighted];

    if ( ![logourl isKindOfClass:[NSString class]] || ![_logourl isEqualToString:logourl] )
    {
        return;
    }
    _logourl = logourl;
    
//    [self.personalButton cc_setBackgroundImageURL:logourl placeholderImageStr:@"avatar" isVip:0 vipSizeType:CCVipMini];
}

- (void)updateLogo:(NSNotification *)notification
{
    self.logourl = notification.userInfo[kLogourl];
}

- (UIButton *)titleButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor evSecondColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"#d4d4d4"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return button;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = self.titleButtons[selectedIndex];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}

- (void)buttonDidClicked:(UIButton *)btn
{
    if ( btn.tag >= CCHomeScrollNavgationBarIconButton && btn.tag <= CCHomeScrollNavgationBarSearchButton )
    {
        if ( [self.delegate respondsToSelector:@selector(homeScrollNavgationBarDidClicked:)] )
        {
            [self.delegate homeScrollNavgationBarDidClicked:btn.tag];
        }
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(homeScrollNavgationBarDidSeleceIndex:)] )
    {
        [self.delegate homeScrollNavgationBarDidSeleceIndex:btn.tag - MENU_STAR_TAG];
    }
}

- (void)hideHomeNavigationBar
{
    if ( !self.navigationBarShow )
    {
        return;
    }
    
    self.navigationBarShow = NO;
    // change by 佳南
//    self.topConstraint.constant = -CCHOMENAV_HEIGHT;
//    [self setNeedsLayout];
//    
//    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
//        [self layoutIfNeeded];
//    }];
}

- (void)showHomeNavigationBar
{
    if ( self.navigationBarShow )
    {
        return;
    }
    
    self.navigationBarShow = YES;
    // change by 佳南
//    self.topConstraint.constant = 0;
//    [self setNeedsLayout];
//    
//    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
//        [self layoutIfNeeded];
//    }];
}

#pragma mark - CCMovingConvexViewDelegate
- (void)movingConvexViewDidUpdatePercent:(CGFloat)percent
{
    if ( [_delegate respondsToSelector:@selector(homeScrollViewUserDidMoveToPercent:)] )
    {
        [_delegate homeScrollViewUserDidMoveToPercent:percent];
    }
}

- (void)movingUpdateToIndex:(NSInteger)index
{
    if (  [_delegate respondsToSelector:@selector(homeScrollNavgationBarDidDragToUpdateIndex:)] )
    {
        [_delegate homeScrollNavgationBarDidDragToUpdateIndex:index];
    }
    self.selectedIndex = index;
}

@end
