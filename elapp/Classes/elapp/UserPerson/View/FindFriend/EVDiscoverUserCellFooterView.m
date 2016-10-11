//
//  EVDiscoverUserCellFooterView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVDiscoverUserCellFooterView.h"
#import <PureLayout.h>

@implementation EVDiscoverUserCellFooterView

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button autoSetDimensionsToSize:CGSizeMake(80, 40)];
    [button setTitle:kE_GlobalZH(@"check_more") forState:UIControlStateNormal];
    button.titleLabel.font = CCBoldFont(12);
    button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonDidClick:(UIButton *) button
{
    if ( self.action )
    {
        self.action();
    }
}

+ (instancetype) sectionFooterForTableView:(UITableView *)tableView
{
    static NSString *footerIndetifier = @"footerView";
    EVDiscoverUserCellFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIndetifier];
    if ( footerView == nil )
    {
        footerView = [[EVDiscoverUserCellFooterView alloc] initWithReuseIdentifier:footerIndetifier];
    }
    return footerView;
}

@end
