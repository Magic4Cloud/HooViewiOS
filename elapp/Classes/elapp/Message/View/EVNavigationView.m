//
//  EVNavigationView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVNavigationView.h"
#import <PureLayout.h>

@interface EVNavigationView ()
@property (nonatomic, weak) UIButton *touchButton;

@property (nonatomic, strong) NSMutableArray *buttonArrays;
@end


@implementation EVNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake(0, 0, 30, 30);
    iconImageView.image = [UIImage imageNamed:@"charge_icon_apple_select_nor"];
    [self addSubview:iconImageView];
    
    NSArray *typeArrays = @[@(EVMarketButtonTypeMarket),@(EVMarketButtonTypeChoose)];
    NSArray *titleArrays = @[@"市场",@"自选"];
    
    for (NSInteger i = 0; i < typeArrays.count; i++) {
        UIButton *touchButton = [[UIButton alloc] init];
        touchButton.frame = CGRectMake(40 + (i * 50), 0, 40, 40);
        [self addSubview:touchButton];
        touchButton.tag = [typeArrays[i] integerValue];
        [touchButton addTarget:self action:@selector(touchButtonItem:) forControlEvents:(UIControlEventTouchUpInside)];
        if (i == 0) {
            touchButton.selected = YES;
            self.touchButton = touchButton;
        }else {
            touchButton.selected = NO;
        }
        [self.buttonArrays addObject:touchButton];
        [touchButton setTitleColor:[UIColor evMainColor] forState:(UIControlStateSelected)];
        [touchButton setTitleColor:[UIColor evLineColor] forState:(UIControlStateNormal)];
        [touchButton setTitle:titleArrays[i] forState:(UIControlStateNormal)];
    }
    
    UIButton *searchButton = [[UIButton alloc] init];
//    searchButton.tag = EVHomeScrollNavgationBarSearchButton;
    [self addSubview:searchButton];
    [searchButton setImage:[UIImage imageNamed:@"home_icon_navigation_search"] forState:UIControlStateNormal];
    [searchButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [searchButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [searchButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
}

- (void)touchButtonItem:(UIButton *)btn
{
    if (btn != self.touchButton) {
        
        btn.selected = YES;
        self.touchButton.selected = NO;
    }
   
    self.touchButton = btn;
//    switch (btn.tag) {
//        case EVMarketButtonTypeMarket:
//            
//            break;
//        case EVMarketButtonTypeChoose:
//            
//            break;
//        default:
//            break;
//    }
}

- (void)buttonDidClicked:(UIButton *)btn
{
    
}

- (NSMutableArray *)buttonArrays
{
    if (_buttonArrays == nil) {
        _buttonArrays = [NSMutableArray array];
    }
    return _buttonArrays;
}

@end
