//
//  EVReportReasonView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVReportReasonView.h"
#import "AppDelegate.h"
#import "PureLayout.h"

@interface EVReportReasonView()

@property (nonatomic, weak) UIView *coverView;         //背景色的view
@property (weak,  nonatomic) UIView  *reportReasonView;//展示列表View

@end

@implementation EVReportReasonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUIReason];
    }
    return self;
}

- (void)dealloc
{
    if ( _coverView && [_coverView superview] )
    {
        [_coverView removeFromSuperview];
    }
}

- (void)show
{
    self.coverView.hidden = NO;
}

- (void)hide
{
    self.coverView.hidden = YES;
}

// 隐藏
- (void)hideReportCover
{
    [self hide];
}

- (void)setUIReason
{
    //整个View的背景颜色
    AppDelegate *appD = [UIApplication sharedApplication].delegate;
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [appD.window addSubview:coverView];
    _coverView = coverView;
    //添加一个手势 查看是否显示或者隐藏显示
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideReportCover)];
    [coverView addGestureRecognizer:tap];

    UIView *reportReasonView = [[UIView alloc] init];
    reportReasonView.backgroundColor = [UIColor redColor];
    [coverView addSubview:reportReasonView];
    _reportReasonView = reportReasonView;
    reportReasonView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.95];
    [reportReasonView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [reportReasonView autoSetDimension:ALDimensionHeight toSize:335];
   
    //添加举报视频的title
    UILabel *reportTitle  = [[UILabel alloc] init];
    [reportReasonView addSubview:reportTitle];
    reportTitle.text = kE_GlobalZH(@"report_user");
    [reportTitle setTextColor:[UIColor colorWithHexString:@"#5D5854"]];
    reportTitle.font = [UIFont boldSystemFontOfSize:17];
    
    [reportTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:17];
    [reportTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];

    NSArray *arrayCon = @[kE_GlobalZH(@"vulgar_pro"), kE_GlobalZH(@"rubbissh_ad"),kE_GlobalZH(@"break_the_law"), kE_GlobalZH(@"deveive"), kE_GlobalZH(@"people_attack"),kE_GlobalZH(@"e_else")];
    for (NSInteger i = 0; i < arrayCon.count ; i++)
    {
        CGFloat btnHeight = 47.f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = arrayCon[i];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [reportReasonView addSubview:button];
        button.frame = CGRectMake(0, btnHeight * i + 50, ScreenWidth, btnHeight);
        [button setTitleColor:[UIColor colorWithHexString:@"#5D5854"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 14];
        
        UIView *btnLine = [[UIView alloc] init];
        [reportReasonView addSubview:btnLine];
        btnLine.backgroundColor = [UIColor colorWithHexString:@"#5D5854" alpha:0.2];
        [btnLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:button];
        [btnLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [btnLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [btnLine autoSetDimension:ALDimensionHeight toSize:0.5f];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportWithReason:)])
    {
        [self.delegate reportWithReason:button.currentTitle];
    }
}
@end
