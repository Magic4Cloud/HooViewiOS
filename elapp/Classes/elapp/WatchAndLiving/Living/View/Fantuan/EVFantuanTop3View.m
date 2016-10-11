//
//  EVFantuanTop3View.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFantuanTop3View.h"
#import "EVTopContributorView.h"
#import <PureLayout/PureLayout.h>
#import "EVFantuanContributorModel.h"

@interface EVFantuanTop3View ()<CCTopContributorViewDelegate>

@property (weak, nonatomic) EVTopContributorView *firstContributorV;  /**< 排名第一的view */
@property (weak, nonatomic) EVTopContributorView *secondContributorV;  /**< 排名第二的view */
@property (weak, nonatomic) EVTopContributorView *thirdContributorV;  /**< 排名第三的view */

@end

@implementation EVFantuanTop3View

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setUpUI];
    }
    
    return self;
}


#pragma mark - CCTopContributorViewDelegate

- (void)logoClicked:(EVFantuanContributorModel *)model
{
    if ( self.logoClicked )
    {
        self.logoClicked(model);
    }
}


#pragma mark - private methods

- (void)setUpUI
{
    UIView *paddingView = [UIView new];
    [self addSubview:paddingView];
    [paddingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [paddingView autoSetDimension:ALDimensionHeight toSize:10];
    
    // 第一名
    EVTopContributorView *firstContributorV = [[EVTopContributorView alloc] init];
    firstContributorV.type = CCTopContributorTop1;
    firstContributorV.hidden = YES;
    [self addSubview:firstContributorV];
    self.firstContributorV = firstContributorV;
    [firstContributorV autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [firstContributorV autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [firstContributorV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:paddingView];
    firstContributorV.delegate = self;
    
    // 第二名
    EVTopContributorView *secondContributorV = [[EVTopContributorView alloc] init];
    secondContributorV.type = CCTopContributorTop2;
    secondContributorV.hidden = YES;
    [self addSubview:secondContributorV];
    self.secondContributorV = secondContributorV;
    [secondContributorV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:firstContributorV];
    [secondContributorV autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [secondContributorV autoPinEdgeToSuperviewEdge:ALEdgeRight];
    secondContributorV.delegate = self;
    
    // 第三名
    EVTopContributorView *thirdContributorV = [[EVTopContributorView alloc] init];
    thirdContributorV.type = CCTopContributorTop3;
    thirdContributorV.hidden = YES;
    [self addSubview:thirdContributorV];
    self.thirdContributorV = thirdContributorV;
    [thirdContributorV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:secondContributorV];
    [thirdContributorV autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [thirdContributorV autoPinEdgeToSuperviewEdge:ALEdgeRight];
    thirdContributorV.delegate = self;
    
    firstContributorV.backgroundColor = [UIColor whiteColor];
    secondContributorV.backgroundColor = [UIColor whiteColor];
    thirdContributorV.backgroundColor = [UIColor whiteColor];
}


#pragma mark - getters and setters

- (void)setTop3Contributors:(NSArray *)top3Contributors
{
    _top3Contributors = top3Contributors;
    
    for (int i = 0; i < top3Contributors.count ; ++i)
    {
        EVFantuanContributorModel *model = [top3Contributors objectAtIndex:i];
        if ( i == 0 )
        {
            self.firstContributorV.model = model;
        }
        else if ( i ==1 )
        {
            self.secondContributorV.model = model;
        }
        else if ( i == 2)
        {
            self.thirdContributorV.model = model;
        }
    }
    
    if ( top3Contributors.count == 2 )
    {
        self.thirdContributorV.hidden = YES;
        self.secondContributorV.hidden = NO;
        self.firstContributorV.hidden = NO;
    }
    else if ( top3Contributors.count == 1 )
    {
        self.thirdContributorV.hidden = YES;
        self.secondContributorV.hidden = YES;
        self.firstContributorV.hidden = NO;
    }
    else if ( top3Contributors.count == 0 )
    {
        self.thirdContributorV.hidden = YES;
        self.secondContributorV.hidden = YES;
        self.firstContributorV.hidden = YES;
    }
    else
    {
        self.thirdContributorV.hidden = NO;
        self.secondContributorV.hidden = NO;
        self.firstContributorV.hidden = NO;
    }
}

@end
