//
//  EVLiveTopView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveTopView.h"
#import "SGSegmentedControl.h"

@interface EVLiveTopView ()<SGSegmentedControlStaticDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@end

@implementation EVLiveTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}


- (void)addUpView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 63)];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftImage = [[UIButton alloc] init];
    [self addSubview:leftImage];
    leftImage.frame = CGRectMake(16, 32, 100, 22);
    [leftImage setImage:[UIImage imageNamed:@"huoyan_logo"] forState:(UIControlStateNormal)];
    [leftImage setTitle:@" 火眼直播" forState:(UIControlStateNormal)];
    [leftImage setTitleColor:[UIColor evMainColor] forState:(UIControlStateNormal)];
    leftImage.titleLabel.font = [UIFont textFontB2];
    
    
    UIButton *searchButton = [[UIButton alloc] init];
    searchButton.frame = CGRectMake(ScreenWidth - 38, 29, 22, 22);
    [self addSubview:searchButton];
    [searchButton setImage:[UIImage imageNamed:@"Huoyan_market_search"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    NSArray *titleArray = @[@"视频直播",@"图文直播",@"精品视频"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 64, ScreenWidth, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];

    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [self addSubview:_topSView];
    
    
}

- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView
{
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    // 计算滚动的位置
//    CGFloat offsetX = index * self.view.frame.size.width;
//    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedDidSeletedIndex:)]) {
        [self.delegate segmentedDidSeletedIndex:index];
    }
}

- (void)searchClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchButton)]) {
        [self.delegate didSearchButton];
    }
}
@end
