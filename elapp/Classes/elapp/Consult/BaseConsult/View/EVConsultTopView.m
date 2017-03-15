//
//  EVConsultTopView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/25.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVConsultTopView.h"
#import "SGSegmentedControl.h"


@interface EVConsultTopView ()<SGSegmentedControlStaticDelegate>




@end

@implementation EVConsultTopView

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
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView = contentView;
    
    NSArray *titleArray = @[@"要闻",@"快讯",@"自选"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake((ScreenWidth - 200)/2, 20, 200, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        *segmentedControlStaticType = SGSegmentedControlStaticTypeBigTitle;
    }];
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor clearColor];
        *titleColor = [UIColor whiteColor];
        *selectedTitleColor = [UIColor whiteColor];
        *indicatorColor = [UIColor whiteColor];
    }];
    self.topSView.selectedIndex = 0;
    [self addSubview:_topSView];
    
    UIButton *searchButton = [[UIButton alloc] init];
    searchButton.frame = CGRectMake(ScreenWidth - 60, 20, 44,44);
    searchButton.backgroundColor = [UIColor hvPurpleColor];
    searchButton.alpha = 0.8;
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 22;
    [searchButton setImage:[UIImage imageNamed:@"btn_news_search_n"] forState:(UIControlStateNormal)];
    [self addSubview:searchButton];
    self.searchButton = searchButton;
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scroll
{
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scroll];
}

// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewDidSeleteIndex:)]) {
        [self.delegate topViewDidSeleteIndex:index];
    }
}


- (void)searchClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeleteSearch)]) {
        [self.delegate didSeleteSearch];
    }
}
@end
