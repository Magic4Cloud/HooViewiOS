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
#define Prompt_TAG              300

#define K_ANIMATION_TIME        0.3

@interface EVHomeScrollNavgationBar () <EVMovingConvexViewDelegate>

@property (nonatomic,weak) EVMovingConvexView *convexView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic, assign) BOOL initaled;
@property (nonatomic,strong) NSArray *titleButtons;
@property (nonatomic,weak) UIButton *selectedButton;
@property (nonatomic, assign) BOOL navigationBarShow;
@property (nonatomic,copy) NSString *logourl;
@property (nonatomic, weak) UIButton *centerBtn;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIButton *editButton;
@property (nonatomic, weak) UIImageView *promptView;
@property (nonatomic, strong) NSArray *promptViewArray;

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
    [EVNotificationCenter removeObserver:self];
}

- (void)setUP
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 16.f;
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [leftImageView setImage:[UIImage imageNamed:@"huoyan_logo"]];
    [self addSubview:leftImageView];
    leftImageView.backgroundColor = [UIColor clearColor];
     
    [leftImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin];
    [leftImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:32.6];
    [leftImageView autoSetDimensionsToSize:leftImageView.image.size];
    self.leftImageView = leftImageView;
    
    
 
    UIButton *searchButton = [[UIButton alloc] init];
    searchButton.tag = EVHomeScrollNavgationBarSearchButton;
    [self addSubview:searchButton];
    [searchButton setImage:[UIImage imageNamed:@"btn_news_search_n"] forState:UIControlStateNormal];
    [searchButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin];
    [searchButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftImageView];
    
    [searchButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
    
    
    UIButton *editButton = [[UIButton alloc] init];
    editButton.tag = EVHomeScrollNavgationBarEditButton;
    [self addSubview:editButton];
    self.editButton = editButton;
    editButton.hidden = YES;
    [editButton setImage:[UIImage imageNamed:@"huoyan_edit"] forState:UIControlStateNormal];
    [editButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:searchButton withOffset:-20];
    [editButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftImageView];
    
    [editButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
    
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
    [titleContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [titleContentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:52];
    [titleContentView autoSetDimension:ALDimensionWidth toSize:240.0f];
    [titleContentView autoSetDimension:ALDimensionHeight toSize:44];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:self.subTitles.count];
    NSMutableArray *promptViews = [NSMutableArray arrayWithCapacity:self.subTitles.count];
    for (NSInteger i = 0; i < self.subTitles.count; i++) {
        NSString *item = self.subTitles[i];
        UIButton *btn = [self titleButtonWithTitle:item];
        btn.frame = CGRectMake((i * 60), 11, 36, 22);
        btn.backgroundColor = [UIColor clearColor];
        [titleContentView addSubview:btn];
        [buttons addObject:btn];
        btn.tag = MENU_STAR_TAG + i;
        [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIImageView *promptView = [[UIImageView alloc]init];
        [titleContentView addSubview:promptView];
        promptView.frame = CGRectMake((11)+(i * 60), 36, 13, 8);
        promptView.image = [UIImage imageNamed:@"Huoyan_Topbar_Tip"];
        promptView.tag = Prompt_TAG + i;
        self.promptView = promptView;
        [promptViews addObject:promptView];
        if (i != 0) {
            promptView.hidden = YES;
        }
    }
    self.titleButtons = buttons;
    self.promptViewArray = promptViews;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [self addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
}


- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(postTopic:) name:@"postTopicItem" object:nil];
}

- (void)postTopic:(NSNotification *)center
{
    NSDictionary *dict = center.userInfo;
    EVVideoTopicItem *item = dict[@"topicItem"];
    UIButton *button = [self viewWithTag:201];
    [button setTitle:item.title forState:(UIControlStateNormal)];
}

- (UIButton *)titleButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor evMainColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return button;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = self.titleButtons[selectedIndex];
    UIImageView *imgV = self.promptViewArray[selectedIndex];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
    if (btn.tag == 201) {
        self.editButton.hidden = NO;
    }else {
        self.editButton.hidden = YES;
    }
    
    if (imgV != self.promptView) {
        imgV.hidden = NO;
        self.promptView.hidden = YES;
    }
    self.promptView = imgV;
    
}

- (void)buttonDidClicked:(UIButton *)btn
{
    if ( btn.tag >= EVHomeScrollNavgationBarEditButton && btn.tag <= EVHomeScrollNavgationBarSearchButton ) {
        if ( [self.delegate respondsToSelector:@selector(homeScrollNavgationBarDidClicked:)] ) {
            [self.delegate homeScrollNavgationBarDidClicked:btn.tag];
        }
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(homeScrollNavgationBarDidSeleceIndex:)] ) {
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
    self.topConstraint.constant = -CCHOMENAV_HEIGHT;
    [self setNeedsLayout];
    
    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showHomeNavigationBar
{
    if ( self.navigationBarShow )
    {
        return;
    }
    
    self.navigationBarShow = YES;
    
    self.topConstraint.constant = 0;
    [self setNeedsLayout];
    
    [UIView animateWithDuration:K_ANIMATION_TIME animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - EVMovingConvexViewDelegate
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
