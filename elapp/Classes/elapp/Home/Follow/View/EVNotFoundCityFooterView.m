//
//  EVNotFoundCityFooterView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotFoundCityFooterView.h"
#import <PureLayout.h>

@interface EVNotFoundCityFooterView()

@property ( weak, nonatomic ) UILabel *notFoundLabel;
@property ( weak, nonatomic ) UIView *topLine;
@property ( weak, nonatomic ) UIView *bottomLine;
@property ( copy, nonatomic ) ClickLabelBlock action;

@end

@implementation EVNotFoundCityFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubviews];
        
    }
    return self;
}

- (void)createSubviews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] init];
    [self.contentView addSubview:topLine];
    self.topLine = topLine;
//    topLine.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomLine = bottomView;
//    bottomView.backgroundColor = topLine.backgroundColor;
    
    UILabel *notFoundLabel = [[UILabel alloc] init];
    [self.contentView addSubview:notFoundLabel];
    self.notFoundLabel = notFoundLabel;
    notFoundLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel)];
    [notFoundLabel addGestureRecognizer:tapGesture];
    
    [_notFoundLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_notFoundLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_notFoundLabel autoSetDimension:ALDimensionWidth toSize:205];
    _notFoundLabel.font = [UIFont systemFontOfSize:12];
    _notFoundLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    _notFoundLabel.textAlignment = NSTextAlignmentCenter;
    _notFoundLabel.numberOfLines = 0;
    
    [_topLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_topLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_topLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [_topLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
    [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [_bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setText:(NSString *)text
{
    _text = text;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:_text attributes:@{NSParagraphStyleAttributeName : style}];
    self.notFoundLabel.attributedText = attText;
}

+ (instancetype) sectionFooterForTableView:(UITableView *)tableView
{
    static NSString *footerIndetifier = @"EVNotFoundCityFooterView";
    EVNotFoundCityFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIndetifier];
    if ( footerView == nil )
    {
        footerView = [[EVNotFoundCityFooterView alloc] initWithReuseIdentifier:footerIndetifier];
    }
    return footerView;
}

- (void)tapLabel
{
    if ( self.action )
    {
        self.action();
    }
}

- (void)setClickLabelAction:(ClickLabelBlock)action
{
    self.action = action;
}

@end
